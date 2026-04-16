/**
 * Provides an abstract class for modeling functions that never throw.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models

/**
 * A function that is guaranteed to never throw a C++ exception
 *
 * The function may still raise a structured exception handling (SEH) exception.
 */
abstract class NonCppThrowingFunction extends Function { }
