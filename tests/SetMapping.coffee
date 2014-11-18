{Keypad} = require '..'

exports.SetMapping =

	'Just correct mapping': (test) ->
		item = new Keypad

		item.emit 'press', '0'
		test.strictEqual item.character, ' '

		setTimeout ->
			item.SetMapping 'sonyericsson'

			item.emit 'press', '0'
			test.strictEqual item.character, '+'

			test.done()
		, 1000

	'Correct mapping and correct language': (test) ->
		item = new Keypad

		item.emit 'press', '0'
		test.strictEqual item.character, ' '

		setTimeout ->
			item.SetMapping 'sonyericsson', 'en'

			item.emit 'press', '0'
			test.strictEqual item.character, '+'

			test.done()
		, 1000

	'Correct mapping and wrong language': (test) ->
		item = new Keypad

		test.throws ->
			item.SetMapping 'sonyericsson', 'là'

		test.done()

	'Wrong mapping and correct language': (test) ->
		item = new Keypad

		test.throws ->
			item.SetMapping 'sonyßricsson', 'en'

		test.done()

	'Wrong mapping and wrong language': (test) ->
		item = new Keypad

		test.throws ->
			item.SetMapping 'sonyßricsson', 'là'

		test.done()
