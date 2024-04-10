import testModels
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil

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

from FlowSummaryNode n
select n, concat(describe(n), ", "), concat(n.getSummarizedCallable().toString(), ", "),
  concat(n.getEnclosingCallable().toString(), ", ")
