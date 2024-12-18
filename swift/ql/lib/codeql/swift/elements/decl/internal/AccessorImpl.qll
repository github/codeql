private import codeql.swift.generated.decl.Accessor
private import codeql.swift.elements.decl.SetObserver

module Impl {
  private predicate isKnownAccessorKind(Accessor decl, string kind) {
    decl.isGetter() and kind = "get"
    or
    decl.isSetter() and kind = "set"
    or
    decl.isWillSet() and kind = "willSet"
    or
    decl.isDidSet() and kind = "didSet"
    or
    decl.isRead() and kind = "_read"
    or
    decl.isModify() and kind = "_modify"
    or
    decl.isUnsafeAddress() and kind = "unsafeAddress"
    or
    decl.isUnsafeMutableAddress() and kind = "unsafeMutableAddress"
  }

  class Accessor extends Generated::Accessor {
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
}
