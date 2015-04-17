gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
onError = require('../errors')
browserSync = require('browser-sync')

# Stylus Plugins
nib = require('nib')
del = require('del')
axis = require('axis')
rupture = require('rupture')
jeet = require('jeet')


gulp.task 'styl', ->
	# compress: true
	# .pipe(autoprefixer())
	return gulp.src('src/styl/index.styl')
		.pipe $.plumber(errorHandler: onError)
		.pipe $.accord('stylus', {
			use: [
				axis()
				jeet()
				rupture()
				nib()
			]
			include: ['src/styl']
			url: true
		})
		.pipe $.rename('index.css')
		.pipe gulp.dest('./.tmp/css')


gulp.task 'css', ->
	return gulp.src('./.tmp/css/**/*.css')
		.pipe $.concat('index.css')
		.pipe($.cssmin())
		.pipe gulp.dest('app')
		.pipe(browserSync.reload({stream:true}))


gulp.task 'styldoc', ->
	return gulp.src('src/styl/index.styl')
		# .pipe $.plumber(errorHandler: onError)
		.pipe $.styledocco(
			out: 'docs/styleguide'
			name: 'Cognizant'
			preproccesor: 'stylus -u axis() jeet() rupture() nib()'
			include: ['app/index.css']
		)
