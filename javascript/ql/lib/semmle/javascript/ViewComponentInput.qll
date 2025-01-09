/**
 * Provides a classes and predicates for contributing to the `view-component-input` threat model.
 */

private import javascript

/**
 * An input to a view component, such as React props.
 */
abstract class ViewComponentInput extends DataFlow::Node {
  /** Gets a string that describes the type of this threat-model source. */
  abstract string getSourceType();
}

private class ViewComponentInputAsThreatModelSource extends ThreatModelSource::Range instanceof ViewComponentInput
{
  ViewComponentInputAsThreatModelSource() { not isSafeType(this.asExpr().getType()) }

  final override string getThreatModel() { result = "view-component-input" }

  final override string getSourceType() { result = ViewComponentInput.super.getSourceType() }
}

private predicate isSafeType(Type t) {
  t instanceof NumberLikeType
  or
  t instanceof BooleanLikeType
  or
  t instanceof UndefinedType
  or
  t instanceof NullType
  or
  t instanceof VoidType
  or
  hasSafeTypes(t, t.(UnionType).getNumElementType())
  or
  isSafeType(t.(IntersectionType).getAnElementType())
}

/** Hold if the first `n` components of `t` are safe types. */
private predicate hasSafeTypes(UnionType t, int n) {
  isSafeType(t.getElementType(0)) and
  n = 1
  or
  isSafeType(t.getElementType(n - 1)) and
  hasSafeTypes(t, n - 1)
}
