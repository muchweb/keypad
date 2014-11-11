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
		Uppercase of lowercase
		@property case
		@type String
		@default 'Abc'
	###
	case: 'Abc'

	###*
		Characters that interrupt a sentence
		@property interrupt_case
		@type String
		@default '.\n'
	###
	interrupt_case: '.\n'

	###*
		12-key keyboard layout emulation, similar to one that is used in mobile phones
		@class Keypad
		@extends EventEmitter
		@param {[Object]} options Overwrite default `Keypad` options
	###
	constructor: (options = {}) ->
		@[key] = val for key, val of options
		@mapping = MapNokia
		@on 'push', (key) => @ProcessKey key

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
			return @character = @mapping[key][current_index + 1] if @mapping[key][current_index + 1]?
			return @character = @mapping[key][0]

		# New or -other key pressed
		@InsertCharacter @character
		@character = @mapping[key][0]
		@ResetTimeout()

	###*
		Returns character that will be inserted, with current case
		@method GetInsertCharacter
		@param {String} text Selected (typed) string
	###
	GetInsertCharacter: (text) ->
		text = @character unless text?
		return null unless text?
		text = text.toUpperCase() if @case[0] is 'A'
		text

	###*
		Apply selected (typed) text
		@method InsertCharacter
		@param {String} text Selected (typed) string
	###
	InsertCharacter: (text) ->
		text = @character unless text?
		return unless text
		inserted = @GetInsertCharacter()
		@text += inserted
		@character = null
		@case = 'abc' if @case isnt 'ABC'
		@case = 'Abc' if @case isnt 'ABC' and (@interrupt_case.indexOf inserted) >= 0

	###*
		Resetting typing tymeout
		@method ResetTimeout
	###
	ResetTimeout: ->
		@timeout = setTimeout =>
			@InsertCharacter()
			@timeout = null
		, @delay
