###*
	@module Keypad
	@author muchweb
###

'use strict'

{Keypad} = require './Keypad.js'

exports.KeypadHelper = class extends Keypad

	###*
		Delay for key holding
		@property holding_delay
		@type Number
		@default 1000
	###
	holding_delay: 1000

	###*
		Key that is being currently holded
		@property holding_key
		@type String
		@default null
	###
	holding_key: null

	###*
		Holding timeout reference
		@property holding_timepout
		@type Object
		@default null
	###
	holding_timeout: null

	###*
		12-key keyboard layout emulation, similar to one that is used in mobile phones
		@class Keypad
		@extends EventEmitter
		@param {[Object]} options Overwrite default `Keypad` options
	###
	constructor: (options = {}) ->
		super

		@on 'down', (key) => @ProcessKeyDown key
		@on 'up', (key) => @ProcessKeyUp key

	###*
		@method ProcessKeyDown
		@param {String} key Key character
	###
	ProcessKeyDown: (key) ->
		@ProcessKeyUp @holding_key, true if @holding_timeout?
		@holding_key = key

		@holding_timeout = setTimeout =>
			@emit 'hold', @holding_key
			clearTimeout @holding_timeout
			@holding_timeout = null
			@holding_key = null
		, @holding_delay

	###*
		@method ProcessKeyUp
	###
	ProcessKeyUp: (key, immediate=false) ->
		return if key isnt @holding_key
		@emit 'press', @holding_key
		clearTimeout @holding_timeout
		@holding_timeout = null
		@holding_key = null
