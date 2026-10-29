private import unified
private import codeql.unified.internal.Builtins
private import codeql.unified.internal.mad.LegacyMaD as LegacyMaD

query predicate isSource = Models::isSource/2;

query predicate isSink = Models::isSink/2;

/**
 * Holds if `type` is mentioned in a model, but has no representative in the builtins.
 *
 * Declarations from dependencies are not extracted, so such types would not be resolved
 * by type inference outside of tests.
 */
query predicate missingBuiltinType(string type) {
  type = any(LegacyMaD::Selector s).getTypeString() and
  type != "" and
  not type = any(BuiltinClassLikeDeclaration decl).getQualifiedName()
}
