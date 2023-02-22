/**
 * Defines graphs and charts that can be rendered by VScode.
 *
 * Graphs are output using the query predicates
 * `graph_info`, `graph_chart`, `graph_xy`, `graph_span`
 *
 * The class `Graph` is used to define graph contents.
 * It is possible to define several graphs in the same query file, by using
 * a different name for each graph object.
 */
module Graph {
  /**
   * A graph that the VSCode extension can render.
   * Extend this class to add new graphs.
   */
  abstract class Graph extends string {
    bindingset[this]
    Graph() { any() }

    /**
     * Gets the type of the graph: Currently "bar", "line" or "flame"
     */
    abstract string getType();

    /**
     * Gets the title of the graph, can be overridden.
     */
    string getTitle() { result = this }

    /**
     * Defines chart data, required for chart type = "bar"
     */
    predicate chartData(string key, int series, float value) { none() }

    /**
     * Defines point data.
     * `series` can be set to 0 if there is only one series in the graph.
     */
    predicate pointData(int series, float x, float y) { none() }

    /**
     * Defines span data, for use in flame graphs.
     */
    predicate spanData(string item, float start, float end) { none() }
  }

  query predicate graph_info(Graph graph, string field, string value) {
    field = "type" and value = graph.getType()
    or
    field = "title" and value = graph.getTitle()
  }

  query predicate graph_chart(Graph graph, string key, int series, float value) {
    graph.chartData(key, series, value)
  }

  query predicate graph_xy(Graph graph, int series, float x, float y) {
    graph.pointData(series, x, y)
  }

  query predicate graph_span(Graph graph, string item, float start, float end) {
    graph.spanData(item, start, end)
  }
}
