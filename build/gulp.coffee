# REQUIREMENTS
gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
browserSync = require('browser-sync')
runSequence = require('run-sequence').use(gulp)
onError = require('./errors')

requireDir = require('require-dir')
# Require all tasks in gulp/tasks, including subfolders
requireDir './tasks',
  recurse: true

gulp.task 'watch', ['browser-sync'], ->
	gulp.watch [ 'src/static/**/*' ], ['static']
	gulp.watch [ 'src/img/**/*' ], ['img']
	gulp.watch [ 'src/svg/**/*.svg' ], ['svg']
	gulp.watch [ 'src/styl/**/*.styl' ], ['styl']
	gulp.watch [ 'src/jade/*.jade', 'src/jade/includes/*.jade' ], ['jade']
	gulp.watch [ 'src/font/**/*' ], ['font']
	gulp.watch [ 'src/coffee/**/**/*.coffee' ], ['coffee']
	gulp.watch [ './tmp/css/*' ], ['css', 'styleguide']
	gulp.watch [ './build/styleguide/**/*', './README.md' ], ['styleguide']
	gulp.watch [ './tmp/js/**/*.js' ], ['js']


gulp.task 'default', (cb) ->
	runSequence 'coffee',
		'styl',
		'bower',
		'jade',
		'font',
		'static', 
		'img', 
		'svg',
		'css',
		'js',
		'watch',
		'styleguide'
		->


gulp.task 'browser-sync', ->
	browserSync 
		# proxy: 'localhost:3000'
		port: 8088
		open: false
		tunnel: false
		online: true
		logPrefix: 'Cognizant'
		# logLevel: 'debug'
		snippetOptions:
		    ignorePaths: "templates/*.html",
		    rule:
		        match: /<body>/i,
		        fn: (snippet, match) ->
		            return snippet + match;
		files: {
			'app/**/*'
			'docs/styleguide/**/*'
		}
		server: {
			baseDir: [
				'app'
				'docs'
			]
		}


gulp.task 'bs-reload', ->
	browserSync.reload()

gulp.task 'clear', (done) ->
  $.cache.clearAll done
