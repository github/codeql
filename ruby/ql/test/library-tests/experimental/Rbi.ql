private import codeql.ruby.AST
private import codeql.ruby.experimental.Rbi::Rbi

query predicate rbiTypes(RbiType t) { any() }

query predicate unionTypes(RbiUnionType t, RbiType u) { u = t.getAType() }

query predicate nilableTypes(RbiNilableType t, RbiType u) { u = t.getUnderlyingType() }

query predicate typeAliases(RbiTypeAlias a, RbiType t) { t = a.getAliasedType() }

query predicate arrayTypes(RbiArrayType at, RbiType et) { et = at.getElementType() }

query predicate hashTypes(RbiHashType ht, RbiType kt, RbiType vt) {
  kt = ht.getKeyType() and vt = ht.getValueType()
}

query predicate signatureCalls(SignatureCall c, ReturnType r) {
  r = c.getReturnsTypeCall().getReturnType()
}

query predicate paramsCalls(ParamsCall c) { any() }

query predicate returnsCall(ReturnsCall c, ReturnType r) { r = c.getReturnType() }

query predicate voidCall(VoidCall c) { any() }

query predicate parameterTypes(ParameterType pt, NamedParameter p, RbiType t) {
  p = pt.getParameter() and t = pt.getType()
}

query predicate procParameterTypes(
  ParameterType pt, ProcReturnsTypeCall prtc, ProcCall pc, string isNilable
) {
  (
    exists(RbiNilableType nilable | nilable = pt.getType() |
      prtc = nilable.getUnderlyingType() and
      isNilable = "nilable"
    )
    or
    pt.getType() = prtc and isNilable = "non_nilable"
  ) and
  pc = prtc.getProcCall()
}

query predicate sigMethods(MethodSignatureCall sig, MethodBase m) { m = sig.getAssociatedMethod() }

query predicate sigAttrReaders(MethodSignatureCall sig, MethodCall attr_reader) {
  attr_reader = sig.getAssociatedAttrReaderCall()
}
