MKBL = {}

###*
 * This controls the social slider interaction
###
MKBL.socialSlider = ($this) ->
	
	$caret = $('#js-social-caret')
	$thisRelatedContent = $('.social-group__groups--text')

	thisIndex = $this.index()
	prevIndex = $('.social-group__icon.is-active').index()		

	$('.social-group__icon')
		.removeClass('is-long-distance')
		.removeClass('is-active')

	# Changes speed of the animation depeding on how far it has to go
	$caret.removeClass('is-long-distance')
	$thisRelatedContent.removeClass('is-long-distance')
	if Math.abs(prevIndex - thisIndex) > 1
		$this.addClass('is-long-distance')
		$('.social-group__icon').eq(1).addClass('is-long-distance')
		$caret.addClass('is-long-distance')
		$thisRelatedContent.addClass('is-long-distance')

	$this.addClass('is-active')
	$thisRelatedContent.removeClass('is-active')
	$thisRelatedContent.eq(thisIndex).addClass('is-active')
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

$('.social-group__icon').on 'click',  ->
	$this = $(this)
	MKBL.socialSlider($this)