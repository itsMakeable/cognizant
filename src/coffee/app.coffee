MKBL = {}

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

###*
 * Converts matrix like rgba or transforms to an array
###
MKBL.matrixToArray = (str) ->
  str.match /(-?[0-9\.]+)/g

###*
 * [equalheight description]
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
		$container = $(container)
		$child = $(eqHeightChildren)
		$($child, $container).each ->
			$this = $(this)
			if $this.outerHeight() > t
				t_elem = this
				t = $this.outerHeight()
				$child.outerHeight(t)

###*
 * This controls the social slider interaction
###
MKBL.socialSlider = ($this) ->
	$caret = $('#js-social-caret')
	$thisRelatedContent = $('.social-group__groups--text')	
	$thisMobileRelatedContent = $('.social-group__groups--mobile .social-group__groups')
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

###*
 * the share flyout that slides open to show didn't sharing options
 * @param  {[type]} $this the parent element
###
MKBL.shareFlyout = ($this) ->
	$this
		.toggleClass('is-active')
		.siblings('.js-share-flyout').eq(0)
		.toggleClass('is-active')

MKBL.profileFlyout = ($this, $flyoutType) ->
	$module = $this.closest('.profile-box-module')
	$activeFlyout = $this.closest('.profile-box-module').find('.profile-box-flyout.is-holding')
	$flyout = $this.closest('.profile-box-module').find('.profile-box-flyout--'+$flyoutType)
	
	if !$module.hasClass('is-animating')
		if $flyout.hasClass('is-holding')
			$module.addClass('is-animating').alterClass('*-is-open')
			$flyout.removeClass('is-active').removeClass('is-holding')
			setTimeout ->
				$flyout.addClass('is-closed')
				$module.removeClass('is-animating')
			, 1001
			
		else
			$module.addClass('is-animating').alterClass('*-is-open').addClass($flyoutType+'-is-open')
			$activeFlyout.removeClass('is-active').removeClass('is-holding')
			setTimeout ->
				$activeFlyout.addClass('is-closed')
			, 1001
			
			if $activeFlyout.length > 0
				setTimeout ->
					$flyout.addClass('is-active').removeClass('is-closed')
				, 800
				setTimeout ->
					$flyout.addClass('is-holding').removeClass('is-active')
					$module.removeClass('is-animating')
				, 2001
				
			else
				$flyout.addClass('is-active').removeClass('is-closed')
				setTimeout ->
					$flyout.addClass('is-holding').removeClass('is-active')
					$module.removeClass('is-animating')
				, 1001

			

MKBL.modal = ($this) ->
	$modal = $($this.data('modal-id').toString())
	$tooltip = $modal.find('.modal-tip')
	$tooltip.css({
		'left': $this.offset().left - ($(window).width() - $modal.outerWidth())/2
		'right': 'auto'
		})
	# If there is enough space about the marker, add the tooptip above the marker, else add it below.
	if (($this.position().top - $(window).scrollTop()) > $modal.height())
		$modal.css({
			'top': $this.offset().top - $modal.outerHeight() - 95
			}).removeClass('is-reverse').removeClass('is-hidden')
		$tooltip.css({
			'bottom': '-1.3rem'
			'top': 'auto'
			})
	else
		$modal.css({
			'top': $this.offset().top + $this.outerHeight() + 95
			}).addClass('is-reverse').removeClass('is-hidden')
		$tooltip.css({
			'top': '-1.3rem'
			'bottom': 'auto'
			})
## EVENTS ###############################

$('.js-open-modal-module').on 'click',  ->
	$this = $(this)
	MKBL.modal($this)

$('.share-flyout__trigger').on 'click',  ->
	$this = $(this)
	MKBL.shareFlyout($this)

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

$ ->
	MKBL.equalheight('.banner-module','.banner-module > div', 940)
	MKBL.flowBoxSliderSetup()

$(window).on 'resize', ->
	MKBL.equalheight('.banner-module','.banner-module > div', 940)
	MKBL.flowBoxSliderSetup()
	$('.modal-module').addClass('is-hidden')