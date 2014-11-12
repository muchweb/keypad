{Keypad} = require '..'

exports.TypingBackspacing =

	'typing and using backspace': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'press', '8'
		test.strictEqual item.character, 't'
		test.strictEqual item.GetInsertCharacter(), 'T'
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'press', '3'
			test.strictEqual item.character, 'd'
			test.strictEqual item.GetInsertCharacter(), 'd'
			test.strictEqual item.text, 'T'

			setTimeout ->
				item.emit 'press', '7'
				test.strictEqual item.character, 'p'
				test.strictEqual item.GetInsertCharacter(), 'p'
				test.strictEqual item.text, 'Td'

				setTimeout ->
					item.emit 'press', 'c'
					test.strictEqual item.character, null
					test.strictEqual item.GetInsertCharacter(), null
					test.strictEqual item.text, 'T'
		
					setTimeout ->
						item.emit 'press', 'c'
						test.strictEqual item.character, null
						test.strictEqual item.GetInsertCharacter(), null
						test.strictEqual item.text, ''

						setTimeout ->
							item.emit 'press', 'c'
							test.strictEqual item.character, null
							test.strictEqual item.GetInsertCharacter(), null
							test.strictEqual item.text, ''

							test.done()
						, 300
					, 10
				, 10
			, 10
		, 10
