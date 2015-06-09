###*
 * COGNIZANT START APP.JS
###

MKBL = {}

## plugin for jQuery :contains to be case-insensitive
$.expr[':'].Contains = (a, i, m) ->
	(a.textContent or a.innerText or '').toUpperCase().indexOf(m[3].toUpperCase()) >= 0
	
###*
 * Remove Classes based on partial matches
 * @param  {[type]} removals  classes you want to remove
 * @param  {[type]} additions classes you want to add
###
$.fn.alterClass = (removals, additions) ->
	self = this
	if removals.indexOf('*') == -1
		# Use native jQuery methods if there is no wildcard matching
		self.removeClass removals
		return if !additions then self else self.addClass(additions)
	patt = new RegExp('\\s' + removals.replace(/\*/g, '[A-Za-z0-9-_]+').split(' ').join('\\s|\\s') + '\\s', 'g')
	self.each (i, it) ->
		cn = ' ' + it.className + ' '
		while patt.test(cn)
			cn = cn.replace(patt, ' ')
		it.className = $.trim(cn)
		return
	if !additions then self else self.addClass(additions)


(($) ->
  $event = $.event
  $special = undefined
  resizeTimeout = undefined
  $special = $event.special.debouncedresize =
    setup: ->
      $(@).on 'resize', $special.handler
      return
    teardown: ->
      $(@).off 'resize', $special.handler
      return
    handler: (event, execAsap) ->
      # Save the context
      context = this
      args = arguments

      dispatch = ->
        # set correct event type
        event.type = 'debouncedresize'
        $event.dispatch.apply context, args
        return

      if resizeTimeout
        clearTimeout resizeTimeout
      if execAsap then dispatch() else (resizeTimeout = setTimeout(dispatch, $special.threshold))
      return
    threshold: 150
  return
) jQuery

# Check array for a value
MKBL.checkArray = (needle) ->
	if typeof Array::indexOf == 'function'
		indexOf = Array::indexOf
	else
		indexOf = (needle) ->
			i = -1
			index = -1
			i = 0
			while i < @length
				if @[i] == needle
					index = i
					break
				i++
			index

	indexOf.call this, needle

###*
 * Converts matrix like rgba or transforms to an array
###
MKBL.matrixToArray = (str) ->
  str.match /(-?[0-9\.]+)/g

###*
 * This creates equal height children relative to the parent
 * @param  {[type]} container        the container of the elements that will be equal height
 * @param  {[type]} eqHeightChildren the elements that will be equal height
 * @param  {[type]} cutoff           the window width cutoff for the elements to be equal height
###
MKBL.equalheight = (container, eqHeightChildren, cutoff) ->
	if $(window).width() > cutoff
		t = 0
		# the height of the highest element (after the function runs)
		t_elem = undefined
		# the highest element (after the function runs)
		# $container = $(container)
		$child = $(container).find(eqHeightChildren)
		$child.each ->
			$this = $(@)
			if $this.outerHeight() > t
				t_elem = this
				t = $this.outerHeight()
				return t
		$child.css('min-height',t)

MKBL.overlay = ->
	MKBL.activationToggle($('.cogv1-page'),'overlay-is-on')
	
###*
 * This controls the social slider interaction
###
MKBL.socialSlider = ($this) ->
	$caret = $('#js-social-caret')
	$thisRelatedContent = $('.social-group__groups--text')	
	$thisMobileRelatedContent = $('.social-group__groups--small .social-group__groups')
	# Changes speed of the animation depeding on how far it has to go
	thisIndex = $this.index()
	prevIndex = $('.social-group__icon.is-active').index()	

	$('.social-group__icon')
		.removeClass('is-long-distance')
		.removeClass('is-active')

	$caret.removeClass('is-long-distance')
	$thisRelatedContent.removeClass('is-long-distance')
	if Math.abs(prevIndex - thisIndex) > 1 && $(window).outerWidth > 540
		$this.addClass('is-long-distance')
		$('.social-group__icon').eq(1).addClass('is-long-distance')
		$caret.addClass('is-long-distance')
		$thisRelatedContent.addClass('is-long-distance')

	$this.addClass('is-active')
	$thisRelatedContent.removeClass('is-active')
	$thisMobileRelatedContent.removeClass('is-active')
	$thisRelatedContent.eq(thisIndex).addClass('is-active')
	$thisMobileRelatedContent.eq(thisIndex).addClass('is-active')
	switch thisIndex
		# When the new active icon is the left icon 
		when 0
			$caret.removeClass('is-right').addClass('is-left')

		# When the new active icon is the right icon
		when 2
			$caret.removeClass('is-left').addClass('is-right')

		# When the new active icon is the middle icon
		else 
			$caret.removeClass('is-right').removeClass('is-left')

