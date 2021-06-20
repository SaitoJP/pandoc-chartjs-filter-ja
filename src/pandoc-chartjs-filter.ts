import { Para, Image, AnyElt, Elt, FilterActionAsync, stdio, Attr } from 'pandoc-filter'
import { parse as parseYaml, stringify } from 'yaml'

const CHART_CODE_BLOCK_TAG = 'chart'

const isChartCodeBlock = ([id, classes, keyVal]: Attr): boolean => {
  return (
    id === CHART_CODE_BLOCK_TAG || (classes.length === 1 && classes[0] === CHART_CODE_BLOCK_TAG)
  )
}

const QUICK_CHART_CHART_ENDPOINT = 'https://quickchart.io/chart'

const constructQuickChartImageUrl = (chartSpec: any) =>
  `${QUICK_CHART_CHART_ENDPOINT}?c=${encodeURIComponent(JSON.stringify(chartSpec))}`

const chartJsFilter: FilterActionAsync = async (element: AnyElt) => {
  switch (element.t) {
    case 'CodeBlock':
      const [attr, codeBlockText] = (element as Elt<'CodeBlock'>).c
      if (!isChartCodeBlock(attr)) {
        return
      }
      const chartSpec = parseYaml(codeBlockText)
      const quickQuartImageUrl = constructQuickChartImageUrl(chartSpec)
      const inlineElements = [Image(['', [], []], [], [quickQuartImageUrl, ''])]
      return Para(inlineElements)
  }
}

stdio(chartJsFilter)
