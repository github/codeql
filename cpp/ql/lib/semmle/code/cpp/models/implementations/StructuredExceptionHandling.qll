import semmle.code.cpp.models.interfaces.Throwing

/**
 * The default behavior for Structured Exception Handling (SEH) is 
 * any function may (conditionally) raise an exception.
 * NOTE: this can be overriden by for any specific function to make in
 * unconditional or non-throwing. IR generation will enforce
 * the most strict interpretation.
 */
class DefaultSEHExceptionBehavior extends ThrowingFunction {
  DefaultSEHExceptionBehavior() { this = any(Function f) }

  override predicate raisesException(boolean unconditional) { unconditional = false }

  override TSEHException getExceptionType() { any() }
}

class WindowsDriverExceptionAnnotation extends ThrowingFunction {
  WindowsDriverExceptionAnnotation() {
    this.hasGlobalName(["RaiseException", "ExRaiseAccessViolation", "ExRaiseDatatypeMisalignment"])
  }

  override predicate raisesException(boolean unconditional) { unconditional = true }

  override TSEHException getExceptionType() { any() }
}
