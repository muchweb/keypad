{Keypad} = require '..'

exports.Constructing =

	'default map_name': (test) ->
		item = new Keypad
		test.strictEqual item.map_name, 'nokia'
		test.done()

	'default delay': (test) ->
		item = new Keypad
		test.strictEqual item.delay, 500
		test.done()

	'default text': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''
		test.done()

	'default character': (test) ->
		item = new Keypad
		test.strictEqual item.character, null
		test.done()

	'default mapping': (test) ->
		item = new Keypad
		test.notStrictEqual item.mapping, null
		test.done()

	'default timeout': (test) ->
		item = new Keypad
		test.strictEqual item.timeout, null
		test.done()
