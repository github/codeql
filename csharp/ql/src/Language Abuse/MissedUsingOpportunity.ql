/**
 * @name Missed 'using' opportunity
 * @description C# provides a 'using' statement as a better alternative to manual resource disposal in a finally block - it makes sense to use it.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/missed-using-statement
 * @tags maintainability
 *       language-features
 */

import csharp
import semmle.code.csharp.frameworks.System

/** A call to IDisposable.Dispose or a method that overrides it. */
class DisposeCall extends MethodCall {
  DisposeCall() { getTarget() instanceof DisposeMethod }

  /** The object being disposed by the call (provided it can be easily determined). */
  Variable getDisposee() {
    exists(VariableAccess va |
      va = getQualifier().stripCasts() and
      result = va.getTarget()
    )
  }
}

from Variable v, DisposeCall c, TryStmt ts
where
  v = c.getDisposee() and
  c = ts.getFinally().getAChild*()
select v,
  "This variable is manually $@ in a $@ - consider a C# using statement as a preferable resource management technique.",
  c, "disposed", ts.getFinally(), "finally block"
