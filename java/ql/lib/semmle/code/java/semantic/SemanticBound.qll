/**
 * Semantic wrapper around the shared bounds library.
 */

private import semmle.code.java.dataflow.Bound
private import SemanticExpr
private import SemanticSSA

private newtype TSemBound = MkSemBound(Bound bound)

class LanguageBound = Bound;

class SemBound extends TSemBound {
  LanguageBound bound;

  SemBound() { this = MkSemBound(bound) }

  final string toString() { result = bound.toString() }

  final SemExpr getExpr(int delta) { result = getSemanticExpr(bound.getExpr(delta)) }
}

class SemZeroBound extends SemBound {
  override ZeroBound bound;
}

class SemSsaBound extends SemBound {
  override SsaBound bound;

  final SemSsaVariable getSsa() { result = getSemanticSsaVariable(bound.getSsa()) }
}

SemBound getSemanticBound(LanguageBound bound) { result = MkSemBound(bound) }

LanguageBound getLanguageBound(SemBound bound) { bound = getSemanticBound(result) }
