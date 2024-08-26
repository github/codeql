import powershell

class Ast extends @ast {
  string toString() { none() }

  Ast getParent() { parent(result, this) }

  Location getLocation() { none() }
}
