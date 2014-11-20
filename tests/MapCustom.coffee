{Keypad} = require '..'

exports.MapCustom =

	'MapCustom': (test) ->
		item = new Keypad
			mapping:
				'1': [
					'lè'
					'là'
				]
		test.strictEqual item.text, ''

		item.emit 'press', '1'
		
		test.strictEqual item.character, 'lè'
		test.strictEqual item.GetInsertCharacter(), 'LÈ'
		test.strictEqual item.text, ''

		item.emit 'press', '1'
		
		test.strictEqual item.character, 'là'
		test.strictEqual item.GetInsertCharacter(), 'LÀ'
		test.strictEqual item.text, ''

		item.emit 'timeout'

		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, 'LÀ'

		test.done()
