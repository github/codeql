import swift

predicate isKnownKind(AccessorDecl decl, string kind) {
  decl.isGetter() and kind = "get"
  or
  decl.isSetter() and kind = "set"
  or
  decl.isDidSet() and kind = "didSet"
  or
  decl.isWillSet() and kind = "willSet"
}

from AccessorDecl decl, string kind
where
  decl.getLocation().getFile().getName().matches("%swift/ql/test%") and
  (
    isKnownKind(decl, kind)
    or
    not isKnownKind(decl, _) and kind = "?"
  )
select decl, kind
