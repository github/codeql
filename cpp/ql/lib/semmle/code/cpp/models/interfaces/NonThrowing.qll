/**
 * Provides an abstract class for modeling functions that never throw.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models

/**
 * A function that is guaranteed to never throw.
 *
 * DEPRECATED: use `NonThrowingFunction` in `semmle.code.cpp.models.Models.Interfaces.Throwing` instead.
 */
abstract deprecated class NonThrowingFunction extends Function { }
