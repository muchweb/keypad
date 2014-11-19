###*
	@module Keypad
	@author muchweb
###

'use strict'

{EventEmitter} = require 'events'

exports.Keypad = class extends EventEmitter

	###*
		Name of selected map
		@property map_name
		@type String
		@default 'nokia'
	###
	map_name: 'nokia'

	###*
		Input language
		@property map_language
		@type String
		@default 'en'
	###
	map_language: 'en'

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
		@default 500
	###
	delay: 500

	###*
		List of available cases
		@static
		@property caselist
		@type Object
	###
	@caselist: [
		'Abc'
		'abc'
		'ABC'
		'123'
	]

	###*
		Uppercase of lowercase
		@property case
		@type String
		@default 'Abc'
	###
	# Value is dynamically set in constructor
	case: null

	###*
		Characters that interrupt a sentence
		@property interrupt_case
		@type String
		@default '.\n'
	###
	interrupt_case: '.\n'

	###*
		Loading all pre-built keymaps
		@property maps
		@type Object
		@default null
	###
	maps: null

	###*
		12-key keyboard layout emulation, similar to one that is used in mobile phones
		@class Keypad
		@extends EventEmitter
		@param {[Object]} options Overwrite default `Keypad` options
	###
	constructor: (options = {}) ->
		@[key] = val for key, val of options

		# Loading default (built-in) set of key maps
		unless @maps?
			@maps =
				nokia: require './MapNokia.js'
				sonyericsson: require './MapSonyericsson.js'

		@SetMapping @map_name, @map_language unless @mapping?

		@case = exports.Keypad.caselist[0]
		@on 'press', @ProcessKeyPress
		@on 'hold', @ProcessKeyHold

	###*
		Set keypad mapping
		@method SetMapping
		@param {String} name Target mapping name
	###
	SetMapping: (name, language=@map_language) ->
		throw new Error 'Please specify target map name' unless name?
		throw new Error 'Specified map name does not exist' unless @maps[name]?
		throw new Error 'Specified language does not exist in a mapping' unless @maps[name][language]?
		@map_name = name
		@map_language = language
		@mapping = @maps[@map_name][@map_language]

	###*
		Process a keyhold
		@method ProcessKeyHold
		@param {String} key Key character
	###
	ProcessKeyHold: (key) ->
		throw new Error 'Please specify pressed key code' unless key?
		return @Backspace() if key is 'c'
		throw new Error "This key code was not found in mapping: '#{key}'" unless @mapping[key]?
		@InsertCharacter key

	###*
		Process a keypress
		@method ProcessKeyPress
		@param {String} key Key character
	###
	ProcessKeyPress: (key, immediate=false) ->
		throw new Error 'Please specify pressed key code' unless key?
		return @Backspace() if key is 'c'
		throw new Error "This key code was not found in mapping: '#{key}'" unless @mapping[key]?

		# Looking if key is a sequence
		current_index = @mapping[key].indexOf @character

		# In the process of typing, same key pressed. Cycling choices
		if current_index >= 0
			@ResetTimeout()
			return @character = @mapping[key][current_index + 1] if @mapping[key][current_index + 1]?
			return @character = @mapping[key][0]

		# There was no key or different (new) key pressed
		# Inserting previous character is there was any
		@InsertCharacter @character

		# Saving current new key
		@character = @mapping[key][0]

		# Switching case immediately, interrupting normal key sequences
		return @LoopCase() if @character is 'CASE'

		if immediate
			# Inserting right now, if that was requested
			@InsertCharacter @character
			return @ClearTimeout()

		# Setting new key timeout
		@ResetTimeout()

	###*
		Remove last character
		@method Backspace
	###
	Backspace: ->
		@ClearKeys()
		return null if @text.length is 0
		@text = @text.slice 0, -1

	###*
		Looping through available cases
		@method LoopCase
	###
	LoopCase: ->
		@ClearKeys()
		current_index = exports.Keypad.caselist.indexOf @case
		return @case = exports.Keypad.caselist[current_index + 1] if exports.Keypad.caselist[current_index + 1]?
		@case = exports.Keypad.caselist[0]

	###*
		Returns character that will be inserted, with current case
		@method GetInsertCharacter
		@param {String} text Selected (typed) string
	###
	GetInsertCharacter: (text=@character) ->
		return null unless text?
		return text.toUpperCase() if @case[0] is 'A'
		text

	###*
		Apply selected (typed) text
		@method InsertCharacter
		@param {String} text Selected (typed) string
	###
	InsertCharacter: (text=@character) ->
		return unless text?
		inserted = @GetInsertCharacter text
		@text += inserted
		@ClearKeys()
		@case = 'abc' if @case isnt 'ABC'
		@case = 'Abc' if @case isnt 'ABC' and (@interrupt_case.indexOf inserted) >= 0

	###*
		Resetting current typing state
		@method ClearKeys
	###
	ClearKeys: ->
		@character = null
		@ClearTimeout()

	###*
		Resetting typing tymeout
		@method ResetTimeout
	###
	ResetTimeout: ->
		@ClearTimeout()
		@timeout = setTimeout =>
			@InsertCharacter()
			@timeout = null
		, @delay

	###*
		Clear current keys timeout
		@method ClearTimeout
	###
	ClearTimeout: ->
		if @timeout?
			clearTimeout @timeout
			@timeout = null
