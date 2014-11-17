{Keypad} = require '..'

exports.ThrowsPress =

	'no pressed key is specified': (test) ->
		item = new Keypad

		test.throws ->
			item.emit 'press'

		test.done()
