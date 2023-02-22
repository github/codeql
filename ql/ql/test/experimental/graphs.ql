/**
 * Sample/test of the graphs library.
 */

import experimental.Graph::Graph

class SampleBarChart extends Graph {
  SampleBarChart() { this = "Here is a bar chart" }

  override string getType() { result = "bar" }

  override predicate chartData(string key, int series, float value) {
    key = "C++" and series = 0 and value = 21.0
    or
    key = "Python" and series = 0 and value = 3.1
    or
    key = "TypeScript" and series = 0 and value = 5.0
  }
}

class SampleLineGraph extends Graph {
  SampleLineGraph() { this = "Here is a line chart" }

  override string getType() { result = "line" }

  override predicate pointData(int series, float x, float y) {
    series = 0 and x in [-10 .. 10] and y = x * x
    or
    series = 1 and x in [-10 .. 10] and y = -5 + 2 * x
  }
}

class SampleFlameGraph extends Graph {
  SampleFlameGraph() { this = "Here is the flame graph" }

  override string getType() { result = "flame" }

  override predicate spanData(string item, float start, float end) {
    item = "Item1" and start = 0 and end = 100
    or
    item = "Item2" and start = 0 and end = 25
    or
    item = "Item3" and start = 10 and end = 20
  }
}
