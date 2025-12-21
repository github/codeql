import codeql.php.ast.Calls
import codeql.php.ast.internal.TreeSitter
import codeql.php.security.Sources

/** Very small, syntax-based taint predicate for the MVP. */
module PhpSecurityTaint {
  private predicate isTaintedVarName(string name) {
    exists(Php::AssignmentExpression a, Php::VariableName v |
      a.getLeft() = v and
      v.getChild().getValue() = name and
      isTainted(a.getRight())
    )
    or
    exists(Php::ReferenceAssignmentExpression a, Php::VariableName v |
      a.getLeft() = v and
      v.getChild().getValue() = name and
      isTainted(a.getRight())
    )
  }

  /** Holds if `e` is considered tainted.
   *
   * MVP:
   * - direct use of a superglobal
   * - or a variable that is assigned from a tainted expression
   * - or an expression containing a tainted sub-expression
   */
  predicate isTainted(Php::Expression e) {
    PhpSecuritySources::isUntrustedSourceExpr(e)
    or
    exists(Php::VariableName v |
      v = e and
      isTaintedVarName(v.getChild().getValue())
    )
    or
    exists(Php::Expression child | child = e.getAFieldOrChild() and isTainted(child))
  }

  /** Holds if any argument expression of `call` is tainted. */
  predicate hasTaintedArgument(Call call) {
    exists(Php::Expression arg | arg = call.getAnArgumentExpr() and isTainted(arg))
  }
}
