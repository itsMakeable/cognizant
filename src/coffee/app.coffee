MKBL = {}

###*
 * Creates equal hieght divs
 * @param  {[type]} container [description]
 * @return {[type]}           [description]
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


MKBL.shareFlyout = ($this) ->
	$this
		.toggleClass('is-active')
		.siblings('.search__share-flyout').eq(0)
		.toggleClass('is-active')


$('.share-flyout__trigger').on 'click',  ->
	$this = $(this)
	MKBL.shareFlyout($this)

$('.social-group__icon').on 'click',  ->
	$this = $(this)
	MKBL.socialSlider($this)

$ ->
	MKBL.equalheight('.banner-module','.banner-module > div', 940)

$(window).on 'resize', ->
	MKBL.equalheight('.banner-module','.banner-module > div', 940)
