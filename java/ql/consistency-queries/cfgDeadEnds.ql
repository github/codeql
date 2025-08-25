import java

predicate shouldBeDeadEnd(ExprParent n) {
  n instanceof BreakStmt and n.getFile().isKotlinSourceFile() // TODO
  or
  n instanceof Interface // TODO
  or
  n instanceof Class // TODO
  or
  n instanceof Parameter // TODO
  or
  n instanceof Field // TODO
  or
  n instanceof Annotation // TODO
  or
  n instanceof TypeAccess // TODO
  or
  n instanceof ArrayTypeAccess // TODO
  or
  n instanceof UnionTypeAccess // TODO
  or
  n instanceof IntersectionTypeAccess // TODO
  or
  n instanceof ArrayAccess // TODO
  or
  n instanceof AddExpr // TODO
  or
  n instanceof MinusExpr // TODO
  or
  n instanceof LocalVariableDecl // TODO
  or
  n instanceof FieldDeclaration // TODO
  or
  n instanceof ArrayInit // TODO
  or
  n instanceof VarAccess // TODO
  or
  n instanceof Literal // TODO
  or
  n instanceof TypeLiteral // TODO
  or
  n instanceof TypeVariable // TODO
  or
  n instanceof WildcardTypeAccess // TODO
  or
  n instanceof MethodCall // TODO
  or
  n instanceof Method
  or
  n instanceof Constructor
  or
  not exists(n.getFile().getRelativePath()) // TODO
  or
  n = any(ConstCase c).getValue(_) // TODO
}

from ControlFlowNode n, ExprParent astnode, string s
where
  astnode = n.getAstNode() and
  // TODO: exists(n.getASuccessor()) and shouldBeDeadEnd(n.getAstNode()) and s = "expected dead end"
  not exists(n.getASuccessor()) and
  not shouldBeDeadEnd(astnode) and
  s = "unexpected dead end"
select n, astnode.getPrimaryQlClasses(), s
