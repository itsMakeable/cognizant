MKBL.listFilter = (input, list) ->
	$(input).on 'keyup', (e) ->
		keyCode = e.keyCode or e.which
		if $.inArray(keyCode, [9,13,38,40]) < 0
			filter = $(this).val()
			if filter && filter != ''
				$('.mkbl-form-hint.is-select').removeClass('is-displayed')
				$(list).find('li').removeClass('is-active')
				$(list).find('li:not(:contains(' + filter + '))').removeClass('not-filtered')
				$(list).find('li:contains(' + filter + ')').addClass('not-filtered')
				$(list).find('li.not-filtered').eq(0).addClass('is-active')
				
			else
				$(list).find('li').addClass('not-filtered').removeClass('is-active')
				# if $('.mkbl-main-input').val() != ''
				$('.mkbl-form-hint.is-select').addClass('is-displayed')
				$('.mkbl-form-hint.is-input').removeClass('is-displayed')

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


MKBL.currentField = null
MKBL.timeout = null
MKBL.waitToShow = 0;
MKBL.saveField = (currentField) ->
	hasError = false
	currentFieldVal = $('#enter-' + currentField).find('.mkbl-main-input').val()
	if !$('#enter-' + currentField).find('.mkbl-select-bg').length
		if currentFieldVal == ''
			hasError = true
			$('#enter-' + currentField).find('input').addClass('has-error').trigger('touchstart')
			$('.mkbl-form-progress-bar').addClass('has-error')
			$('#'+ currentField).removeClass('is-valid')
	else if $('#enter-' + currentField).find('.mkbl-select-bg').length
		options = []
		$('#enter-' + currentField).find('.mkbl-select-option').each ->
			optionText = $(this).text()
			options.push optionText
		if MKBL.checkArray.call(options, $('#enter-' + currentField).find('.mkbl-main-input').val()) == -1
			hasError = true
			$('#enter-' + currentField).find('input').addClass('has-error').trigger('touchstart')
			$('.mkbl-form-progress-bar').addClass('has-error')
			$('#'+ currentField).removeClass('is-valid')
	
	if (!hasError)
		$('#' + currentField + ' .mkbl-subinput').text(currentFieldVal)
		$('#'+ currentField)
			.removeClass('is-active')
			.removeClass('is-typing')
			.addClass('is-filled')
			.addClass('is-valid')
		$('.mkbl-form-progress-bar')
			.removeClass('has-error')

		$('#enter-' + currentField).find('.mkbl-select-bg').removeClass('is-open')
		$('#'+ currentField).find('.mkbl-select-bg').removeClass('is-open')
		if $('#enter-' + currentField).find('.mkbl-select-bg').length
			setTimeout (->
				$('#enter-' + currentField).addClass('is-hidden')
			), 400
			MKBL.waitToShow = 400
		else
			$('#enter-' + currentField).addClass('is-hidden')
			MKBL.waitToShow = 0
		MKBL.setProgress()

	return !hasError


MKBL.prepareField = (nextField) ->
	$('.mkbl-form-complete').removeClass('is-active')
	$('.mkbl-form-hint.is-select').removeClass('is-displayed')
	$('.mkbl-form-hint.is-input').removeClass('is-displayed')

	if $('#enter-' + nextField).find('.mkbl-select-bg').length
		if MKBL.currentField != nextField
			setTimeout (->
				$('#enter-' + nextField).removeClass('is-hidden')
				setTimeout (->
					if $('#enter-' + nextField).index() > 0
						$('#enter-' + nextField).find('.mkbl-main-input').trigger('touchstart')
					$('.mkbl-form-hint.is-select').addClass('is-displayed')
					MKBL.listFilter('.mkbl-sselect','.mkbl-select-bg.is-open')
					$('#enter-'+ nextField).find('.mkbl-select-bg').addClass('is-open')
				), 1
			), MKBL.waitToShow
	else
		setTimeout (->
			$('#enter-' + nextField).removeClass('is-hidden')
			setTimeout (->
				if $('#enter-' + nextField).index() > 0
					$('#enter-' + nextField)
						.find('.mkbl-main-input')
						.trigger('touchstart')
			), 1
					
		), MKBL.waitToShow
	
	$('#' + nextField)
		.addClass('is-active')
		.removeClass('is-clean')
	
	if $('#enter-' + nextField).find('.mkbl-select-bg').length
		MKBL.waitToShow = 400;
	else
		MKBL.waitToShow = 0;
	MKBL.currentField = nextField
	return MKBL.currentField


