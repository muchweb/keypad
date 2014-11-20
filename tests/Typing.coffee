{Keypad} = require '..'

exports.Typing =

	'typing': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'press', '8'
		test.strictEqual item.character, 't'
		test.strictEqual item.GetInsertCharacter(), 'T'
		test.strictEqual item.text, ''

		item.emit 'press', '3'
		test.strictEqual item.character, 'd'
		test.strictEqual item.GetInsertCharacter(), 'd'
		test.strictEqual item.text, 'T'

		item.emit 'press', '3'
		test.strictEqual item.character, 'e'
		test.strictEqual item.GetInsertCharacter(), 'e'
		test.strictEqual item.text, 'T'

		item.emit 'press', '7'
		test.strictEqual item.character, 'p'
		test.strictEqual item.GetInsertCharacter(), 'p'
		test.strictEqual item.text, 'Te'

		item.emit 'press', '7'
		test.strictEqual item.character, 'q'
		test.strictEqual item.GetInsertCharacter(), 'q'
		test.strictEqual item.text, 'Te'

		item.emit 'press', '7'
		test.strictEqual item.character, 'r'
		test.strictEqual item.GetInsertCharacter(), 'r'
		test.strictEqual item.text, 'Te'

		item.emit 'press', '7'
		test.strictEqual item.character, 's'
		test.strictEqual item.GetInsertCharacter(), 's'
		test.strictEqual item.text, 'Te'

		item.emit 'press', '8'
		test.strictEqual item.character, 't'
		test.strictEqual item.GetInsertCharacter(), 't'
		test.strictEqual item.text, 'Tes'

		item.emit 'timeout'

		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, 'Test'

		test.done()
