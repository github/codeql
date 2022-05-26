private import codeql.swift.generated.expr.Expr

class Expr extends ExprBase {
  final override Expr getResolveStep() { this.convertsFrom(result) }

  predicate convertsFrom(Expr e) { none() } // overridden by subclasses

  Expr getConversion() { result.convertsFrom(this) }

  predicate isConversion() { this.convertsFrom(_) }

  predicate hasConversions() { exists(this.getConversion()) }

  Expr getFullyConverted() { result = this.getFullyUnresolved() }

  Expr getUnconverted() { result = this.resolve() }
}
