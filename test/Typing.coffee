{Keypad} = require '..'

exports.Typing =

	'typing': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'push', '8'
		test.strictEqual item.character, 't'
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'push', '3'
			test.strictEqual item.character, 'd'
			test.strictEqual item.text, 't'

			setTimeout ->
				item.emit 'push', '3'
				test.strictEqual item.character, 'e'
				test.strictEqual item.text, 't'

				setTimeout ->
					item.emit 'push', '7'
					test.strictEqual item.character, 'p'
					test.strictEqual item.text, 'te'

					setTimeout ->
						item.emit 'push', '7'
						test.strictEqual item.character, 'q'
						test.strictEqual item.text, 'te'

						setTimeout ->
							item.emit 'push', '7'
							test.strictEqual item.character, 'r'
							test.strictEqual item.text, 'te'

							setTimeout ->
								item.emit 'push', '7'
								test.strictEqual item.character, 's'
								test.strictEqual item.text, 'te'

								setTimeout ->
									item.emit 'push', '8'
									test.strictEqual item.character, 't'
									test.strictEqual item.text, 'tes'

									setTimeout ->
										test.strictEqual item.character, null
										test.strictEqual item.text, 'test'

										test.done()
									, 400
								, 10
							, 10
						, 10
					, 10
				, 10
			, 10
		, 10
