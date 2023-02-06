import swift

from Expr e, string semantics
where
  e.getLocation().getFile().getName().matches("%swift/ql/test%") and
  (
    exists(DeclRefExpr ref | ref = e |
      ref.hasDirectToImplementationSemantics() and semantics = "DirectToImplementation"
      or
      ref.hasDirectToStorageSemantics() and semantics = "DirectToStorage"
      or
      ref.hasOrdinarySemantics() and semantics = "OrdinarySemantics"
    )
    or
    exists(SubscriptExpr sub | sub = e |
      sub.hasDirectToImplementationSemantics() and semantics = "DirectToImplementation"
      or
      sub.hasDirectToStorageSemantics() and semantics = "DirectToStorage"
      or
      sub.hasOrdinarySemantics() and semantics = "OrdinarySemantics"
    )
    or
    exists(MemberRefExpr memberRef | memberRef = e |
      memberRef.hasDirectToImplementationSemantics() and semantics = "DirectToImplementation"
      or
      memberRef.hasDirectToStorageSemantics() and semantics = "DirectToStorage"
      or
      memberRef.hasOrdinarySemantics() and semantics = "OrdinarySemantics"
    )
  )
select e, semantics
