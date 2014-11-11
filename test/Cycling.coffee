{Keypad} = require '..'

exports.Cycling =

	'cycling': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '.'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, ','
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '?'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '!'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '\''
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '"'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '1'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '-'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '('
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, ')'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '@'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '/'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, ':'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '_'
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '.'
		test.strictEqual item.text, ''

		test.done()
