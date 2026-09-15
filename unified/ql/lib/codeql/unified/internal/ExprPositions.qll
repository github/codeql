private import unified
private import NameBinding as NameBinding

/**
 * Holds if `expr` appears in the context of a type annotation.
 */
predicate isInTypeContext(Expr expr) {
  expr = any(TypeCastExpr n).getType()
  or
  expr = any(TypeTestExpr n).getType()
  or
  expr = any(VariableDeclaration n).getType()
  or
  expr = any(FunctionDeclaration n).getReturnType()
  or
  expr = any(FunctionExpr n).getReturnType()
  or
  expr = any(AccessorDeclaration n).getType()
  or
  expr = any(Parameter n).getType()
  or
  expr = any(TypeAliasDeclaration n).getType()
  or
  expr = any(BaseType n).getType()
  or
  expr = any(TypeParameter n).getBound()
  or
  expr = any(AssociatedTypeDeclaration n).getBound()
  or
  expr.getParent() instanceof TypeConstraint
  or
  isInTypeContext(expr.getEnclosingExpr())
}

/** Holds if `e` appears in a name-binding position inside `declaration` */
predicate isInBindingContext(Expr e, AstNode declaration) {
  NameBinding::bindingContext(e, _, declaration)
}

/** Holds if `e` is part of the target of `assignment`. */
predicate isInAssignmentContext(Expr e, AstNode assignment) {
  e = assignment.(AssignExpr).getTarget()
  or
  e = assignment.(CompoundAssignExpr).getTarget()
  or
  exists(TupleExpr tuple |
    isInAssignmentContext(tuple, assignment) and
    e = tuple.getAnElement().getValue()
  )
}

/**
 * Holds if `e` receives an incoming value because it is part of a binding pattern
 * or assignment target.
 */
predicate hasIncomingValue(Expr e, AstNode declarationOrAssignment) {
  isInBindingContext(e, declarationOrAssignment)
  or
  isInAssignmentContext(e, declarationOrAssignment)
}

/**
 * Holds if `e` evaluates to a result.
 */
predicate hasResultValue(Expr e) {
  not isInTypeContext(e) and
  not isInBindingContext(e, _) and
  not isInAssignmentContext(e, any(AssignExpr n)) and // non-compound assignment target
  not e instanceof IdentifierLabel
}
