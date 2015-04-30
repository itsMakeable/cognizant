gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
onError = require('../errors')
browserSync = require('browser-sync')
stylish = require('jshint-stylish')

gulp.task 'coffee', ->
	gulp.src([
		'src/coffee/**/**/*.coffee'
	])
		.pipe $.plumber(errorHandler: onError)
		.pipe($.order([
			'**/plugins/*'
		]))
		.pipe $.concat('zapp.js')
		.pipe $.accord('coffee-script')
		.pipe $.jshint()
		.pipe $.jshint.reporter(stylish)
		.pipe gulp.dest('./tmp/js')

gulp.task 'js-watch', ->
	gulp.src(['./tmp/js/vendor/*.js','./tmp/js/*.js'])
		.pipe($.order([
			'tmp/js/vendor/*.js'
			'tmp/js/*.js'
		]))
		# .pipe($.accord('uglify-js', {
		# 	beautify: true
		# 	mangle: false
		# }))
		.pipe $.concat 'main.js'
		.pipe gulp.dest 'app'
		.pipe gulp.dest('./docs/styleguide/js')

gulp.task('js', ['js-watch'], browserSync.reload);