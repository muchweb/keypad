{Keypad} = require '..'

exports.MapSonyericsson =

	'MapSonyericsson': (test) ->
		item = new Keypad
			map_name: 'sonyericsson'

		item.emit 'press', '0'
		test.strictEqual item.character, '+'

		test.done()
