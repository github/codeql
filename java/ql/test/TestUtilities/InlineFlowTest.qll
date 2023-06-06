/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * Example for a test.ql:
 * ```ql
 * import java
 * import TestUtilities.InlineFlowTest
 * ```
 *
 * To declare expectations, you can use the $hasTaintFlow or $hasValueFlow comments within the test source files.
 * Example of the corresponding test file, e.g. Test.java
 * ```java
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

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest

private predicate defaultSource(DataFlow::Node src) {
  src.asExpr().(MethodAccess).getMethod().getName() = ["source", "taint"]
}

module DefaultFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { defaultSource(n) }

  predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }

  int fieldFlowBranchLimit() { result = 1000 }
}

private module DefaultValueFlow = DataFlow::Global<DefaultFlowConfig>;

private module DefaultTaintFlow = TaintTracking::Global<DefaultFlowConfig>;

private string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  src.asExpr().(MethodAccess).getAnArgument().(StringLiteral).getValue() = result
}

class InlineFlowTest extends InlineExpectationsTest {
  InlineFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | this.hasValueFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
    or
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      this.hasTaintFlow(src, sink) and not this.hasValueFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
  }

  predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) {
    DefaultValueFlow::flow(src, sink)
  }

  predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    DefaultTaintFlow::flow(src, sink)
  }
}
