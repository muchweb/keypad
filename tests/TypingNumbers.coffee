{Keypad} = require '..'

exports.TypingNumbers =

	'typing numbers by holding': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'hold', '8'
		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, '8'

		setTimeout ->
			item.emit 'hold', '5'
			test.strictEqual item.character, null
			test.strictEqual item.GetInsertCharacter(), null
			test.strictEqual item.text, '85'

			setTimeout ->
				item.emit 'hold', '3'
				test.strictEqual item.character, null
				test.strictEqual item.GetInsertCharacter(), null
				test.strictEqual item.text, '853'

				test.done()
			, 500
		, 500
