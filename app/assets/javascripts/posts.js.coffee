# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('tr td a').on 'click', (event) ->
		a = $('#login').length
		if a == 1
			alert("로그인을 해주세요.")
			event.preventDefault()

	$('#comment_add_button').on 'click', (event) ->
		$('.comments_add').slideToggle()

	$('#add_photos').on 'click', (event) ->
		imageNum = $('fieldset').length
		if imageNum >= 5
			alert("사진은 5개까지 추가가 가능합니다.")
			return false