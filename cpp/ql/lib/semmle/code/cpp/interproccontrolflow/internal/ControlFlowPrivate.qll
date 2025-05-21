private import semmle.code.cpp.ir.IR
private import cpp as Cpp
private import ControlFlowPublic
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon

predicate edge(Node n1, Node n2) { n1.asInstruction().getASuccessor() = n2.asInstruction() }

predicate callTarget(CallNode call, Callable target) {
  exists(DataFlowPrivate::DataFlowCall dfCall | dfCall.asCallInstruction() = call.asInstruction() |
    DataFlowImplCommon::viableCallableCached(dfCall).asSourceCallable() = target
    or
    DataFlowImplCommon::viableCallableLambda(dfCall, _).asSourceCallable() = target
  )
}

predicate flowEntry(Callable c, Node entry) {
  entry.asInstruction().(EnterFunctionInstruction).getEnclosingFunction() = c
}

predicate flowExit(Callable c, Node exitNode) {
  exitNode.asInstruction().(ExitFunctionInstruction).getEnclosingFunction() = c
}

Callable getEnclosingCallable(Node n) { n.getEnclosingFunction() = result }

predicate hiddenNode(Node n) { n.asInstruction() instanceof PhiInstruction }

private newtype TSplit = TNone() { none() }

class Split extends TSplit {
  abstract string toString();

  abstract Cpp::Location getLocation();

  abstract predicate entry(Node n1, Node n2);

  abstract predicate exit(Node n1, Node n2);

  abstract predicate blocked(Node n1, Node n2);
}
