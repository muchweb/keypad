{Keypad} = require '..'

exports.MapNokia =

	'MapNokia': (test) ->
		item = new Keypad

		item.emit 'press', '0'
		test.strictEqual item.character, ' '

		test.done()
