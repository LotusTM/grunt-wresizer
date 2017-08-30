###
GM
https://github.com/h0ward/grunt-gm
Batch process your images with gm
###
module.exports = (grunt) ->

  # Requires
  path  = require('path')
  async = require('async')

  # Settings
  sourceDirName      = '_source'
  destDirName        = 'compressed'
  transparentDirName = '--transparent'
  watermarkDirName   = '--watermarked'

  watermarkFile      = grunt.template.process('<%= file.source.watermark %>')
  watermarkOpacity   = '50%'
  watermarkGravity   = 'SouthEast'
  watermarkPadding   = '+50+30' # horizontal, vertical
  bgColor            = '#fff'
  bgColorName        = 'white'

  quality            = 100

  # Task types
  tasks = {
    transparent:
      keepTransparency: true
      watermark: false
      trim: false
      maxWidth: '1200'
      maxHeight: '1200'
    transparentWatermarked:
      keepTransparency: true
      watermark: true
      trim: false
      maxWidth: '1200'
      maxHeight: '1200'
    other:
      keepTransparency: false
      watermark: false
      trim: false
      maxWidth: '1200'
      maxHeight: '1200'
    card:
      keepTransparency: false
      watermark: false
      trim: true
      maxWidth: '400'
      maxHeight: '400'
      dir: 'card'
    otherWatermarked:
      keepTransparency: false
      watermark: true
      trim: false
      maxWidth: '1200'
      maxHeight: '1200'
  }

  # Defining task constructor
  # @param {object} [tasks=tasks]                  - List of tasks whith specific parameters
  #                                                  for execution
  # @param {bool} tasks[taskName].keepTransparency - Preserve transparency in executed task or no
  # @param {bool} tasks[taskName].watermark        - Watermark images in executed task or no
  #
  # @return {object}

  Task = (tasks) ->

    _self  = @
    _tasks = tasks || {}

    async.forEachOf _tasks, ((task, taskName, done) ->

      # reading settings for task
      _isKeepTransparency = task.keepTransparency
      _isWatermark        = task.watermark
      _isTrim        = task.trim

      { dir, maxWidth, maxHeight } = task

      # consturcting Grunt task object
      _self[taskName] = {}

      _self[taskName].options = {
        skipExisting: false
      }

      _self[taskName].files = [
        expand: true
        cwd: '<%= path.source.images %>'
        src: do ->
          if _isKeepTransparency
            glob = '{,**/*' + transparentDirName + '*/**/}'
          else
            glob = '{,**/}'
          glob + '*.{jpg,jpeg,gif,png}'
        dest: '<%= path.build.images %>/'
        # change extension in case of forcing conversion to non-transparent format
        ext: do -> if _isKeepTransparency then return '.png' else return '.jpg'
        extDot: 'last'
        tasks: [
            do -> if _isTrim then return { trim: ['-'] }
          ,
            do ->
              # resize
              params = {
                resize: [maxWidth, maxHeight]
                quality: [quality]
              }
              # add specified background in case of conversion of transparent image to `jpg`
              if not _isKeepTransparency
                params.background = ['#fff']
                params.flatten = [true]
              params
          ,
            do -> if _isWatermark then return {
              command: ['composite']
              quality: [quality]
              # dissolve: ['50%']
              gravity: [watermarkGravity]
              geometry: [watermarkPadding]
              in: [watermarkFile]
            }
        ]
        rename: (dest, src) ->
          dirname = path.dirname(src)
          basename = path.basename(src)

          # added `watermarked` tag in dir name in case we're watermarking images
          if _isWatermark
            dirname = dirname.replace(/(_source.*?)\//, '$1' + watermarkDirName + '/')

          # replace `transparent` in dir name with specified background color name
          # in case of conversion of transparent image to `jpg`
          if not _isKeepTransparency
            dirname = dirname.replace(transparentDirName, '--' + bgColorName)

          dirname = dirname
            # replace `source` dir name with `compressed`
            .replace(sourceDirName, destDirName)
            # replace `width` in dir name with target width
            .replace(/--[\d]*--/, '--' + maxWidth + '--')

          if dir
            dirname = path.join(dirname, dir)

          return path.join(dest, dirname, basename)
      ]

      done()
      return
    ), (err) ->
      if err
        grunt.log.error err
      return

    _self

  @config 'gm', new Task(tasks)