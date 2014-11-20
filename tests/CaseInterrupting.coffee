{Keypad} = require '..'

exports.CaseInterrupting =

	'case interrupt with period': (test) ->
		item = new Keypad

		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, ''

		item.emit 'press', '2'
		test.strictEqual item.character, 'a'
		test.strictEqual item.GetInsertCharacter(), 'A'
		test.strictEqual item.text, ''

		item.emit 'press', '1'
		test.strictEqual item.character, '.'
		test.strictEqual item.GetInsertCharacter(), '.'
		test.strictEqual item.text, 'A'

		item.emit 'press', '2'
		test.strictEqual item.character, 'a'
		test.strictEqual item.GetInsertCharacter(), 'A'
		test.strictEqual item.text, 'A.'

		item.emit 'timeout'

		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, 'A.A'

		test.done()

	'case interrupt with space': (test) ->
		item = new Keypad

		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, ''

		item.emit 'press', '2'
		test.strictEqual item.character, 'a'
		test.strictEqual item.GetInsertCharacter(), 'A'
		test.strictEqual item.text, ''

		item.emit 'press', '0'
		test.strictEqual item.character, ' '
		test.strictEqual item.GetInsertCharacter(), ' '
		test.strictEqual item.text, 'A'

		item.emit 'press', '2'
		test.strictEqual item.character, 'a'
		test.strictEqual item.GetInsertCharacter(), 'a'
		test.strictEqual item.text, 'A '

		item.emit 'timeout'

		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, 'A a'

		test.done()
