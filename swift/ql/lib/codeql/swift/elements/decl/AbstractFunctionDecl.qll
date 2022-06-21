private import codeql.swift.generated.decl.AbstractFunctionDecl
private import codeql.swift.elements.decl.ParamDecl

class AbstractFunctionDecl extends AbstractFunctionDeclBase, ValueParametrizedNode {
  override string toString() { result = this.getName() }

  override ParamDecl getParam(int index) { result = AbstractFunctionDeclBase.super.getParam(index) }

  override ParamDecl getAParam() { result = AbstractFunctionDeclBase.super.getAParam() }

  override int getNumberOfParams() { result = AbstractFunctionDeclBase.super.getNumberOfParams() }
}
