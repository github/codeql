/**
 * Inline flow tests for Java.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import java
import semmle.code.java.dataflow.DataFlow
private import codeql.dataflow.test.InlineFlowTest
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
private import semmle.code.java.dataflow.internal.TaintTrackingImplSpecific
private import internal.InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<JavaDataFlow> {
  predicate defaultSource(DataFlow::Node source) {
    source.asExpr().(MethodCall).getMethod().getName() = ["source", "taint"]
  }

  predicate defaultSink(DataFlow::Node sink) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | sink.asExpr() = ma.getAnArgument())
  }

  private string getSourceArgString(DataFlow::Node src) {
    defaultSource(src) and
    src.asExpr().(MethodCall).getAnArgument().(StringLiteral).getValue() = result
  }

  string getArgString(DataFlow::Node src, DataFlow::Node sink) {
    (if exists(getSourceArgString(src)) then result = getSourceArgString(src) else result = "") and
    exists(sink)
  }
}

import InlineFlowTestMake<JavaDataFlow, JavaTaintTracking, Impl, FlowTestImpl>
