import csharp

query predicate memberAccess(MemberAccess ma, Expr qualifier, string conditional) {
  qualifier = ma.getQualifier() and
  if ma.isConditional() then conditional = "Conditional" else conditional = "Unconditional"
}

query predicate methodCall(MethodCall mc, Expr qualifier, string conditional) {
  qualifier = mc.getQualifier() and
  if mc.isConditional() then conditional = "Conditional" else conditional = "Unconditional"
}

query predicate extensionMethodCall(ExtensionMethodCall mc, Expr qualifier, string conditional) {
  qualifier = mc.getArgument(0) and
  if mc.isConditional() then conditional = "Conditional" else conditional = "Unconditional"
}
