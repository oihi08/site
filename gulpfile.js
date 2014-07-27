"use strict"

// -- DEPENDENCIES -------------------------------------------------------------
var gulp    = require('gulp');
var coffee  = require('gulp-coffee');
var concat  = require('gulp-concat');
var connect = require('gulp-connect');
var flatten = require('gulp-flatten');
var header  = require('gulp-header');
var uglify  = require('gulp-uglify');
var gutil   = require('gulp-util');
var stylus  = require('gulp-stylus');
var yml     = require('gulp-yml');
var pkg     = require('./package.json');

// -- FILES --------------------------------------------------------------------
var source = {
  coffee: [ 'source/entities/**/*.coffee',
            'source/atom/**/*.coffee',
            'source/molecule/**/*.coffee',
            'source/organism/**/*.coffee',
            'source/app.coffee',
            'source/app.*.coffee'
            ],
  styl  : [ 'source/styles/__init.styl',
            'source/styles/atom.*.styl',
            'source/styles/molecule.*.styl',
            'source/styles/organism.*.styl',
            'source/styles/app.styl',
            'source/styles/app.*.styl']};

var banner = ['/**',
  ' * <%= pkg.name %> - <%= pkg.description %>',
  ' * @version v<%= pkg.version %>',
  ' * @link    <%= pkg.homepage %>',
  ' * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)',
  ' * @license <%= pkg.license %>',
  ' */',
  ''].join('\n');

// -- TASKS --------------------------------------------------------------------
gulp.task('coffee', function() {
  gulp.src(source.coffee)
    .pipe(concat(pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(path.assets + '/js'));
});

gulp.task('styl', function() {
  gulp.src(source.styl)
    .pipe(concat(pkg.name + '.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(path.assets + '/css'));
});

gulp.task('init', function() {
  gulp.run(['coffee', 'styl'])
});

gulp.task('default', function() {
  gulp.watch(source.coffee, ['coffee']);
  gulp.watch(source.styl, ['styl']);
});
