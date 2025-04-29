private import AstImport

class Method extends Member, FunctionBase, TMethod {
  final override string getLowerCaseName() { result = Member.super.getLowerCaseName() }

  final override ScriptBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, methodBody(), result)
      or
      not synthChild(r, methodBody(), _) and
      result = getResultAst(r.(Raw::Method).getBody())
    )
  }

  final override Parameter getParameter(int i) { result = this.getBody().getParameter(i) }

  final override Location getLocation() { result = getRawAst(this).(Raw::Method).getLocation() }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = methodBody() and result = this.getBody()
  }

  predicate isConstructor() { getRawAst(this).(Raw::Method).isConstructor() }

  ThisParameter getThisParameter() { result.getFunction() = this }
}

/** A constructor definition. */
class Constructor extends Method {
  Constructor() { this.isConstructor() }
}
