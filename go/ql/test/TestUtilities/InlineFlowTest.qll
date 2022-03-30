/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * Example for a test.ql:
 * ```ql
 * import java
 * import TestUtilities.InlineFlowTest
 * ```
 *
 * To declare expecations, you can use the $hasTaintFlow or $hasValueFlow comments within the test source files.
 * Example of the corresponding test file, e.g. Test.java
 * ```go
 * public class Test {
 *
 * 	Object source() { return null; }
 * 	String taint() { return null; }
 * 	void sink(Object o) { }
 *
 * 	public void test() {
 * 		Object s = source();
 * 		sink(s); //$hasValueFlow
 * 		String t = "foo" + taint();
 * 		sink(t); //$hasTaintFlow
 * 	}
 *
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

import go
import TestUtilities.InlineExpectationsTest

private predicate defaultSource(DataFlow::Node source) {
  exists(Function fn | fn.hasQualifiedName(_, ["source", "taint"]) |
    source = fn.getACall().getResult()
  )
}

class DefaultValueFlowConf extends DataFlow::Configuration {
  DefaultValueFlowConf() { this = "qltest:defaultValueFlowConf" }

  override predicate isSource(DataFlow::Node source) { defaultSource(source) }

  override predicate isSink(DataFlow::Node sink) {
    exists(Function fn | fn.hasQualifiedName(_, "sink") | sink = fn.getACall().getAnArgument())
  }

  override int fieldFlowBranchLimit() { result = 1000 }
}

class DefaultTaintFlowConf extends TaintTracking::Configuration {
  DefaultTaintFlowConf() { this = "qltest:defaultTaintFlowConf" }

  override predicate isSource(DataFlow::Node source) { defaultSource(source) }

  override predicate isSink(DataFlow::Node sink) {
    exists(Function fn | fn.hasQualifiedName(_, "sink") | sink = fn.getACall().getAnArgument())
  }

  override int fieldFlowBranchLimit() { result = 1000 }
}

class InlineFlowTest extends InlineExpectationsTest {
  InlineFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | getValueFlowConfig().hasFlow(src, sink) |
      sink.hasLocationInfo(file, line, _, _, _) and
      element = sink.toString() and
      value = "\"" + sink.toString() + "\""
    )
    or
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      getTaintFlowConfig().hasFlow(src, sink) and not getValueFlowConfig().hasFlow(src, sink)
    |
      sink.hasLocationInfo(file, line, _, _, _) and
      element = sink.toString() and
      value = "\"" + sink.toString() + "\""
    )
  }

  DataFlow::Configuration getValueFlowConfig() { result = any(DefaultValueFlowConf config) }

  DataFlow::Configuration getTaintFlowConfig() { result = any(DefaultTaintFlowConf config) }
}
