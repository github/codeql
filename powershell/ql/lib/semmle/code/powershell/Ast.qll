import powershell

class Ast extends @ast {
  string toString() { none() }

  Ast getParent() { parent(this, result) }

  Location getLocation() { none() }
}
