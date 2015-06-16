###*
 * COGNIZANT START EVENTS.JS
###

$('input').on 'touchstart', ->
	$(this).focus()

$('.cogv1-smart-search__input').on 'keyup',  ->
	if $(this).val() != ''
		MKBL.activationOn($('.cogv1-smart-search__icon--right'))
	else
		MKBL.activationOff($('.cogv1-smart-search__icon--right'))

$('.search-module--main .search__input').on 'keyup',  ->
	if $(this).val() != ''
		MKBL.activationOn($('.search__CTA'))
	else
		MKBL.activationOff($('.search__CTA'))

$('.cogv1-smart-search__input').on 'keyup', (e) ->
	MKBL.activationOn($('.cogv1-smart-search__dropdown'))
	MKBL.searchAutocomplete($(this), $('.cogv1-smart-search__dropdown .js-search-text'))
	if !$('.cogv1-smart-search__dropdown .js-search-text').find('span').length
		MKBL.activationOff($('.cogv1-smart-search__dropdown'))
		MKBL.activationOn($('.cogv1-smart-search__results'))


$('.cogv1_article__save__list').on 'click',  ->
	MKBL.activationOff($('.cogv1_article__save__list'))
	MKBL.activationOn($(this))

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

$('.js-cogv1_icon-header__share-flyout__trigger, .article-mobile__share').on 'click',  ->
	MKBL.activationToggle($(this).siblings('.js-share-flyout'))

$('.js-dropdown-trigger').on 'click',  ->
	$trigger = $(this)
	if $(this).find('.contenteditable-dropdown').length
		$dropdown = $(this).closest('.contenteditable-dropdown')
	else
		$dropdown = $(this).siblings('.contenteditable-dropdown')
	MKBL.contenteditableDropdown($dropdown, $trigger)

$('.cogv1-smart-search__icon--right').on 'click',  ->
	MKBL.activationOn($('.cogv1-smart-search__results'))

$('.cogv1_search__favorites').on 'click',  ->
	MKBL.activationToggle($(this).closest('.cogv1_search__section-right').siblings('.cogv1_search__flyout'))

$('.cogv1_article-subhead__highlight .js-share-flyout__trigger').on 'click',  ->
	MKBL.activationToggle($(this))
	MKBL.activationToggle($(this).siblings('.js-share-flyout'))
	MKBL.activationToggle($(this).closest('.cogv1_article-subhead__highlight'))

$('.js-dropdown-option').on 'click',  ->
	$this = $(this)
	MKBL.contenteditableDropdownSelect($this)

$('.cogv1_article__save__add').on 'click', (e) ->
	e.preventDefault()
	e.stopPropagation()
	MKBL.activationToggle($(this).children('.add-action'))
	$('.add-action.is-active .cogv1_article__save__input').trigger('focus')

$('.js-toggle-save-overlay').on 'click',  ->
	MKBL.activationToggle($(this).closest('.flow-box').find('.flow-box__folder-save'))
	if $(this).hasClass('js-toggle-save-overlay__icon')
		MKBL.activationOff($(this).closest('.flow-box').find('.flow-box__content .js-toggle-save-overlay'))

$('.interactive-svg').on 'click',  ->
	MKBL.activationToggle($(this))

$('.js-edit-profile').on 'click',  ->
	MKBL.activationToggle($('.edit-profile-overlay'))
	MKBL.overlay()

$('.js-save-article').on 'click',  ->
	MKBL.activationToggle($('.cogv1_article__save'))
	MKBL.activationToggle($('.cogv1_article-subhead__save-article .interactive-svg'))

$('.js-smart-search').on 'click',  ->
	MKBL.activationToggle($('.smart-search-overlay'))
	MKBL.overlay()

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
	MKBL.activationToggle($parent, 'flyout-is-active')

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
	$activeSlide = $slider.find('.flow-box-slider-group.is-active')

	direction = 'prev'
	if $(this).hasClass('is-right')
		direction = 'next'

	MKBL.flowBoxSlider($slider, $slides, $activeSlide, direction)

$('.share-icons-list .interactive-svg').on 'click',  ->
	MKBL.activationToggle($(this).closest('.share-icons-list'))

$('.social-group__icon').on 'click',  ->
	$this = $(this)
	MKBL.socialSlider($this)

$('.js-video-play').on 'click', (e) ->
	$this = $(this)
	MKBL.playVideo(e, $this)

$(document).on 'click', (event) ->
	MKBL.activationOff($('.cogv1-smart-search__dropdown'))

$(document).on 'click touchstart', (event) ->
	if !$(event.target).closest('.js-open-modal-module').length
		$('.modal-module').addClass('is-hidden')
		
	if !$(event.target).closest('.compact-profile-box__aside').length
		MKBL.activationOff($('.compact-profile-box__flyout'))
		
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

	if !$(event.target).closest('.js-video-play').length and !$(event.target).closest('.video-section').length
		$('.video-section').removeClass('is-active')
		$('.video-section.is-active').each ->
			MKBL.stopVideo(e, $(this))
$ ->
	MKBL.flowBoxSliderSetup()
	MKBL.setupContenteditable()
	if $(window).width() > 1024 and $('.cogv1_article-nav').length
		MKBL.articleNavWaypoints()

	MKBL.reduceFontSize($('.profile-box__text h2'))

$(window).on 'debouncedresize', ->
	MKBL.equalheight('.main-header','.js-equal-height', 1024)
	MKBL.equalheight('.social-group__groups','.js-equal-height', 680)
	MKBL.equalheight('.three-group__groups','.three-group__content', 940)
	MKBL.flowBoxSliderSetup()
	$('.modal-module').addClass('is-hidden')
	MKBL.setupContenteditable()
	if $(window).width() > 1024 and $('.cogv1_article-nav').length
		MKBL.articleNavWaypoints()

$(window).on 'load', ->
	MKBL.equalheight('.main-header','.js-equal-height', 1024)
	MKBL.equalheight('.social-group__groups','.js-equal-height', 680)
	MKBL.equalheight('.three-group__groups','.three-group__content', 940)
	# $('body').css('opacity',1)