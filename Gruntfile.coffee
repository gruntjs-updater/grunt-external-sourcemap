# /*
#  * grunt-external-sourcemap
#  * https://github.com/goodeggs/grunt-external-sourcemap
#  *
#  * Copyright (c) 2013 Good Eggs
#  * Licensed under the MIT license.
#  */

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    # Before generating any new files, remove any previously-created files.
    clean: {
      tests: ['test/fixtures/*', 'test/expected/*'],
    },

    #run
    shell:
      options:
        async: false
        stdout: true
        stderr: true
        failOnError: true

      browserify:
        command: [
          'browserify'
          'tasks/external_sourcemap.coffee'
          '-t coffeeify'
          '--extension=.coffee'
          '-d'
          '-o test/fixtures/external_sourcemap.js'
        ].join ' '

      mkdirNested:
        command: 'mkdir test/fixtures/nested'

      copyJsToNested:
        command: 'cp test/fixtures/external_sourcemap.js test/fixtures/nested'

    # Configuration to be run (and then tested).
    external_sourcemap: {
      default_options: {
        options: { }
        files: {
          'test/expected/default_options': ['test/fixtures/external_sourcemap.js']
        }
      },
      cwd_options: {
        options: {}
        cwd: 'test/fixtures'
        src: 'external_sourcemap.js'
        dest: 'test/expected/cwd_options'
      },
      strip_source: {
        options: { removeSourcesContent: true }
        files: {
          'test/expected/strip_source': ['test/fixtures/external_sourcemap.js']
        }
      },
      relative_path: {
        options: {}
        cwd: 'test/fixtures'
        src: 'nested/external_sourcemap.js'
        dest: 'test/expected/relative_path'
      }
    },

    # Unit tests.
    nodeunit: {
      tests: ['test/*_test.js'],
    },

  # Actually load this plugin's task(s).
  grunt.loadTasks 'tasks'

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-shell'

  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask 'test', ['clean', 'shell:browserify', 'shell:mkdirNested', 'shell:copyJsToNested', 'external_sourcemap', 'nodeunit']

  # By default, lint and run all tests.
  grunt.registerTask 'default', ['test']
