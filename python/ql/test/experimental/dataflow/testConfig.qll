/**
 * Configuration to test selected data flow
 * Sources in the source code are denoted by the special name `SOURCE`,
 * and sinks are denoted by arguments to the special function `SINK`.
 * For example, given the test code
 * ```python
 *  def test():
 *      s = SOURCE
 *      SINK(s)
 * ```
 * `SOURCE` will be a source and the second occurance of `s` will be a sink.
 */

import experimental.dataflow.DataFlow

class TestConfiguration extends DataFlow::Configuration {
  TestConfiguration() { this = "TestConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    node.asCfgNode().(NameNode).getId() = "SOURCE"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      node.asCfgNode() = call.getAnArg()
    )
  }
}
