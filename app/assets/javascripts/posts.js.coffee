# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('#test_error').on 'click', (event) ->
			a = $('#login').length
			if a == 1
				alert('Please Login')