MKBL.moveToField = (nextField) ->
	if MKBL.currentField == nextField
		return 
	currentF = MKBL.currentField
	success = true
	if currentF != null && $('#' + currentF).hasClass('is-dirty')
		success = MKBL.saveField(currentF)
	else
		if $('#enter-' + currentF).find('.mkbl-select-bg').length
			$('#enter-' + currentF).find('.mkbl-select-bg').removeClass('is-open')
			$('#'+ currentF).find('.mkbl-select-bg').removeClass('is-open')
			setTimeout (->
				$('#enter-' + currentF).addClass('is-hidden')
			), 400
			MKBL.waitToShow = 400
		else
			$('#enter-' + currentF).addClass('is-hidden')
			MKBL.waitToShow = 0
		$('#'+ currentF)
			.removeClass('is-active')
			.removeClass('is-typing')
			.addClass('is-filled')
	if (success)
		MKBL.prepareField(nextField)


MKBL.requestNextField = ->
	if MKBL.currentField != null
		success = MKBL.saveField(MKBL.currentField)
		if (success)
			if $('.mkbl-form-subfields .mkbl-fieldset.is-valid').length == MKBL.progressDenominator
				MKBL.showSubmit()
			else
				nextField = $('.mkbl-form-subfields .mkbl-fieldset.is-valid').last().next().attr('id')
				MKBL.prepareField(nextField)
	else
		MKBL.prepareField 'field-name'


MKBL.showSubmit = ->
	$('.mkbl-select-bg').removeClass('is-open')
	$('.mkbl-form-hint.is-select').removeClass('is-displayed')
	$('.mkbl-form-hint.is-input').removeClass('is-displayed')
	$('.mkbl-form-button').addClass('is-active').trigger('touchstart')
	setTimeout (->
		$('.mkbl-form-main-field fieldset').addClass('is-hidden')
		$('.mkbl-form-complete').addClass('is-active')
	), 400


### This sets the progress bar after entering a value in the form ###
MKBL.setProgress = ->
	setTimeout (->
		progressFilled = $('.mkbl-form-subfields .mkbl-fieldset.is-filled').length
		progressActive = $('.mkbl-form-subfields .mkbl-fieldset.is-filled.is-active').length
		progressDividend = progressFilled - progressActive
		$('.mkbl-form-progress-bar-progress').css('width', ((progressDividend/MKBL.progressDenominator) * 100) + '%')
	), 1
	

