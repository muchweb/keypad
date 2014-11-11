{Keypad} = require '..'

exports.Timeout =

	'timeout': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '.'
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'push', '1'
			test.strictEqual item.character, '.'
			test.strictEqual item.text, '.'

			setTimeout ->
				test.strictEqual item.character, null
				test.strictEqual item.text, '..'

				test.done()
			, 1000
		, 1000
