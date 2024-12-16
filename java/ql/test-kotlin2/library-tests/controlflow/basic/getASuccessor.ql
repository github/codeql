import java

newtype TMaybeControlFlowNode =
  TControlFlowNode(ControlFlowNode c) or
  TNoControlFlowNode()

class MaybeControlFlowNode extends TMaybeControlFlowNode {
  abstract string toString();

  abstract Location getLocation();

  abstract string getPrimaryQlClasses();
}

class YesMaybeControlFlowNode extends MaybeControlFlowNode {
  ControlFlowNode c;

  YesMaybeControlFlowNode() { this = TControlFlowNode(c) }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }

  override string getPrimaryQlClasses() { result = c.getAstNode().getPrimaryQlClasses() }
}

class NoMaybeControlFlowNode extends MaybeControlFlowNode {
  NoMaybeControlFlowNode() { this = TNoControlFlowNode() }

  override string toString() { result = "<none>" }

  override Location getLocation() { result.toString() = "file://:0:0:0:0" }

  override string getPrimaryQlClasses() { result = "<none>" }
}

MaybeControlFlowNode maybeSuccessor(ControlFlowNode n) {
  if exists(n.getASuccessor())
  then result = TControlFlowNode(n.getASuccessor())
  else result = TNoControlFlowNode()
}

from ControlFlowNode n, MaybeControlFlowNode m
where
  m = maybeSuccessor(n) and
  n.getLocation().getFile().(CompilationUnit).fromSource()
select n, n.getAstNode().getPrimaryQlClasses(), m, m.getPrimaryQlClasses()

query predicate missingSuccessor(Expr n) {
  maybeSuccessor(n.getControlFlowNode()) instanceof NoMaybeControlFlowNode and
  n.getFile().(CompilationUnit).fromSource() and
  not n instanceof TypeAccess and
  not n instanceof VarWrite
}
