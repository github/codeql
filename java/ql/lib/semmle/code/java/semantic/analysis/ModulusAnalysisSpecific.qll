module Private {
  private import java as J
  private import semmle.code.java.semantic.SemanticExpr
  private import semmle.code.java.semantic.SemanticExprSpecific

  /**
   * Workaround to preserve the original Java results by ignoring the modulus of
   * certain expressions.
   */
  predicate ignoreExprModulus(SemExpr e) { getJavaExpr(e) instanceof J::LocalVariableDeclExpr }
}