###*
 * [flowBoxSliderSetup description]
 * @return {[type]} [description]
###
MKBL.flowBoxSliderSetup = ->
	numOfSlides = $('.flow-box-slider').find('.flow-box-slider-group').length
	$slideIndicator = $('.slider-nav-indicator')
	$slideIndicator.width((1/numOfSlides)*100 + '%')

	###*
	 * [flowBoxSlideAnimation description]
	 * @param  {[type]} translation translation distance
	 * @param  {[type]} duration    animation duration
	 * @param  {[type]} delay       delay time
	###
	flowBoxSlideAnimation = (translation, duration, delay) ->
		$slideIndicator.velocity({translateX: translation}, {
				duration: duration || 900,
				easing: [ 300, 28 ],
				delay: delay || 150
			})

	###*
	 * [flowBoxSlider description]
	 * @param  {[type]} $slider      the parent slider element
	 * @param  {[type]} $slides      the child slides
	 * @param  {[type]} $activeSlide the slide that is visible
	 * @param  {[type]} direction    the direction of the slide animation
	###
	MKBL.flowBoxSlider = ($slider, $slides, $activeSlide, direction) ->
		$slideIndicator.setWidth = $slideIndicator.width()
		$slideIndicator.position = Number(MKBL.matrixToArray($slideIndicator.css('transform'))[4])

		if direction == 'next'
			$slideNewActive = ($activeSlide.index() + 1) % numOfSlides

			# If the slider is starting over from the begining 
			if $slideNewActive == 0
				flowBoxSlideAnimation($slideIndicator.position += $slideIndicator.setWidth, 300, 1)
				$slideIndicator.velocity({translateX: -$slideIndicator.setWidth}, {
					duration: 0,
					easing: "linear",
					delay: 1
				})
				flowBoxSlideAnimation(0, 550, 1)
			else
				flowBoxSlideAnimation($slideIndicator.position += $slideIndicator.setWidth)

		else
			$slideNewActive = ($activeSlide.index() - 1) % numOfSlides
			# If the slider is returning to the end slide
			if $slideNewActive == -1
				flowBoxSlideAnimation($slideIndicator.position -= $slideIndicator.setWidth, 300, 1)
				$slideIndicator.velocity({translateX: ($slideIndicator.setWidth * (numOfSlides))}, {
					duration: 0,
					easing: "linear",
					delay: 1
				})
				flowBoxSlideAnimation($slideIndicator.setWidth * (numOfSlides - 1), 550, 1)
			else
				flowBoxSlideAnimation($slideIndicator.position -= $slideIndicator.setWidth)

		$slideNextIndex = ($slideNewActive + 1) % numOfSlides
		$slidePrevIndex = ($slideNewActive - 1) % numOfSlides

		# Deque
		if (!$slider.hasClass('locked'))
			$slider.addClass('locked')

			$slides
				.removeClass('is-active')
				.removeClass('is-prev')
				.removeClass('is-next')

			$slides.eq($slideNewActive).addClass('is-active')
			$slides.eq($slidePrevIndex).addClass('is-prev')
			$slides.eq($slideNextIndex).addClass('is-next')

			setTimeout ->
				$slider.removeClass('locked')
			, 750
	return MKBL.flowBoxSlider

###*
 * Flyout interaction for the mobile profile bar
 * @param  {[type]} $this       the icon being clicked
 * @param  {[type]} $flyoutType which flyout is being called?
###
MKBL.profileCompactFlyout = ($this, $flyoutType) ->
	$module = $this.closest('.compact-profile-box-module')
	$flyout = $module.find('.compact-profile-box__flyout--'+$flyoutType)
	if $flyout.hasClass('is-active')
		$('.compact-profile-box__flyout').removeClass('is-active')
	else
		$('.compact-profile-box__flyout').removeClass('is-active')
		$flyout.addClass('is-active')

###*
 * This controls the settings and message alert flyouts associated with the desktop profile box module
 * @param  {[type]} $this           the icon clicked
 * @param  {[type]} $flyoutType     which flyout is it?
 * @param  {[type]} $activeFlyout 	which flyout is currently active
###
MKBL.profileFlyout = ($this, $flyoutType) ->
	$module = $this.closest('.profile-box-module')
	$activeFlyout = $this.closest('.profile-box-module').find('.profile-box-flyout.is-holding')
	$flyout = $this.closest('.profile-box-module').find('.profile-box-flyout--'+$flyoutType)
	
	if !$module.hasClass('is-animating')
		if $flyout.hasClass('is-holding')
			$module.addClass('is-animating')
			$flyout.removeClass('is-active').removeClass('is-holding')
			setTimeout ->
				$flyout.addClass('is-closed')
				$module.removeClass('is-animating')
			, 1001
			
		else
			$module.addClass('is-animating')
			$activeFlyout.removeClass('is-active').removeClass('is-holding')
			setTimeout ->
				$activeFlyout.addClass('is-closed')
			, 1001
			
			# if $activeFlyout.length > 0
			# 	setTimeout ->
			# 		$flyout.addClass('is-active').removeClass('is-closed')
			# 	, 800
			# 	setTimeout ->
			# 		$flyout.addClass('is-holding').removeClass('is-active')
			# 		$module.removeClass('is-animating')
			# 	, 2001
				
			# else
			$flyout.addClass('is-active').removeClass('is-closed')
			setTimeout ->
				$flyout.addClass('is-holding').removeClass('is-active')
				$module.removeClass('is-animating')
			, 1001

			
