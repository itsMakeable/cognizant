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
autoprefixer = require('autoprefixer-stylus')


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
				autoprefixer()
			]
			include: ['src/styl']
			url: true
			compress: false
		})
		.pipe $.rename('index.css')
		.pipe $.csscomb()
		.pipe gulp.dest('./tmp/css')


gulp.task 'css', ->
	return gulp.src('./tmp/css/**/*.css')
		.pipe $.concat('index.css')
		# .pipe $.cssmin()
		.pipe gulp.dest('app')
		.pipe browserSync.reload({stream:true})


gulp.task 'styleguide', ->
	StyleGuide = require('styleguidejs')
	sg = new StyleGuide
	sg.addFile 'tmp/css/index.css'
	sg.render
		extraCss: [ 
			'tmp/css/ProximaNova-Bold.css', 
			'tmp/css/ProximaNova-Reg.css',
			'tmp/css/ProximaNova-Light.css',
			'tmp/css/ProximaNova-RegIt.css',
			'tmp/css/ProximaNova-Sbold.css' 
		]
		extraJs: [ 'docs/holder.min.js' ]
		templateCss: 'docs/styleguide/template/styleguide.css'
		templateJs: 'docs/styleguide/template/styleguide.js'
		template: 'docs/styleguide/template/index.jade'
		outputFile: 'docs/styleguide/index.html'
