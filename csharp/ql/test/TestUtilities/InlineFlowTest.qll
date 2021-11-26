/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * Example for a test.ql:
 * ```ql
 * import csharp
 * import DataFlow::PathGraph
 * import TestUtilities.InlineFlowTest
 *
 * from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultValueFlowConf conf
 * where conf.hasFlowPath(source, sink)
 * select sink, source, sink, "$@", source, source.toString()
 * ```
 *
 * To declare expecations, you can use the $hasTaintFlow or $hasValueFlow comments within the test source files.
 * Example of the corresponding test file, e.g. Test.cs
 * ```csharp
 * public class Test
 * {
 *     object Source() { return null; }
 *     string Taint() { return null; }
 *     void Sink(object o) { }
 *
 *     public void test()
 *     {
 *         var s = Source(1);
 *         Sink(s); // $ hasValueFlow=1
 *         var t = "foo" + Taint(2);
 *         Sink(t); // $ hasTaintFlow=2
 *     }
 * }
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

import csharp
import TestUtilities.InlineExpectationsTest

private predicate defaultSource(DataFlow::Node src) {
  src.asExpr().(MethodCall).getTarget().getUndecoratedName() = ["Source", "Taint"]
}

private predicate defaultSink(DataFlow::Node sink) {
  exists(MethodCall mc | mc.getTarget().hasUndecoratedName("Sink") |
    sink.asExpr() = mc.getAnArgument()
  )
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
  src.asExpr().(MethodCall).getAnArgument().getValue() = result
}

class InlineFlowTest extends InlineExpectationsTest {
  InlineFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | getValueFlowConfig().hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
    or
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      getTaintFlowConfig().hasFlow(src, sink) and not getValueFlowConfig().hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
  }

  DataFlow::Configuration getValueFlowConfig() { result = any(DefaultValueFlowConf config) }

  DataFlow::Configuration getTaintFlowConfig() { result = any(DefaultTaintFlowConf config) }
}
