###*
 * COGNIZANT START EVENTS.JS
###

$('input').on 'touchstart', ->
	$(this).focus()

$('.search-module--main .search__input').on 'keyup',  ->
	if $(this).val() != ''
		MKBL.activationOn($('.search__CTA'))
	else
		MKBL.activationOff($('.search__CTA'))

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
	.on 'keydown', '[contenteditable]', (e) ->
		keyCode = e.keyCode or e.which
		if keyCode == 13
			e.preventDefault()

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

$('.cogv1_search__favorites').on 'click',  ->
	MKBL.activationToggle($(this).closest('.cogv1_search__section-right').siblings('.cogv1_search__flyout'))

$('.js-dropdown-option').on 'click',  ->
	$this = $(this)
	MKBL.contenteditableDropdownSelect($this)

$('.interactive-svg').on 'click',  ->
	MKBL.activationToggle($(this))

$('.js-edit-profile').on 'click',  ->
	MKBL.activationToggle($('.edit-profile-overlay'))

$('.js-open-modal-module').on 'click',  ->
	$this = $(this)
	MKBL.modal($this)

$('.js-flow-box-flyout__trigger').on 'click',  ->
	$parent = $(this).closest('.flow-box__CTA')
	MKBL.activationToggle($parent)

$('.js-search-share-flyout__trigger').on 'click',  ->
	$parent = $(this).closest('.cogv1_search__section-right')
	MKBL.activationToggle($parent, 'flyout-is-active')

$('.js-share-flyout__trigger').on 'click',  ->
	$parent = $(this).closest('.search__share-flyout__wrapper')
	MKBL.shareFlyout($parent)

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
		MKBL.activationOff($('.js-dropdown-trigger'))
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

	if !$(event.target).closest('.js-video-play').length and !$(event.target).closest('.video-module').length
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
	MKBL.flowBoxSliderSetup()
	MKBL.setupContenteditable()
	new Waypoint
		element: $('.cogv1_article-nav')
		offset: '50%'
		handler: (direction) ->
			if direction == 'down'
				$(@.element).addClass('is-scrolling')
			else
				$(@.element).removeClass('is-scrolling')

$(window).on 'debouncedresize', ->
	MKBL.equalheight('.main-header','.js-equal-height', 1024)
	MKBL.equalheight('.social-group__groups','.js-equal-height', 680)
	MKBL.equalheight('.three-group__groups','.three-group__content', 940)
	MKBL.flowBoxSliderSetup()
	$('.modal-module').addClass('is-hidden')
	MKBL.setupContenteditable()

$(window).on 'load', ->
	MKBL.equalheight('.main-header','.js-equal-height', 1024)
	MKBL.equalheight('.social-group__groups','.js-equal-height', 680)
	MKBL.equalheight('.three-group__groups','.three-group__content', 940)
	$('body').css('opacity',1)