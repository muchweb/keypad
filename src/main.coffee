###*
	@module Keypad
	@author muchweb
###

'use strict'

module.exports =
	Keypad: if process.env.KEYPAD_COVERAGE then (require '../lib-cov/Keypad.js').Keypad else (require './Keypad.js').Keypad
	KeypadHelper: if process.env.KEYPAD_COVERAGE then (require '../lib-cov/KeypadHelper.js').KeypadHelper else (require './KeypadHelper.js').KeypadHelper
