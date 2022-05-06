.PHONY : clean
clean:
	rm -rf dist bin node_modules && \
	mkdir -p dist/examples bin

# TODO not phony?
.PHONY : build
build:
	make clean && \
	npm install && \
	npm run build && \
	sed -e '1s|^|#!/usr/bin/env node\n|' dist/pandoc-chartjs-filter.js > bin/pandoc-chartjs-filter.sh

.PHONY : examples
examples:
	find examples -name '*.md' -type f -exec  basename {} .md \; | \
	xargs -n1 -I{} pandoc --from markdown --to pdf --filter pandoc-chartjs-filter -o dist/examples/{}.pdf examples/{}.md
