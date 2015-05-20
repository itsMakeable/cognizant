gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
browserSync = require('browser-sync')

onError = (error) ->
	$.notify.onError('ERROR: <%- error.plugin %>') error
	$.util.beep()
	$.util.log '======= ERROR. ========\n'
	$.util.log error

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
			# url: true
			compress: false
			url:
    			name: 'embedurl'
		})
		.pipe $.rename('index.css')
		# .pipe $.csscomb()
		.pipe gulp.dest('./tmp/css')


gulp.task 'css', ->
	return gulp.src('./tmp/css/**/*.css')
		.pipe $.plumber(errorHandler: onError)
		.pipe $.concat('main.css')
		.pipe $.csscomb()
		.pipe $.bless()
		.pipe gulp.dest('app')
		.pipe browserSync.reload({stream:true})


gulp.task 'styleguide', ->
	StyleGuide = require('styleguidejs')
	sg = new StyleGuide
	sg.addFile 'app/main.css'
	sg.render
		extraCss: [ 

		]
		extraJs: [ 
			'build/styleguide/holder.min.js' 
			'docs/styleguide/js/main.js', 
		]
		templateJs: 'build/styleguide/styleguide.js'
		template: 'build/styleguide/index.jade'
		outputFile: 'docs/styleguide/index.html'
