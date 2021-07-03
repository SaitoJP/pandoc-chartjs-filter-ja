## Setup

To install the filter locally, run
```bash
make build
npm install -g .
```
from this directory.

Check that the filter is available globally by executing `which`. E.g.
```bash
$ which pandoc-chartjs-filter
/Users/main/.nvm/versions/node/v14.17.2/bin/pandoc-chartjs-filter
```

## Usage
Our _pandoc-chartjs-filter_ expects a [fenced code block](https://www.markdownguide.org/extended-syntax/#fenced-code-blocks) with class _chart_ that contains a chart.js chart specification object in YAML format.

Take a look at the [line chart example](./../examples/line-chart.md) in the examples directory and the chart.js docs for additional information.

## Contributing

Enable the precommit hooks by installing [pre-commit](https://pre-commit.com/) and then running.
```bash
pre-commit install
```

The repository contains a Makefile which can be used to build the filter.
```bash
make build
```
The build script will run the TypeScript compiler on the source and put the compiled JavaScript into the _dist/_ folder. Additionally, a shell script will be put into the _bin/_ folder.

Running 
```bash
npm install -g .
```
will install the filter locally for tests.

## Examples

After building and installing the filter, run e.g.
```bash
pandoc --from markdown --to pdf examples/line-chart.md --filter pandoc-chartjs-filter > /tmp/line-chart.pdf
```
Note that we pass _pandoc-chartjs-filter_ as an additional filter using the _--filter_ option.

The result should be a single page PDF looking similar to this

> ![line chart example PDF output](./../assets/line-chart-example.png) 

## Acknowledgements

Thanks to the makers of [quickchart.io](https://quickchart.io/) and the [pandoc-filter-node](https://github.com/mvhenderson/pandoc-filter-node) package.
