/**
 * @name Data-Dependent Control Flow
 * @description Detects control flow decisions that depend on external/untrusted data.
 *              These can be security-sensitive if not properly validated.
 * @kind problem
 * @problem.severity note
 * @id php/data-dependent-control-flow
 * @tags security
 *       data-flow
 */

import php
import codeql.php.EnhancedControlFlow
private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A conditional that depends on a superglobal variable.
 */
predicate usesSuperglobal(TS::PHP::AstNode condition) {
  exists(TS::PHP::VariableName v |
    v.getParent*() = condition and
    exists(string name | name = v.getChild().(TS::PHP::Name).getValue() |
      name in ["$_GET", "$_POST", "$_REQUEST", "$_COOKIE", "$_SERVER", "$_FILES", "$_SESSION"]
    )
  )
}

from ConditionalChain cond
where usesSuperglobal(cond.getCondition())
select cond.getCondition(),
       "Control flow depends on external data (superglobal). Ensure proper validation/sanitization of the condition."
