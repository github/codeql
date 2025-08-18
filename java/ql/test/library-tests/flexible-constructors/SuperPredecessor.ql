import java

from ControlFlowNode pred, ControlFlowNode supNode, SuperConstructorInvocationStmt sc
where
  supNode.asStmt() = sc and
  pred.getASuccessor() = supNode and
  pred != supNode and
  not pred.asStmt() instanceof BlockStmt and
  exists(sc.getEnclosingCallable().getFile().getRelativePath()) and
  sc.getLocation().getEndColumn() > sc.getLocation().getStartColumn()
select pred, sc, "predecessor of explicit super()"
