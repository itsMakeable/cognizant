gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
onError = require('../errors')
browserSync = require('browser-sync')

gulp.task 'jade-watch', ->
	return gulp.src(['src/jade/**/*.jade','!src/jade/layouts/**/*.jade','!src/jade/includes/**/*.jade'])
		.pipe $.plumber(errorHandler: onError)
		.pipe $.accord 'jade',
			pretty: true
		.pipe gulp.dest('app')

gulp.task('jade', ['jade-watch'], browserSync.reload);