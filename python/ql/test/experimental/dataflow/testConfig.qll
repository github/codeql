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
 *
 * In order to test literals, alternative sources are defined for each type:
 *
 *  for | use
 * ----------
 * string | `"source"`
 * integer | `42`
 * float | `42.0`
 * complex | `42j` (not supported yet)
 */

private import python
import experimental.dataflow.DataFlow

class TestConfiguration extends DataFlow::Configuration {
  TestConfiguration() { this = "TestConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "SOURCE"
    or
    node.(DataFlow::CfgNode).getNode().getNode().(StrConst).getS() = "source"
    or
    node.(DataFlow::CfgNode).getNode().getNode().(IntegerLiteral).getN() = "42"
    or
    node.(DataFlow::CfgNode).getNode().getNode().(FloatLiteral).getN() = "42.0"
    // No support for complex numbers
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() in ["SINK", "SINK_F"] and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  override int explorationLimit() { result = 4 }
}
