module.exports = (grunt) ->
  'use strict'

  # Track execution time
  require('time-grunt') grunt;

  # Load grunt tasks automatically
  require('jit-grunt') grunt

  # Define the configuration for all the tasks
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    # Specify environment variables
    env:
      tinypng:
        api:
          key: do ->
            envKey = process.env.TINYPNG_API_KEY
            if envKey
              grunt.log.ok('Reading tinypng API key from environment')
              return envKey
            else
              grunt.log.ok('Reading tinypng API key from `tinypng.yml`')
              return grunt.file.readYAML('tinypng.yml').key

    # Specify your source and build directory structure
    path:
      source:
        root: 'source'
        images: '<%= path.source.root %>/images'
        watermark: '<%= path.source.root %>/watermark'

      build:
        root: 'build'
        images: '<%= path.build.root %>'

    # Specify files
    file:
      source:
        watermark: '<%= path.source.watermark %>/logo.png'

      build:
        images:
          hash: '<%= path.build.images %>/hash.json'


  grunt.loadTasks 'tasks'

  ###
  Default task
  ###
  grunt.registerTask 'default', [
    'clean'
    'gm'
    'size_report'
    'watch'
  ]

  ###
  A task for your production environment
  ###
  grunt.registerTask 'build', [
    'clean'
    'gm'
    'tinypng'
    'size_report'
  ]

  ###
  A task for a static server with a watch
  ###
  grunt.registerTask 'serve', [
    'watch'
  ]

  return