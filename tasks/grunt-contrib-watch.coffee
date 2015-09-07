###
Watch
https://github.com/gruntjs/grunt-contrib-watch
Watches scss, js etc for changes and compiles them
###
module.exports = ->
  @config 'watch',
    configs:
      files: ['gruntfile.coffee', 'tasks/*']
      options:
        reload: true
    images:
      files: ['<%= path.source.images %>/{,**/}*']
      tasks: ['newer:gm']
    watermarks:
      files: ['<%= path.source.watermark %>/{,**/}*']
      tasks: [
        'gm:transparentWatermarked'
        'gm:otherWatermarked'
      ]