private import codeql.swift.generated.decl.AccessorDecl

private predicate isKnownAccessorKind(AccessorDecl decl, string kind) {
  decl.isGetter() and kind = "get"
  or
  decl.isSetter() and kind = "set"
  or
  decl.isWillSet() and kind = "willSet"
  or
  decl.isDidSet() and kind = "didSet"
}

class AccessorDecl extends AccessorDeclBase {
  predicate isPropertyObserver() {
    this instanceof WillSetObserver or this instanceof DidSetObserver
  }

  override string toString() {
    isKnownAccessorKind(this, result)
    or
    not isKnownAccessorKind(this, _) and
    result = super.toString()
  }
}

class WillSetObserver extends AccessorDecl {
  WillSetObserver() { this.isWillSet() }
}

class DidSetObserver extends AccessorDecl {
  DidSetObserver() { this.isDidSet() }
}
