gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
onError = require('../errors')

gulp.task 'svgmin', ['clean:svg'], ->
	return gulp.src('src/svg/**/*.svg')
		.pipe $.plumber errorHandler: onError
		.pipe $.cache $.svgmin()
		.pipe gulp.dest 'app/svg/'
		.pipe gulp.dest 'docs/styleguide/svg'

gulp.task 'symbols', ['svgmin'], ->
	return gulp.src('src/svg/symbols/*.svg')
		.pipe $.plumber(errorHandler: onError)
		.pipe $.cache($.svgmin())
		.pipe $.svgstore(
			fileName: 'symbols.svg'
			inlineSvg: true
		)
		.pipe $.cheerio(
			run: (jQuery) ->
				jQuery('[fill]').attr 'fill', 'currentColor'
				jQuery('[stroke]').attr 'stroke', 'currentColor'
			parserOptions:
				xmlMode: true
		)
		.pipe gulp.dest( 'docs/styleguide/includes' )
		.pipe gulp.dest( 'src/jade/includes' )

gulp.task 'svg', ['symbols'], ->
	return gulp.src([
		'src/jade/includes/symbols.svg'
	])
		.pipe $.cheerio(
			run: (jQuery) ->
				jQuery('svg').css 
					position: 'absolute'
					height: '0'
					width: '0'
					visibility: 'hidden'
			)
		.pipe gulp.dest('src/jade/includes')