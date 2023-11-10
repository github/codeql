/**
 * Provides utility predicates for range analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import RangeAnalysisRelativeSpecific
private import codeql.rangeanalysis.RangeAnalysis
private import RangeAnalysisImpl
private import ConstantAnalysis

module RangeUtil<DeltaSig D, LangSig<Sem, D> Lang> implements UtilSig<Sem, D> {
  /**
   * Gets the type used to track the specified expression's range information.
   *
   * Usually, this just `e.getSemType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  SemType getTrackedType(SemExpr e) { result = e.getSemType() }

  /**
   * Gets the type used to track the specified source variable's range information.
   *
   * Usually, this just `e.getType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  SemType getTrackedTypeForSsaVariable(SemSsaVariable var) { result = var.getType() }
}
