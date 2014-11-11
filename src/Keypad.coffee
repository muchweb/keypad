###*
	@module Keypad
	@author muchweb
###

'use strict'

exports.Keypad = class

	###*
		Is currently in edit mode
		@property typing
		@type Boolean
		@default false
	###
	typing: false

	###*
		@class Keypad
		@param {[Object]} options Overwrite default `Keypad` options
	###
	constructor: (options = {}) ->
		@[key] = val for key, val of options
