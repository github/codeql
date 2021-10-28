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

class DefaultValueFlowConf extends DataFlow::Configuration {
  DefaultValueFlowConf() { this = "qltest:defaultValueFlowConf" }

  override predicate isSource(DataFlow::Node n) { defaultSource(n) }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }

  override int fieldFlowBranchLimit() { result = 1000 }
}

class DefaultTaintFlowConf extends TaintTracking::Configuration {
  DefaultTaintFlowConf() { this = "qltest:defaultTaintFlowConf" }

  override predicate isSource(DataFlow::Node n) { defaultSource(n) }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }

  override int fieldFlowBranchLimit() { result = 1000 }
}

private string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  src.asExpr().(MethodAccess).getAnArgument().(StringLiteral).getValue() = result
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
