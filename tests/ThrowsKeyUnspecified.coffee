{Keypad} = require '..'

exports.ThrowsKeyUnspecified =

	'pressing key is not defined': (test) ->
		item = new Keypad

		test.throws ->
			item.emit 'press', 'k'

		test.done()
