{Keypad} = require '..'

exports.CaseInterruptPeriod =

	'case interrupt period': (test) ->
		item = new Keypad

		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, ''

		item.emit 'press', '2'
		test.strictEqual item.character, 'a'
		test.strictEqual item.GetInsertCharacter(), 'A'
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'press', '1'
			test.strictEqual item.character, '.'
			test.strictEqual item.GetInsertCharacter(), '.'
			test.strictEqual item.text, 'A'

			setTimeout ->
				item.emit 'press', '2'
				test.strictEqual item.character, 'a'
				test.strictEqual item.GetInsertCharacter(), 'A'
				test.strictEqual item.text, 'A.'

				setTimeout ->
					test.strictEqual item.character, null
					test.strictEqual item.GetInsertCharacter(), null
					test.strictEqual item.text, 'A.A'

					test.done()
				, 1000
			, 10
		, 10
