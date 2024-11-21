import semmle.code.cpp.models.interfaces.NonThrowing

/**
 * A function that is annotated with a `noexcept` specifier (or the equivalent
 * `throw()` specifier) guaranteeing that the function can not throw exceptions.
 *
 * Note: The `throw` specifier was deprecated in C++11 and removed in C++17.
 */
class NoexceptFunction extends NonCppThrowingFunction {
  NoexceptFunction() { this.isNoExcept() or this.isNoThrow() }
}
