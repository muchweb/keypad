{Keypad} = require '..'

exports.SetMapping =

	'SetMapping': (test) ->
		item = new Keypad

		item.emit 'press', '0'
		test.strictEqual item.character, ' '

		setTimeout ->
			item.SetMapping 'sonyericsson'

			item.emit 'press', '0'
			test.strictEqual item.character, '+'

			test.done()
		, 1000
