gulp = require 'gulp'
rimraf = require 'rimraf'
rename = require 'gulp-rename'
inject = require 'gulp-inject-string'
postcss = require 'gulp-postcss'
cssnext = require 'cssnext'
sequence = require 'run-sequence'
cssimport = require 'postcss-import'
cssnesting = require 'postcss-nesting'
browserSync = require('browser-sync').create()

# Clean distribution folder
gulp.task 'clean', (callback) ->
  rimraf 'dist', callback

# Postcss task - Transpile CSS
gulp.task 'postcss', (callback) ->
  processors = [
    cssimport
    cssnesting
    cssnext(
      'browers': [ 'last 2 version' ]
      'customProperties': true
      'colorFunction': true
      'customSelectors': true
      'sourcemap': true
      'compress': true
      'import': true)
  ]
  gulp.src('colors/*.css').pipe(inject.append('@import ../material')).pipe(postcss(processors)).pipe(rename(prefix: 'material-')).pipe(rename((path) ->
    path.prefix += 'material-'
    path.basename = path.basename.replace('-default', '')
    return
  )).pipe gulp.dest('dist')

# Initialize browsersync for development
gulp.task 'browsersync', (callback) ->
  browserSync.init {
    server:
      baseDir: ''
    port: 8080
  }, callback

# Reload browsersync with new css
gulp.task 'reload', [ 'postcss' ], (callback) ->
  browserSync.reload()
  callback()

# Watch
gulp.task 'watch', [ 'postcss', 'browsersync' ], (callback) ->
  gulp.watch [ 'material.css', 'colors/*.css' ], [ 'reload' ]

# Build themes
gulp.task 'build', (callback) ->
  sequence 'clean', 'postcss', callback
