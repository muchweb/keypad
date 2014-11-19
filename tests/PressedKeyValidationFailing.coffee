{Keypad} = require '..'

exports.ThrowsPress =

	'no pressed key is specified': (test) ->
		item = new Keypad
		test.throws -> item.emit 'press'
		test.done()

	'no holding key is specified': (test) ->
		item = new Keypad
		test.throws -> item.emit 'hold'
		test.done()

	'pressing key is not defined': (test) ->
		item = new Keypad
		test.throws -> item.emit 'press', 'k'
		test.done()

	'holding key is not defined': (test) ->
		item = new Keypad
		test.throws -> item.emit 'hold', 'k'
		test.done()
