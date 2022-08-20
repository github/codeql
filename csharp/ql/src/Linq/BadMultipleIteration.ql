/**
 * @name Bad multiple iteration
 * @description Not every enumerable sequence is repeatable, so it is dangerous to write code that can consume elements of a sequence in more than one place.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/linq/inconsistent-enumeration
 * @tags reliability
 *       maintainability
 *       language-features
 *       external/cwe/cwe-834
 */

import csharp
import Linq.Helpers

/** The enumerable sequence is likely not to be repeatable. */
predicate likelyNonRepeatableSequence(IEnumerableSequence seq) {
  // The source of the sequence is one of:
  exists(Expr src | src = sequenceSource(seq) |
    // A call to a method that both returns an IEnumerable and calls ReadLine.
    exists(MethodCall mc |
      mc = src and
      isIEnumerableType(mc.getTarget().getReturnType()) and
      exists(MethodCall readlineCall |
        readlineCall.getTarget().hasName("ReadLine") and
        readlineCall.getEnclosingCallable() = mc.getTarget()
      )
    )
    or
    // A call to Select(...) that instantiates new objects.
    exists(SelectCall sc |
      sc = src and
      sc.getFunctionExpr().getExpressionBody() instanceof ObjectCreation
    )
  )
}

/** An access to an enumerable sequence that potentially consumes sequence elements. */
predicate potentiallyConsumingAccess(VariableAccess va) {
  exists(ForeachStmt fes | va = fes.getIterableExpr())
  or
  exists(MethodCall mc |
    va = mc.getArgument(0) and
    mc.getTarget() instanceof ExtensionMethod
  )
}

/** The source of an enumerable sequence (an expression used to initialise it, or the right-hand side of an assignment to it). */
Expr sequenceSource(IEnumerableSequence seq) {
  result = seq.getInitializer()
  or
  exists(Assignment a | a.getLValue() = seq.getAnAccess() and result = a.getRValue())
}

from IEnumerableSequence seq, VariableAccess va
where
  likelyNonRepeatableSequence(seq) and
  va = seq.getAnAccess() and
  potentiallyConsumingAccess(va) and
  count(VariableAccess x | x = seq.getAnAccess() and potentiallyConsumingAccess(x)) > 1
select seq,
  "This enumerable sequence may not be repeatable, but is potentially consumed multiple times $@.",
  va, "here"
