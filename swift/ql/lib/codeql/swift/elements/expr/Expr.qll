private import codeql.swift.generated.expr.Expr

class Expr extends ExprBase {
  final override Expr getResolveStep() { convertsFrom(result) }

  predicate convertsFrom(Expr e) { none() } // overridden by subclasses

  Expr getConversion() { result.convertsFrom(this) }

  predicate isConversion() { convertsFrom(_) }

  predicate hasConversions() { exists(getConversion()) }

  Expr getFullyConverted() { result = this.getFullyUnresolved() }

  Expr getUnconverted() { result = this.resolve() }
}
