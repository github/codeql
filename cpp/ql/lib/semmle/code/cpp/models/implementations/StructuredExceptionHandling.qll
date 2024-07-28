import semmle.code.cpp.models.interfaces.Throwing

class WindowsDriverFunction extends ThrowingFunction {
  WindowsDriverFunction() {
    this.hasGlobalName(["RaiseException", "ExRaiseAccessViolation", "ExRaiseDatatypeMisalignment"])
  }

  final override predicate mayThrowException(boolean unconditional) { unconditional = true }
}
