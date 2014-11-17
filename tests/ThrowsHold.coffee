{Keypad} = require '..'

exports.ThrowsHold =

	'no holding key is specified': (test) ->
		item = new Keypad

		test.throws ->
			item.emit 'hold'

		test.done()
