import semmle.code.cpp.models.interfaces.Throwing

class WindowsDriverExceptionAnnotation extends AlwaysSehThrowingFunction {
  WindowsDriverExceptionAnnotation() {
    this.hasGlobalName(["RaiseException", "ExRaiseAccessViolation", "ExRaiseDatatypeMisalignment"])
  }
}
