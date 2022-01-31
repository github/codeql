/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * Example for a test.ql:
 * ```ql
 * import ruby
 * import TestUtilities.InlineFlowTest
 * import PathGraph
 *
 * from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultValueFlowConf conf
 * where conf.hasFlowPath(source, sink)
 * select sink, source, sink, "$@", source, source.toString()
 * ```
 *
 * To declare expecations, you can use the $hasTaintFlow or $hasValueFlow comments within the test source files.
 * Example of the corresponding test file, e.g. test.rb
 * ```rb
 * s = source(1)
 * sink(s); // $ hasValueFlow=1
 * t = "foo" + taint(2);
 * sink(t); // $ hasTaintFlow=2
 * ```
 *
 * If you're not interested in a specific flow type, you can disable either value or taint flow expectations as follows:
 * ```ql
 * class HasFlowTest extends InlineFlowTest {
 *   override DataFlow::Configuration getTaintFlowConfig() { none() }
 *
 *   override DataFlow::Configuration getValueFlowConfig() { none() }
 * }
 * ```
 *
 * If you need more fine-grained tuning, consider implementing a test using `InlineExpectationsTest`.
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import TestUtilities.InlineExpectationsTest

private predicate defaultSource(DataFlow::Node src) {
  src.asExpr().getExpr().(MethodCall).getMethodName() = ["source", "taint"]
}

private predicate defaultSink(DataFlow::Node sink) {
  exists(MethodCall mc | mc.getMethodName() = "sink" | sink.asExpr().getExpr() = mc.getAnArgument())
}

class DefaultValueFlowConf extends DataFlow::Configuration {
  DefaultValueFlowConf() { this = "qltest:defaultValueFlowConf" }

  override predicate isSource(DataFlow::Node n) { defaultSource(n) }

  override predicate isSink(DataFlow::Node n) { defaultSink(n) }

  override int fieldFlowBranchLimit() { result = 1000 }
}

class DefaultTaintFlowConf extends TaintTracking::Configuration {
  DefaultTaintFlowConf() { this = "qltest:defaultTaintFlowConf" }

  override predicate isSource(DataFlow::Node n) { defaultSource(n) }

  override predicate isSink(DataFlow::Node n) { defaultSink(n) }

  override int fieldFlowBranchLimit() { result = 1000 }
}

private string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  src.asExpr().getExpr().(MethodCall).getAnArgument().getConstantValue().toString() = result
}

class InlineFlowTest extends InlineExpectationsTest {
  InlineFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | this.getValueFlowConfig().hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
    or
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      this.getTaintFlowConfig().hasFlow(src, sink) and
      not this.getValueFlowConfig().hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
  }

  DataFlow::Configuration getValueFlowConfig() { result = any(DefaultValueFlowConf config) }

  DataFlow::Configuration getTaintFlowConfig() { result = any(DefaultTaintFlowConf config) }
}

module PathGraph {
  private import DataFlow::PathGraph as PG

  private class PathNode extends DataFlow::PathNode {
    PathNode() {
      this.getConfiguration() =
        [any(InlineFlowTest t).getValueFlowConfig(), any(InlineFlowTest t).getTaintFlowConfig()]
    }
  }

  /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode a, PathNode b) { PG::edges(a, b) }

  /** Holds if `n` is a node in the graph of data flow path explanations. */
  query predicate nodes(PathNode n, string key, string val) { PG::nodes(n, key, val) }

  query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
    PG::subpaths(arg, par, ret, out)
  }
}
