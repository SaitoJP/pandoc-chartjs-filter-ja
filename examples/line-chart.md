# Line Chart Example

A very simple example using the default parameter and a line chart spec.

See [chart.js line chart docs](https://www.chartjs.org/docs/latest/charts/line.html) for reference.

```chart
type: line
data:  
  labels: [１月, ２月, ３月, ４月, ５月, ６月, ７月, ８月, ９月, １０月, １１月, １２月]
  datasets: 
    - label: My First Dataset
      data: [65, 59, 80, 81, 56, 55, 40]
      fill: "false"
      borderColor: rgb(75, 192, 192)
      tension: 0.1
```
