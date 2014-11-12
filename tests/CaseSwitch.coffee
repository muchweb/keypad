{Keypad} = require '..'

exports.CaseSwitch =

	'switching case': (test) ->
		item = new Keypad

		test.strictEqual item.case, 'Abc', 'run 1'

		item.emit 'press', '#'

		test.strictEqual item.case, 'abc', 'run 2'

		item.emit 'press', '#'

		test.strictEqual item.case, 'ABC', 'run 3'

		item.emit 'press', '#'

		test.strictEqual item.case, '123', 'run 4'

		item.emit 'press', '#'

		test.strictEqual item.case, 'Abc', 'run 5'

		test.done()
