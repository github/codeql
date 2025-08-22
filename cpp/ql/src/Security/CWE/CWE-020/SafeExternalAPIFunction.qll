/**
 * Provides a class for modeling external functions that are "safe" from a security perspective.
 */

private import cpp
private import semmle.code.cpp.models.interfaces.SideEffect

/**
 * A `Function` that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalApiFunction extends Function { }

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalApiFunction extends SafeExternalApiFunction {
  DefaultSafeExternalApiFunction() {
    // If a function does not write to any of its arguments, we consider it safe to
    // pass untrusted data to it. This means that string functions such as `strcmp`
    // and `strlen`, as well as memory functions such as `memcmp`, are considered safe.
    exists(SideEffectFunction model | model = this |
      model.hasOnlySpecificWriteSideEffects() and
      not model.hasSpecificWriteSideEffect(_, _, _)
    )
  }
}