###*
 * Opens the modal
 * @param  {[type]} $this button that opened the modal
###
MKBL.modal = ($this) ->
	$modal = $($this.data('modal-id').toString())
	$tooltip = $modal.find('.modal-tip')

	if $modal.hasClass('is-hidden')
		$tooltip.css({
			'left': $this.offset().left - ($(window).width() - $modal.outerWidth())/2
			'right': 'auto'
			})
		# If there is enough space about the marker, add the tooptip above the marker, else add it below.
		$modal.css({
			'top': $this.offset().top - $modal.outerHeight() - 95
			}).removeClass('is-reverse').removeClass('is-hidden')
		$tooltip.css({
			'bottom': '-1.3rem'
			'top': 'auto'
			})
		$('html, body').animate { scrollTop: $modal.position().top }, 'slow'
	else
		$modal.addClass('is-hidden')
		
###*
 * Opens the dropdown for the content editable module
 * @param  {[type]} $dropdown the dropdown being called
###
MKBL.contenteditableDropdown = ($dropdown, $trigger) ->
	$li = $dropdown.find('li')
	dropdownHeight = $li.length * $li.outerHeight()
	
	if dropdownHeight > 342
		dropdownHeight = 372
		setTimeout ->
			$dropdown.perfectScrollbar({
				suppressScrollX: true
			})
		, 900

	if $dropdown.height() == 0 or $dropdown.height() == null
	# if !$dropdown.hasClass('is-active')
		MKBL.activationOn($trigger)
		$dropdown.velocity { height: dropdownHeight }, 
			duration: 600,
			easing: [ 300, 30 ],
			delay: 0
			complete: () ->
				$(@).addClass('is-active')
	else
		MKBL.activationOff($trigger)
		$dropdown.velocity {height: 0},
			duration: 600,
			easing: [ 300, 30 ],
			delay: 0
			complete: () ->
				$(@).removeClass('is-active')

MKBL.contenteditableMobileScroll = ($this) ->
	$('html, body').animate { scrollTop: $this.position().top }, 'slow'

MKBL.contenteditableDropdownAutocomplete = ($this) ->
	$trigger = $this.closest('.js-dropdown-option-parent').find('.js-dropdown-trigger')
	if $this.closest('.js-dropdown-option-parent').find('.contenteditable-dropdown').length
		$dropdown = $this.closest('.js-dropdown-option-parent').find('.contenteditable-dropdown')

		if $dropdown.height() == 0 or $dropdown.height() == null
			MKBL.contenteditableDropdown($dropdown, $trigger)

		searchInputText = $this.html().replace(/^\s+|\s+$/g, '')
		if searchInputText != '' and searchInputText != ' '
		  pattern = new RegExp(searchInputText, 'gi')

		matchingLetters = null
		$dropdown.find('.js-dropdown-option').each ->
			matchingLetters = $(@).text()
			matchingLetters = matchingLetters.replace(pattern, ($1) ->
			  '<span>' + $1 + '</span>'
			)
			
			$(@).html matchingLetters

MKBL.searchAutocomplete = ($input, $autoSuggestListItem) ->
	searchInputText = $input.val().replace(/^\s+|\s+$/g, '')
	if searchInputText != '' and searchInputText != ' '
	  pattern = new RegExp(searchInputText, 'gi')

	matchingLetters = null
	$autoSuggestListItem.each ->
		matchingLetters = $(@).text()
		matchingLetters = matchingLetters.replace(pattern, ($1) ->
		  '<span>' + $1 + '</span>'
		)
		
		$(@).html matchingLetters

###*
 * Fills the content editable section with the selected dropdown option
 * @param  {[type]} $this the button clicked
