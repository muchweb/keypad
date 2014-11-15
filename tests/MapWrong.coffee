{Keypad} = require '..'

exports.MapWrong =

	'MapWrong': (test) ->
		test.throws ->
			item = new Keypad
				map_name: 'dosn\'t exist'

		test.done()
