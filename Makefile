all: lib/main.js

./node_modules/.bin/coffee ./node_modules/.bin/nodeunit ./node_modules/.bin/jscoverage ./node_modules/.bin/coveralls:
	npm install

lib/main.js: src/main.coffee src/Keypad.coffee ./node_modules/.bin/coffee
	mkdir -p lib
	./node_modules/.bin/coffee --compile --output lib src

test: lib/main.js ./node_modules/.bin/nodeunit
	./node_modules/.bin/nodeunit tests/*

lib-cov/main.js: lib/main.js ./node_modules/.bin/jscoverage
	./node_modules/.bin/jscoverage lib

coverage.info: lib-cov/main.js ./node_modules/.bin/nodeunit
	KEYPAD_COVERAGE=1 ./node_modules/.bin/nodeunit --reporter=lcov tests/* > coverage.info

coveralls: coverage.info ./node_modules/.bin/coveralls
	KEYPAD_COVERAGE=1 ./node_modules/.bin/nodeunit --reporter=lcov tests/* | ./node_modules/.bin/coveralls

report: lib/main.js coverage.info ./node_modules/.bin/nodeunit
	genhtml coverage.info

clean:
	rm coverage.info
	rm -r lib
	rm -r lib-cov
	rm -r out
