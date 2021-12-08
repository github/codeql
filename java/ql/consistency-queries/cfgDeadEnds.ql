import java
import semmle.code.java.ControlFlowGraph

predicate shouldBeDeadEnd(ControlFlowNode n) {
  n instanceof BreakStmt and n.getFile().isKotlinSourceFile() or // TODO
  n instanceof ReturnStmt and n.getFile().isKotlinSourceFile() or // TODO
  n instanceof Interface or // TODO
  n instanceof Class or // TODO
  n instanceof Parameter or // TODO
  n instanceof Field or // TODO
  n instanceof Annotation or // TODO
  n instanceof TypeAccess or // TODO
  n instanceof ArrayTypeAccess or // TODO
  n instanceof UnionTypeAccess or // TODO
  n instanceof IntersectionTypeAccess or // TODO
  n instanceof ArrayAccess or // TODO
  n instanceof AddExpr or // TODO
  n instanceof MinusExpr or // TODO
  n instanceof LocalVariableDecl or // TODO
  n instanceof FieldDeclaration or // TODO
  n instanceof ArrayInit or // TODO
  n instanceof VarAccess or // TODO
  n instanceof Literal or // TODO
  n instanceof TypeLiteral or // TODO
  n instanceof TypeVariable or // TODO
  n instanceof WildcardTypeAccess or // TODO
  n instanceof MethodAccess or // TODO
  n instanceof Method or
  n instanceof Constructor or
  not exists(n.getFile().getRelativePath()) or // TODO
  n = any(ConstCase c).getValue(_) // TODO
}

from ControlFlowNode n, string s
where // TODO: exists(n.getASuccessor()) and shouldBeDeadEnd(n) and s = "expected dead end"
      not exists(n.getASuccessor()) and not shouldBeDeadEnd(n) and s = "unexpected dead end"
select n, n.getPrimaryQlClasses(), s

