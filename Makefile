SOURCES=src/KeypadHelper.coffee src/Keypad.coffee src/main.coffee src/MapNokia.coffee src/MapSonyericsson.coffee
LIBS=lib/KeypadHelper.js lib/Keypad.js lib/main.js lib/MapNokia.js lib/MapSonyericsson.js
COVS=lib-cov/KeypadHelper.js lib-cov/Keypad.js lib-cov/main.js lib-cov/MapNokia.js lib-cov/MapSonyericsson.js

all: $(LIBS)

./node_modules/.bin/coffee ./node_modules/.bin/nodeunit ./node_modules/.bin/jscoverage ./node_modules/.bin/coveralls:
	npm install

$(LIBS): $(SOURCES) ./node_modules/.bin/coffee
	mkdir -p lib
	./node_modules/.bin/coffee --compile --output lib src

test: $(LIBS) ./node_modules/.bin/nodeunit
	./node_modules/.bin/nodeunit tests/*

$(COVS): $(LIBS) ./node_modules/.bin/jscoverage
	./node_modules/.bin/jscoverage lib

coverage.info: $(COVS) ./node_modules/.bin/nodeunit
	KEYPAD_COVERAGE=1 ./node_modules/.bin/nodeunit --reporter=lcov tests/* > coverage.info

coveralls: coverage.info ./node_modules/.bin/coveralls
	KEYPAD_COVERAGE=1 ./node_modules/.bin/nodeunit --reporter=lcov tests/* | ./node_modules/.bin/coveralls

report: $(LIBS) coverage.info
	make clean
	genhtml coverage.info

clean:
	rm -f coverage.info
	rm -rf lib
	rm -rf lib-cov
	rm -rf out
