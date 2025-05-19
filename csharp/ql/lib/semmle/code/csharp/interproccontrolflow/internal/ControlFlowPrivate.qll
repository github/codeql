private import csharp as CS
private import ControlFlowPublic

predicate edge(Node n1, Node n2) { n1.getASuccessor() = n2 }

predicate callTarget(CallNode call, Callable target) { call.getARuntimeTarget() = target }

predicate flowEntry(Callable c, Node entry) {
  entry.(CS::ControlFlow::Nodes::EntryNode).getCallable() = c
}

predicate flowExit(Callable c, Node exitNode) {
  exitNode.(CS::ControlFlow::Nodes::ExitNode).getCallable() = c
}

Callable getEnclosingCallable(Node n) { n.getEnclosingCallable() = result }

predicate hiddenNode(Node n) { none() }

private newtype TSplit = TNone() { none() }

class Split extends TSplit {
  abstract string toString();

  abstract CS::Location getLocation();

  abstract predicate entry(Node n1, Node n2);

  abstract predicate exit(Node n1, Node n2);

  abstract predicate blocked(Node n1, Node n2);
}
