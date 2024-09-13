import powershell
private import semmle.code.powershell.controlflow.internal.Scope

class Ast extends @ast {
  string toString() { none() }

  Ast getParent() { parent(this, result) }

  Location getLocation() { none() }

  final Scope getEnclosingScope() { result = scopeOf(this) }
}
