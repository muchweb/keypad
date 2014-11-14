{KeypadHelper} = require '..'

exports.KeypadHelperPressingInterrupting =

	'KeypadHelperPressingInterrupting': (test) ->
		item = new KeypadHelper

		item.emit 'down', '2'
		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'down', '3'
			test.strictEqual item.character, null
			test.strictEqual item.GetInsertCharacter(), null
			test.strictEqual item.text, 'A'

			setTimeout ->
				item.emit 'up'
				test.strictEqual item.character, 'b'
				test.strictEqual item.GetInsertCharacter(), 'b'
				test.strictEqual item.text, 'A'

				setTimeout ->
					test.strictEqual item.character, null
					test.strictEqual item.GetInsertCharacter(), null
					test.strictEqual item.text, 'Ab'

					test.done()
				, 1100
			, 100
		, 100
