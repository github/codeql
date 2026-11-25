private import unified
private import codeql.unified.internal.mad.LegacyMaD

query predicate isSource = Models::isSource/2;

query predicate isSink = Models::isSink/2;

query predicate constructor(CallExpr call, string type) {
  call = any(TypeSelector selector | type = selector).getAConstructorCall()
}
