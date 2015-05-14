###*
 * COGNIZANT START EVENTS.JS
###

$('[contenteditable]').on 'click',  ->
	$this = $(this)
	MKBL.prepareContenteditable($this)

$('body')
	.on 'focus', '[contenteditable]', ->
		$this = $(this)
		$this.data 'before', $this.html()
		return $this
	.on 'blur keyup paste input', '[contenteditable]', ->
		$this = $(this)
		if $this.data('before') isnt $this.html()
			$this.data 'before', $this.html()
			$this.trigger('change')
			MKBL.contenteditableDropdownAutocomplete($this)

$('.search-module').on 'click', '.js-dropdown-trigger',  ->
	$parent = $(this).closest('.search-module')
	MKBL.activationToggle($parent, 'is-active')

$('.js-dropdown-trigger').on 'click',  ->
	$trigger = $(this)
	if $(this).find('.contenteditable-dropdown').length
		$dropdown = $(this).closest('.contenteditable-dropdown')
	else
		$dropdown = $(this).siblings('.contenteditable-dropdown')
	MKBL.contenteditableDropdown($dropdown, $trigger)

$('.js-dropdown-option').on 'click',  ->
	$this = $(this)
	MKBL.contenteditableDropdownSelect($this)

$('.js-open-modal-module').on 'click',  ->
	$this = $(this)
	MKBL.modal($this)

$('.js-share-flyout__trigger').on 'click',  ->
	$this = $(this)
	MKBL.shareFlyout($this)

$('.compact-profile-box__aside .icon').on 'click',  ->
	$this = $(this)
	$flyoutType = $this.data('flyout')
	MKBL.profileCompactFlyout($this, $flyoutType)

$('.profile-box__aside .icon').on 'click',  ->
	$this = $(this)
	$flyoutType = $this.data('flyout')
	MKBL.profileFlyout($this, $flyoutType)

$('.slider-nav__control').on 'click', ->
	$slider = $(this).closest('.flow-box-slider')
	$slides = $slider.find('.flow-box-slider-group')
	$activeSlide = $slider.find('.is-active')

	direction = 'prev'
	if $(this).hasClass('is-right')
		direction = 'next'

	MKBL.flowBoxSlider($slider, $slides, $activeSlide, direction)

$('.social-group__icon').on 'click',  ->
	$this = $(this)
	MKBL.socialSlider($this)

$('.js-video-play').on 'click', (e) ->
	$this = $(this)
	MKBL.playVideo(e, $this)

$(document).on 'click', (event) ->
	if !$(event.target).closest('.js-open-modal-module').length
		$('.modal-module').addClass('is-hidden')
		
	if !$(event.target).closest('.js-dropdown-trigger').length
		$('.contenteditable-dropdown').velocity {height: 0}, 
			duration: 600,
			easing: [ 300, 30 ],
			delay: 0
			complete: () ->
				$(this).removeClass('is-active')

	if !$(event.target).closest('[contenteditable]').length and !$(event.target).closest('.is-editable .js-dropdown-option').length
		MKBL.endContenteditable()

	if !$(event.target).closest('.search-module .js-dropdown-trigger').length
		MKBL.activationOff($('.search-module'))

	if !$(event.target).closest('.js-video-play').length
		$('.video-module').removeClass('is-active')
		$('.video-module').each ->
			if $(this).hasClass('is-active')
				$video = $(this).find('iframe')
				videoURL = $video.attr('src')
				videoURL.replace("&autoplay=1", "")
				$video.attr('src','')
				setTimeout ->
					$video.attr('src',videoURL)
				, 1
		
$ ->
	MKBL.equalheight('.banner-module','.js-equal-height', 940)
	MKBL.equalheight('.main-header','.js-equal-height', 1024)
	MKBL.equalheight('.social-group__groups','.js-equal-height', 680)
	MKBL.equalheight('.three-group__groups','.three-group__content', 940)
	MKBL.flowBoxSliderSetup()
	MKBL.setupContenteditable()
	

$(window).on 'resize', ->
	MKBL.equalheight('.main-header','.js-equal-height', 1024)
	MKBL.equalheight('.banner-module','.banner-module > div', 940)
	MKBL.equalheight('.social-group__groups','.js-equal-height', 680)
	MKBL.equalheight('.three-group__groups','.three-group__content', 940)
	MKBL.flowBoxSliderSetup()
	$('.modal-module').addClass('is-hidden')
	MKBL.setupContenteditable()

$(window).on 'load', ->
	$('body').css('opacity',1)