###
MKBL.contenteditableDropdownSelect = ($this) ->
	if $(window).width()*0.7 > 840
		maxWidth = 840
	else
		maxWidth = $(window).width()*0.7
	$this.siblings().removeClass('is-active')
	$this.addClass('is-active')
	$contenteditableParent = $this.closest('.js-dropdown-option-parent')
	$contenteditable = $this.closest('.js-dropdown-option-parent').find('[contenteditable]')

	MKBL.activationOff($('js-dropdown-trigger'))

	$contenteditableParent
		.find('.js-dropdown-option-holder')
		.text($this.text())

	if $this.text() != $contenteditableParent.find('.js-dropdown-option-holder').data('default')
		$contenteditableParent.addClass('is-filled')
	else
		$contenteditableParent.removeClass('is-filled')

	if $contenteditable.prop('scrollWidth') < maxWidth
		$contenteditable.css('min-width', '100px')
		setTimeout ->
			$contenteditable.css('min-width', $contenteditable.width())
		, 900

###*
 * animation for the content editable div on click
 * @param  {[type]} $this the content editable div
###
MKBL.prepareContenteditable = ($this) ->
	$this.closest('.is-editable').addClass('is-active')
	if !$this.closest('.is-editable').hasClass('is-filled')
		$this.text('')

###*
 * animation for leaving focus of the content editable div
###
MKBL.endContenteditable = ->
	if $(window).width()*0.7 > 840
			maxWidth = 840
	else
		maxWidth = $(window).width()*0.7

	MKBL.activationOff($('[contenteditable]'))
	$('[contenteditable]').each ->
		$this = $(@)
		if $this.text() == ''
			$this
				.text($this.data('placeholder'))
				.closest('.is-editable')
				.removeClass('is-filled')
				.removeClass('is-active')
			$this
				.css('min-width', '100px')
			setTimeout ->
				$this.css('min-width', $this.width())
			, 900
		else 
			if $this.text() != $this.data('placeholder')
				$this
					.closest('.is-editable')
					.addClass('is-filled')
			if $this.prop('scrollWidth') < maxWidth and $this.css('min-width') != $this.width()
				$this
					.css('min-width', '100px')
				setTimeout ->
					$this.css('min-width', $this.width())
				, 900

###*
 * Sets up the content editable div on load
###
MKBL.setupContenteditable = ->
	$('[contenteditable]').each ->
		$this = $(@).closest('.is-editable').find('.contenteditable__wrapper')
		if $(window).width()*0.7 > 840
			maxWidth = 840
		else
			maxWidth = $(window).width()*0.7
		$this
			# .css('height', $this.outerHeight())
			.css('max-width', maxWidth)
			.perfectScrollbar()
		if $this.outerWidth() < maxWidth
			$this.css('min-width',$this.outerWidth())
		else
			$this.css('min-width', maxWidth)

		$this.perfectScrollbar()


MKBL.playVideo = (e, $this) ->
	$parent = $this.closest('.video-section')
	$video = $parent.find('iframe')

	$parent.addClass('is-active')
	setTimeout ->
		$video[0].src += '&autoplay=1'
	, 300

	e.preventDefault()

MKBL.activationToggle = ($parent, cssClass) ->
	cssClass = cssClass || 'is-active'
	$parent.toggleClass(cssClass)

MKBL.activationOn = ($parent, cssClass) ->
	cssClass = cssClass || 'is-active'
	if !$parent.hasClass(cssClass)
		$parent.addClass(cssClass)

MKBL.activationOff = ($parent) ->
	cssClass = cssClass || 'is-active'
	$parent.removeClass(cssClass)

MKBL.articleNavWaypoints = ->
	MKBL.articleNavWaypoint = $('.cogv1_article-nav').waypoint
		# element: $('.cogv1_article-nav')
		offset: $(window).height() / 2
		handler: (direction) ->
			if direction == 'down'
				$(@.element)
					.addClass('is-scrolling')
					.removeClass('is-bottom')
			else
				$(@.element)
					.removeClass('is-scrolling')
					.removeClass('is-bottom')

	MKBL.articleNavAlmostBottomWaypoint = $('.cogv1_article__footer-nav').waypoint
		# element: $('.cogv1_article__footer-nav')
		offset: ($(window).height() / 2) - ($('.cogv1_article-nav').height() * 2)
		handler: (direction) ->
			if direction == 'down'
				$('.cogv1_article-nav')
					.addClass('is-almost-bottom')
			else
				$('.cogv1_article-nav')
					.removeClass('is-almost-bottom')	

	MKBL.articleNavBottomWaypoint = $('.cogv1_article__footer-nav').waypoint
		# element: $('.cogv1_article__footer-nav')
		offset: ($(window).height() / 2) - $('.cogv1_article-nav').height()
		handler: (direction) ->
			if direction == 'down'
				$('.cogv1_article__footer-nav__button').addClass('is-active')
				$('.cogv1_article-nav')
					.addClass('is-bottom')
					.removeClass('is-scrolling')
			else
				$('.cogv1_article__footer-nav__button').removeClass('is-active')
				$('.cogv1_article-nav')
					.addClass('is-scrolling')
					.removeClass('is-bottom')
	return