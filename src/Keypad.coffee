###*
	@module Keypad
	@author muchweb
###

'use strict'

{EventEmitter} = require 'events'
{MapNokia}     = require './MapNokia.js'

exports.Keypad = class extends EventEmitter

	###*
		Full typed in text
		@property text
		@type String
		@default ''
	###
	text: ''

	###*
		Character that is currently being typed
		@property character
		@type String
		@default null
	###
	character: null

	###*
		Currently used mapping
		@property mapping
		@type Object
		@default null
	###
	mapping: null

	###*
		Timeout that is used to interrupt typing
		@property timeout
		@type Object
		@default null
	###
	timeout: null

	###*
		Delay for typing timeout
		@property delay
		@type Number
		@default 100
	###
	delay: 100

	###*
		12-key keyboard layout emulation, similar to one that is used in mobile phones
		@class Keypad
		@extends EventEmitter
		@param {[Object]} options Overwrite default `Keypad` options
	###
	constructor: (options = {}) ->
		@[key] = val for key, val of options
		@mapping = MapNokia
		@on '1', => @ProcessKey '1'
		@on '2', => @ProcessKey '2'
		@on '3', => @ProcessKey '3'
		@on '4', => @ProcessKey '4'
		@on '5', => @ProcessKey '5'
		@on '6', => @ProcessKey '6'
		@on '7', => @ProcessKey '7'
		@on '8', => @ProcessKey '8'
		@on '9', => @ProcessKey '9'
		@on '*', => @ProcessKey '*'
		@on '0', => @ProcessKey '0'
		@on '#', => @ProcessKey '#'

	###*
		Process a keypress
		@method ProcessKey
		@param {String} key Key character
	###
	ProcessKey: (key) ->
		throw new Error 'Please specify pressed key code' unless key?
		throw new Error "This key code was not found in mapping: '#{key}'" unless @mapping[key]?

		current_index = @mapping[key].indexOf @character

		# In the process of typing, same key pressed
		if current_index >= 0
			@ResetTimeout()
			return @character = @mapping[key][current_index + 1] if @mapping[key][current_index + 1]
			@character = @mapping[key][0]

		# New or -other key pressed
		@InsertCharacter @character
		@character = @mapping[key][0]
		@ResetTimeout()

	###*
		Apply selected (typed) text
		@method InsertCharacter
		@param {String} text Selecter (typed) string
	###
	InsertCharacter: (text) ->
		text = @character unless text?
		throw new Error 'Please specify target text' unless text
		@text += text
		@character = null

	###*
		Resetting typing tymeout
		@method ResetTimeout
	###
	ResetTimeout: ->
		@timeout = setTimeout =>
			@InsertCharacter()
			@timeout = null
		, @delay
