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
 * `SOURCE` will be a source and the second occurrence of `s` will be a sink.
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
import semmle.python.dataflow.new.DataFlow

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "SOURCE"
    or
    node.(DataFlow::CfgNode).getNode().getNode().(StringLiteral).getS() = "source"
    or
    node.(DataFlow::CfgNode).getNode().getNode().(IntegerLiteral).getN() = "42"
    or
    node.(DataFlow::CfgNode).getNode().getNode().(FloatLiteral).getN() = "42.0"
    // No support for complex numbers
  }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallCfgNode call |
      call.getFunction().asCfgNode().(NameNode).getId() in ["SINK", "SINK_F"] and
      (node = call.getArg(_) or node = call.getArgByName(_)) and
      not node = call.getArgByName("not_present_at_runtime")
    )
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

module TestFlow = DataFlow::Global<TestConfig>;
