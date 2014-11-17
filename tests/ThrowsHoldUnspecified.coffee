{Keypad} = require '..'

exports.ThrowsPressUnspecified =

	'holding key is not defined': (test) ->
		item = new Keypad

		test.throws ->
			item.emit 'hold', 'k'

		test.done()
