prepare:
	mkdir -p dist && \
	mkdir -p bin 

clean:
	rm -rf dist/* && \
	rm -rf bin/*

build:
	make prepare && \
	make clean && \
	npm run build && \
	sed -e '1s|^|#!/usr/bin/env node\n|' dist/pandoc-chartjs-filter.js > bin/pandoc-chartjs-filter.sh
