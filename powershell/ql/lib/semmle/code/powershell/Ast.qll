import powershell

class Ast extends @ast {
  string toString() { none() }

  Ast getParent() { parent(this, result) } // TODO: Flip parent and child in relation in the extractor

  Location getLocation() { none() }
}
