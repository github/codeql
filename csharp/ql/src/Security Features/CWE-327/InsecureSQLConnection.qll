import csharp

/**
 * Holds if `ObjectCreation` has an initializer for a member named `Encrypt`, set to `e`
 */
predicate getInfoForInitializedConnEncryption(ObjectCreation oc, Expr e) {
  exists(MemberInitializer mi | mi.getInitializedMember().hasName("Encrypt") |
    e = mi.getRValue() and
    oc.getInitializer().(ObjectInitializer).getAMemberInitializer() = mi
  )
}
