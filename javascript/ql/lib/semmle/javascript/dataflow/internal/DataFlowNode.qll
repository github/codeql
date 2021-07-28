/**
 * INTERNAL: Do not use outside the data flow library.
 *
 * Contains the raw data type underlying `DataFlow::Node`.
 */

private import javascript

/**
 * The raw data type underlying `DataFlow::Node`.
 */
cached
newtype TNode =
  TValueNode(AST::ValueNode nd) or
  TSsaDefNode(SsaDefinition d) or
  TCapturedVariableNode(LocalVariable v) { v.isCaptured() } or
  TPropNode(@property p) or
  TRestPatternNode(DestructuringPattern dp, Expr rest) { rest = dp.getRest() } or
  TElementPatternNode(ArrayPattern ap, Expr p) { p = ap.getElement(_) } or
  TElementNode(ArrayExpr arr, Expr e) { e = arr.getAnElement() } or
  TReflectiveCallNode(MethodCallExpr ce, string kind) {
    ce.getMethodName() = kind and
    (kind = "call" or kind = "apply")
  } or
  TThisNode(StmtContainer f) { f.(Function).getThisBinder() = f or f instanceof TopLevel } or
  TDestructuredModuleImportNode(ImportDeclaration decl) {
    exists(decl.getASpecifier().getImportedName())
  } or
  THtmlAttributeNode(HTML::Attribute attr) or
  TFunctionReturnNode(Function f) or
  TExceptionalFunctionReturnNode(Function f) or
  TExceptionalInvocationReturnNode(InvokeExpr e) or
  TGlobalAccessPathRoot()
