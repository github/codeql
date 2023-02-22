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

  override predicate flameData(string id, string text, string parent, float value, float offset) {
    id = "item1" and text = "Item 1" and parent = "" and value = 50 and offset = 0
    or
    id = "item2" and text = "Item 2" and parent = "item1" and value = 25 and offset = 0
    or
    id = "item3" and text = "Item 3" and parent = "item2" and value = 10 and offset = 5
  }
}
