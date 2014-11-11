all: lib/main.js

test: lib/main.js ./node_modules/.bin/nodeunit
	./node_modules/.bin/nodeunit tests/*

clean:
	rm -rf lib

lib/main.js: src/main.coffee src/Keypad.coffee ./node_modules/.bin/coffee
	mkdir -p lib
	./node_modules/.bin/coffee --map --compile --output lib src

./node_modules/.bin/coffee ./node_modules/.bin/nodeunit:
	npm install
