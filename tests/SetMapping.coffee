{Keypad} = require '..'

exports.SetMapping =

	'Dynamically: no map name': (test) ->
		item = new Keypad

		test.throws ->
			item.SetMapping()

		test.done()

	'Dynamically: just correct mapping': (test) ->
		item = new Keypad

		item.emit 'press', '0'
		test.strictEqual item.character, ' '

		item.emit 'timeout'
		
		item.SetMapping 'sonyericsson'

		item.emit 'press', '0'
		test.strictEqual item.character, '+'

		test.done()

	'Dynamically: correct mapping and correct language': (test) ->
		item = new Keypad

		item.emit 'press', '0'
		test.strictEqual item.character, ' '

		item.emit 'timeout'

		item.SetMapping 'sonyericsson', 'en'

		item.emit 'press', '0'
		test.strictEqual item.character, '+'

		test.done()

	'Dynamically: correct mapping and wrong language': (test) ->
		item = new Keypad

		test.throws ->
			item.SetMapping 'sonyericsson', 'là'

		test.done()

	'Dynamically: wrong mapping and correct language': (test) ->
		item = new Keypad

		test.throws ->
			item.SetMapping 'sonyßricsson', 'en'

		test.done()

	'Dynamically: wrong mapping and wrong language': (test) ->
		item = new Keypad

		test.throws ->
			item.SetMapping 'sonyßricsson', 'là'

		test.done()

	# 'Constructor: Just correct language': (test) ->
	# 	item = new Keypad
	# 		map_language: 'en'
	#
	# 	item.emit 'press', '0'
	# 	test.strictEqual item.character, '+'
	# 	test.done()

	'Constructor: Just correct mapping': (test) ->
		item = new Keypad
			map_name: 'sonyericsson'

		item.emit 'press', '0'
		test.strictEqual item.character, '+'
		test.done()

	'Constructor: correct mapping and correct language': (test) ->
		item = new Keypad
			map_name: 'sonyericsson'
			map_language: 'en'

		item.emit 'press', '0'
		test.strictEqual item.character, '+'
		test.done()

	'Constructor: correct mapping and wrong language': (test) ->
		test.throws ->
			item = new Keypad
				map_name: 'sonyericsson'
				map_language: 'là'
		test.done()

	'Constructor: wrong mapping and correct language': (test) ->
		test.throws ->
			item = new Keypad
				map_name: 'sonyßricsson'
				map_language: 'en'
		test.done()

	'Constructor: wrong mapping and wrong language': (test) ->
		test.throws ->
			item = new Keypad
				map_name: 'sonyßricsson'
				map_language: 'là'
		test.done()
