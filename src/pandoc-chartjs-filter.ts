import { Para, Image, AnyElt, Elt, FilterActionAsync, stdio, Attr } from 'pandoc-filter'
import { parse as parseYaml } from 'yaml'
import fs from 'fs'
import { ChartJSNodeCanvas } from 'chartjs-node-canvas'
import { v4 as uuidv4 } from 'uuid'

const CHART_CODE_BLOCK_TAG = 'chart'

const isChartCodeBlock = ([id, classes, keyVal]: Attr): boolean => {
  return (
    id === CHART_CODE_BLOCK_TAG || (classes.length === 1 && classes[0] === CHART_CODE_BLOCK_TAG)
  )
}

interface ChartMetadata {
  width: number
  height: number
  out: string
}
const DEFAULT_WIDTH = 400
const DEFAULT_HEIGHT = DEFAULT_WIDTH
const DEFAULT_OUT = '.'
const getMetadata = (attr: Attr): ChartMetadata => {
  const attrList = attr[2]

  const metadataRaw = attrList.reduce(
    (result, [key, value]) => {
      result[key] = value
      return result
    },
    {} as { [key: string]: string }
  )

  const metadata = {} as ChartMetadata
  // TODO FK magic numbers/strings to default values (metadata default)
  metadata.width =
    typeof metadataRaw.width !== 'undefined'
      ? parseInt(metadataRaw.width, 10) || DEFAULT_WIDTH
      : DEFAULT_WIDTH
  metadata.height =
    typeof metadataRaw.height !== 'undefined'
      ? parseInt(metadataRaw.height, 10) || DEFAULT_HEIGHT
      : DEFAULT_HEIGHT
  metadata.out = metadataRaw.out || DEFAULT_OUT

  return metadata
}

const generateChartImageBySpec = async (
  { width, height, out }: ChartMetadata,
  chartSpec: any
): Promise<string> => {
  const canvas = new ChartJSNodeCanvas({ width, height })

  const imageUri = `${out}/chart-${uuidv4()}.png`
  const stream = await canvas.renderToStream(chartSpec).pipe(fs.createWriteStream(imageUri))

  return imageUri
}

const chartJsFilter: FilterActionAsync = async (element: AnyElt) => {
  switch (element.t) {
    case 'CodeBlock':
      const [attr, codeBlockText] = (element as Elt<'CodeBlock'>).c
      if (!isChartCodeBlock(attr)) {
        return
      }

      const metadata = getMetadata(attr)
      const chartSpec = parseYaml(codeBlockText)

      const imageUri = await generateChartImageBySpec(metadata, chartSpec).catch(e => {
        return 'https://dummyimage.com/600x400/ffffff/f00000&text=ERROR'
      })
      const inlineElements = [Image(['', [], []], [], [imageUri, ''])]
      return Para(inlineElements)
  }
}

stdio(chartJsFilter)
