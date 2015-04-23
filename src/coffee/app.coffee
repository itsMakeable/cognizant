MKBL = {}

MKBL.socialSlider = ->
	$('.social-group__icon').on 'click', ->
		$this = $(this)
		curr = $this.index()
		prev = $('.social-group__icon.is-active').index()
		
		$('.social-group__icon').removeClass('is-long-distance')
		$('.social-group__hr-carrot').removeClass('is-long-distance')
		if Math.abs(prev - curr) == 2
			$this.addClass('is-long-distance')
			$('.social-group__hr-carrot').addClass('is-long-distance')
			
		$('.social-group__icon').removeClass('is-active')
		$this.addClass('is-active')
		if $this.index() == 0
			$('.social-group__hr-carrot').removeClass('is-right')
			$('.social-group__hr-carrot').addClass('is-left')
		else if $this.index() == 2
			$('.social-group__hr-carrot').removeClass('is-left')
			$('.social-group__hr-carrot').addClass('is-right')
		else
			$('.social-group__hr-carrot')
				.removeClass('is-right')
				.removeClass('is-left')

$ ->
	MKBL.socialSlider()