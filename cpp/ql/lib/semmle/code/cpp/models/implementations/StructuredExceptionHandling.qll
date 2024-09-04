import semmle.code.cpp.models.interfaces.Throwing

class WindowsDriverFunction extends ThrowingFunction {
  WindowsDriverFunction() {
    this.hasGlobalName(["RaiseException", "ExRaiseAccessViolation", "ExRaiseDatatypeMisalignment"])
  }

  final override predicate mayThrowException(boolean unconditional) { unconditional = true }
}

/**
 * Calls to functions in a try statement with no body
 * are assumed to potentially (not unconditionally) throw anything.
 */
class UndefinedFunction extends ThrowingFunction {
  UndefinedFunction() {
    exists(Stmt t, Call c |
      (t instanceof TryStmt or t instanceof MicrosoftTryStmt) and
      t.getChild(0).(Stmt).getAChild*() = c and
      this = c.getTarget() and
      not this.hasDefinition() and
      // Ideally do not mark any function as an UndefinedFunction if it is
      // already defined as a throwing function, especially if it is
      // already defined as unconditionaly throwing. This leads to
      // non-monotonic recursion, so this is a workaround.
      not this instanceof WindowsDriverFunction
    )
  }

  final override predicate mayThrowException(boolean unconditional) { unconditional = false }
}
