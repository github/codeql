private import codeql.swift.generated.decl.AccessorDecl

class AccessorDecl extends AccessorDeclBase {
  predicate isPropertyObserver() {
    this instanceof WillSetObserver or this instanceof DidSetObserver
  }
}

class WillSetObserver extends AccessorDecl {
  WillSetObserver() { this.isWillSet() }
}

class DidSetObserver extends AccessorDecl {
  DidSetObserver() { this.isDidSet() }
}
