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
			if $this.closest('.js-dropdown-option-parent').find('.contenteditable-dropdown').length
				$dropdown = $(this).closest('.js-dropdown-option-parent').find('.contenteditable-dropdown')
				MKBL.contenteditableDropdown($dropdown)

$('.js-dropdown-trigger').on 'click',  ->
	if $(this).find('.contenteditable-dropdown').length
		$dropdown = $(this).closest('.contenteditable-dropdown')
	else
		$dropdown = $(this).siblings('.contenteditable-dropdown')
	MKBL.contenteditableDropdown($dropdown)

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

# STOP EVENT PROPAGATION
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

$ ->
	MKBL.equalheight('.banner-module','.banner-module > div', 940)
	MKBL.equalheight('.main-header','.equal-height', 1024)
	MKBL.flowBoxSliderSetup()
	MKBL.setupContenteditable()
	

$(window).on 'resize', ->
	MKBL.equalheight('.main-header','.equal-height', 1024)
	MKBL.equalheight('.banner-module','.banner-module > div', 940)
	MKBL.flowBoxSliderSetup()
	$('.modal-module').addClass('is-hidden')
	MKBL.setupContenteditable()

$(window).on 'load', ->
	$('body').css('opacity',1)