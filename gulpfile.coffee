gulp = require 'gulp'
rimraf = require 'rimraf'
rename = require 'gulp-rename'
deploy = require 'gulp-deploy-git'
inject = require 'gulp-inject-string'
postcss = require 'gulp-postcss'
cssnext = require 'cssnext'
sequence = require 'run-sequence'
cssimport = require 'postcss-import'
cssnesting = require 'postcss-nesting'
browserSync = require('browser-sync').create()
exec = require('child_process').exec

# Common directories
dir =
  colors: 'colors'
  dist: 'dist'

# Git deploy configuration
git =
  template: '%B\nBuilt from %H.'
  commit: undefined
  login: process.env.GH_LOGIN
  token: process.env.GH_TOKEN
  repo: process.env.GIT_REPO

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
  gulp.src("#{dir.colors}/*.css").pipe(inject.append('@import ../material')).pipe(postcss(processors)).pipe(rename(prefix: 'material-')).pipe(rename((path) ->
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
  gulp.watch [ 'material.css', "#{dir.colors}/*.css" ], [ 'reload' ]

# Build themes
gulp.task 'build', (callback) ->
  sequence 'clean', 'postcss', callback

# Prepare git information
gulp.task 'git:info', (callback) ->
  exec "git log --format='#{git.template}' -1", (err, stdout, stderr) ->
    git.commit = stdout
    callback err

# Deploy live demo to git
gulp.task 'deploy', [ 'git:info' ], (callback) ->
  gulp.src("#{dir.dist}/**/*").pipe deploy(
    repository: "https://#{git.login}:#{git.token}@#{git.repo}"
    branches: [ 'HEAD' ]
    remoteBranch: 'gh-pages'
    prefix: dir.dist
    message: git.commit).on 'error', (err) ->
      callback err
