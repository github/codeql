private import AstImport

class Ast extends TAst {
  string toString() { none() }

  final Ast getParent() { result.getChild(_) = this }

  Location getLocation() {
    result = getRawAst(this).getLocation()
    or
    result = any(Synthesis s).getLocation(this)
  }

  Ast getChild(ChildIndex i) {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, i, result)
      or
      exists(string name |
        i = RealVar(name) and
        result = TVariableReal(r, name, _)
      )
    )
  }

  final Ast getAChild() { result = this.getChild(_) }

  Scope getEnclosingScope() { result = scopeOf(this) } // TODO: Scope of synth?

  Function getEnclosingFunction() {
    exists(Scope scope | scope = scopeOf(this) |
      result.getBody() = scope
      or
      not scope instanceof ScriptBlock and
      result = scope.getEnclosingFunction()
    )
  }
}
