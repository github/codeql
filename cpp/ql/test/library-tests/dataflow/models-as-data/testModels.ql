import semmle.code.cpp.ir.dataflow.internal.DataFlowImplConsistency::Consistency
import semmle.code.cpp.ir.dataflow.internal.DataFlowNodes
import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
import semmle.code.cpp.security.FlowSources
import utils.test.dataflow.FlowTestCommon

module InterpretElementTest implements TestSig {
  string getARelevantTag() { result = "interpretElement" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Element e |
      e = interpretElement(_, _, _, _, _, _) and
      location = e.getLocation() and
      element = e.toString() and
      tag = "interpretElement" and
      value = ""
    )
  }
}

query predicate summaryCalls(SummaryCall c) { any() }

query predicate summarizedCallables(SummarizedCallable c) { any() }

query predicate sourceCallables(SourceCallable c) { c.getLocation().getFile().toString() != "" }

module IRTest {
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.ir.dataflow.TaintTracking

  /** Common data flow configuration to be used by tests. */
  module TestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source instanceof FlowSource
      or
      source.asExpr().(FunctionCall).getTarget().getName() =
        ["source", "source2", "source3", "sourcePtr"]
      or
      source.asIndirectExpr(1).(FunctionCall).getTarget().getName() = "sourceIndirect"
    }

    predicate isSink(DataFlow::Node sink) {
      sinkNode(sink, "test-sink")
      or
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument()
      )
    }
  }

  module IRFlow = TaintTracking::Global<TestAllocationConfig>;
}

import MakeTest<MergeTests<IRFlowTest<IRTest::IRFlow>, InterpretElementTest>>

string describe(DataFlow::Node n) {
  n instanceof ParameterNode and result = "ParameterNode"
  or
  n instanceof PostUpdateNode and result = "PostUpdateNode"
  or
  n instanceof ArgumentNode and result = "ArgumentNode"
  or
  n instanceof ReturnNode and result = "ReturnNode"
  or
  n instanceof OutNode and result = "OutNode"
}

query predicate flowSummaryNode(FlowSummaryNode n, string str1, string str2, string str3) {
  str1 = concat(describe(n), ", ") and
  str2 = concat(n.getSummarizedCallable().toString(), ", ") and
  str3 = concat(n.getEnclosingCallable().toString(), ", ")
}
