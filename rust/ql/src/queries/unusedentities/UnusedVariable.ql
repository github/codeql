/**
 * @name Unused variable
 * @description Unused variables may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id rust/unused-variable
 * @tags maintainability
 */

import rust
import UnusedVariable

/**
 * A callable for which we have incomplete information, for example because an unexpanded
 * macro call is present. These callables are prone to false positive results from unused
 * entities queries, unless they are excluded from results.
 */
class IncompleteCallable extends Callable {
  IncompleteCallable() {
    exists(MacroExpr me |
      me.getEnclosingCallable() = this and
      not me.getMacroCall().hasExpanded()
    )
  }
}

from Variable v
where
  isUnused(v) and
  not isAllowableUnused(v) and
  not v instanceof DiscardVariable and
  not v.getEnclosingCfgScope() instanceof IncompleteCallable
select v, "Variable '" + v + "' is not used."
