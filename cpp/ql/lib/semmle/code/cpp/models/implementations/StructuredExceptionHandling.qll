import semmle.code.cpp.models.interfaces.Throwing

/**
 * The default behavior for Structured Exception Handling (SEH) is
 * any function may (conditionally) raise an exception.
 * NOTE: this can be overridden by for any specific function to make in
 * unconditional or non-throwing. IR generation will enforce
 * the most strict interpretation.
 */
class DefaultSehExceptionBehavior extends ThrowingFunction {
  DefaultSehExceptionBehavior() { any() }

  override predicate raisesException(boolean unconditional) { unconditional = false }

  override TSehException getExceptionType() { any() }
}

class WindowsDriverExceptionAnnotation extends ThrowingFunction {
  WindowsDriverExceptionAnnotation() {
    this.hasGlobalName(["RaiseException", "ExRaiseAccessViolation", "ExRaiseDatatypeMisalignment"])
  }

  override predicate raisesException(boolean unconditional) { unconditional = true }

  override TSehException getExceptionType() { any() }
}
