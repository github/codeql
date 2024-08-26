/**
 * Provides an abstract class for modeling functions that never throws.
 *
 * See also `ThrowingFunction` for modeling functions that do throw.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models

/**
 * A function that is guaranteed to never throw.
 */
abstract class NonThrowingFunction extends Function { }
