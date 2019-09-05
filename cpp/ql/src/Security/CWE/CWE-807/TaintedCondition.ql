/**
 * @name Untrusted input for a condition
 * @description Using untrusted inputs in a statement that makes a
 *              security decision makes code vulnerable to
 *              attack.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/tainted-permissions-check
 * @tags security
 *       external/cwe/cwe-807
 */

import semmle.code.cpp.security.TaintTracking

/**
 * Holds if there is an 'if' statement whose condition `condition`
 * is influenced by tainted data `source`, and the body contains
 * `raise` which escalates privilege.
 */
predicate cwe807violation(Expr source, Expr condition, Expr raise) {
  tainted(source, condition) and
  raisesPrivilege(raise) and
  exists(IfStmt ifstmt |
    ifstmt.getCondition() = condition and
    raise.getEnclosingStmt().getParentStmt*() = ifstmt
  )
}

from Expr source, Expr condition, Expr raise
where cwe807violation(source, condition, raise)
select condition, "Reliance on untrusted input $@ to raise privilege at $@", source,
  source.toString(), raise, raise.toString()
