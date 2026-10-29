private import codeql_ql.ast.Ast
private import VarScoping

newtype TNode =
  MkAstNodeNode(AstNode node) {
    node instanceof Expr or
    node instanceof VarDef
  } or
  MkScopedVariable(VarDef var, AstNode scope) {
    isRefinement(var, _, scope) and
    not scope = getVarDefScope(var)
  } or
  MkThisNode(Predicate pred) {
    pred instanceof ClassPredicate or
    pred instanceof CharPred or
    pred instanceof NewTypeBranch
  } or
  MkResultNode(Predicate pred) { exists(pred.getReturnTypeExpr()) } or
  MkFieldNode(Predicate pred, FieldDecl fieldDecl) {
    // TODO: should this be omitted when the field is not referenced?
    fieldDecl.getVarDecl() = pred.(ClassPredicate).getDeclaringType().getField(_)
    or
    fieldDecl.getVarDecl() = pred.(CharPred).getDeclaringType().getField(_)
  }