MKBL.formInit = ->
	MKBL.prepareField('field-name')
	MKBL.progressDenominator = $('.mkbl-form-subfields .mkbl-fieldset').length
	$('.mkbl-form-subfields .mkbl-fieldset').on 'click', ->
		MKBL.moveToField( $(this).attr('id') )

	$('.mkbl-main-input').on 'keydown', ->
		thisField = $(this).closest('fieldset').attr('id').substring(6)
		$('#' + thisField).addClass('is-dirty')
		$('.mkbl-form-main-field .mkbl-fieldset').find('input').removeClass('has-error')
		$('.mkbl-form-hint.is-input').addClass('is-displayed')
		$('.mkbl-form-progress-bar').removeClass('has-error')
		### This animates the input dots ###
		deanimateEllipse = ->
			$('#' + thisField).removeClass('is-typing')
		animateEllipse = ->
			$('#' + thisField).addClass('is-typing')

		animateEllipse()
		if MKBL.timeout
			clearTimeout MKBL.timeout
			MKBL.timeout = null
		MKBL.timeout = setTimeout(deanimateEllipse, 1500)
		return MKBL.timeout

	### removes hints to selects ###
	$('.mkbl-main-input').on 'blur', ->
		$('.mkbl-form-hint.is-input').removeClass('is-displayed')

	### the form button trigger ###
	$('.js-form-next').on 'click', (e) ->
		MKBL.requestNextField();
		thisField = $(this).closest('fieldset').attr('id').substring(6)
		return thisField
	$(window).on 'keydown', (e) ->
		if $('#enter-' + MKBL.currentField).length
			thisField = $('#enter-' + MKBL.currentField).attr('id').substring(6)
			# $('.mkbl-form-button').prop('disabled',true)
			
			keyCode = e.keyCode or e.which
			if keyCode == 9
				e.preventDefault()
			### Tab and Submit ###
			if keyCode == 9 || keyCode == 13
				if !$('.mkbl-form-button').is(':focus')
					e.preventDefault()
					if $('.mkbl-form').find('.mkbl-select-bg.is-open .is-active').length
						$('#enter-' + MKBL.currentField + ' .mkbl-main-input').val($('.mkbl-select-bg.is-open .is-active').text())
					setTimeout (->
						MKBL.requestNextField();
					), 1
			### Up Arrow ###
			if keyCode == 40
				e.preventDefault()
				$('.mkbl-form-hint.is-select').removeClass('is-displayed')
				$('.mkbl-form-hint.is-input').addClass('is-displayed')
				
				if $('.mkbl-form').find('.mkbl-select-bg.is-open .is-active').length
					selectActive = $('.mkbl-form').find('.mkbl-select-bg.is-open .is-active')
					selectActive.removeClass('is-active')
					selectActive.next().addClass('is-active')
					$('#enter-' + MKBL.currentField).find('input').removeClass('has-error')
					$('.mkbl-form-progress-bar').removeClass('has-error')
				else
					selectActive = $('.mkbl-form').find('.mkbl-select-bg.is-open .mkbl-select-option:first-of-type')
					$('.mkbl-select-bg.is-open .mkbl-select-option:first-of-type').addClass('is-active')
				$('#enter-' + MKBL.currentField + ' .mkbl-main-input').val(selectActive.next().text())
			### Down Arrow ###
			if keyCode == 38
				e.preventDefault()
				$('.mkbl-form-hint.is-select').removeClass('is-displayed')
				$('.mkbl-form-hint.is-input').addClass('is-displayed')

				if $('.mkbl-form').find('.mkbl-select-bg.is-open .is-active').length
					selectActive = $('.mkbl-form').find('.mkbl-select-bg.is-open .is-active')
					selectActive.removeClass('is-active')
					selectActive.prev().addClass('is-active')
					$('#enter-' + MKBL.currentField).find('input').removeClass('has-error')
					$('.mkbl-form-progress-bar').removeClass('has-error')
				else
					selectActive = $('.mkbl-form').find('.mkbl-select-bg.is-open .mkbl-select-option:last-of-type')
					$('.mkbl-select-bg.is-open .mkbl-select-option:last-of-type').addClass('is-active')
				$('#enter-' + MKBL.currentField + ' .mkbl-main-input').val(selectActive.prev().text())


	$('.mkbl-select-option').on 'click', ->
		selectOption = $(this).text()
		$('#enter-' + MKBL.currentField + ' .mkbl-sselect').val(selectOption)
		MKBL.requestNextField()

	
	$('.mkbl-select-option').on 'mouseover', ->
		$('.mkbl-select-option').addClass('not-filtered').removeClass('is-active')
		$(this).addClass('is-active')
		$('#enter-' + MKBL.currentField + ' .mkbl-main-input').val($(this).text())
		$('#enter-' + MKBL.currentField).find('input').removeClass('has-error')
		$('.mkbl-form-progress-bar').removeClass('has-error')


$ ->	
	MKBL.formInit()