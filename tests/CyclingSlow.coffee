{Keypad} = require '..'

exports.CyclingSlow =

	'cycling slowly': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'push', '1'
			test.strictEqual item.character, '.'
			test.strictEqual item.text, ''

			setTimeout ->
				item.emit 'push', '1'
				test.strictEqual item.character, ','
				test.strictEqual item.text, ''

				setTimeout ->
					item.emit 'push', '1'
					test.strictEqual item.character, '?'
					test.strictEqual item.text, ''

					setTimeout ->
						item.emit 'push', '1'
						test.strictEqual item.character, '!'
						test.strictEqual item.text, ''

						setTimeout ->
							item.emit 'push', '1'
							test.strictEqual item.character, '\''
							test.strictEqual item.text, ''

							setTimeout ->
								item.emit 'push', '1'
								test.strictEqual item.character, '"'
								test.strictEqual item.text, ''

								setTimeout ->
									item.emit 'push', '1'
									test.strictEqual item.character, '1'
									test.strictEqual item.text, ''

									setTimeout ->
										item.emit 'push', '1'
										test.strictEqual item.character, '-'
										test.strictEqual item.text, ''

										setTimeout ->
											item.emit 'push', '1'
											test.strictEqual item.character, '('
											test.strictEqual item.text, ''

											setTimeout ->
												item.emit 'push', '1'
												test.strictEqual item.character, ')'
												test.strictEqual item.text, ''

												setTimeout ->
													item.emit 'push', '1'
													test.strictEqual item.character, '@'
													test.strictEqual item.text, ''

													test.done()
												, 80
											, 80
										, 80
									, 80
								, 80
							, 80
						, 80
					, 80
				, 80
			, 80
		, 80
