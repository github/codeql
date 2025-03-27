private import Raw
import Location
private import Scope

class Ast extends @ast {
  final string toString() { none() }

  final Ast getParent() { result.getAChild() = this }

  Ast getChild(ChildIndex i) { none() }

  final Ast getAChild() { result = this.getChild(_) }

  Location getLocation() { none() }

  Scope getScope() { result = scopeOf(this) }
}
