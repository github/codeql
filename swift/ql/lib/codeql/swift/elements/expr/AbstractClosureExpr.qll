private import codeql.swift.generated.expr.AbstractClosureExpr
private import codeql.swift.elements.decl.ParamDecl

class AbstractClosureExpr extends AbstractClosureExprBase, ValueParametrizedNode {
  override ParamDecl getParam(int index) { result = AbstractClosureExprBase.super.getParam(index) }

  override ParamDecl getAParam() { result = AbstractClosureExprBase.super.getAParam() }

  override int getNumberOfParams() { result = AbstractClosureExprBase.super.getNumberOfParams() }
}
