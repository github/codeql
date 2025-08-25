private import codeql.swift.generated.expr.Expr

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for all expressions in Swift.
   */
  class Expr extends Generated::Expr {
    final override Expr getResolveStep() { this.convertsFrom(result) }

    predicate convertsFrom(Expr e) { none() } // overridden by subclasses

    Expr getConversion() { result.convertsFrom(this) }

    Expr getConversion(int n) {
      n = 0 and result = this.getConversion()
      or
      result = this.getConversion(n - 1).getConversion()
    }

    predicate isConversion() { this.convertsFrom(_) }

    predicate hasConversions() { exists(this.getConversion()) }

    Expr getFullyConverted() { result = this.getFullyUnresolved() }

    Expr getUnconverted() { result = this.resolve() }
  }
}
