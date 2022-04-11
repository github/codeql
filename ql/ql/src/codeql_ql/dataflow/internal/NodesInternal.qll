private import codeql_ql.ast.Ast

newtype TNode =
  MkAstNodeNode(AstNode node) {
    node instanceof Expr or
    node instanceof VarDef
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
