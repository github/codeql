/**
 * Provides an abstract class for accurate dataflow modeling of library
 * functions when source code is not available.  To use this QL library,
 * create a QL class extending `SideEffectFunction` with a characteristic
 * predicate that selects the function or set of functions you are modeling.
 * Within that class, override the predicates provided by `SideEffectFunction`
 * to match the flow within that function.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models
import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

/**
 * Models the side effects of a library function.
 */
abstract class SideEffectFunction extends Function {
  /**
   * Holds if the function never reads from memory that was defined before entry to the function.
   * This memory could be from global variables, or from other memory that was reachable from a
   * pointer that was passed into the function. Input side-effects, and reads from memory that
   * cannot be visible to the caller (for example a buffer inside an I/O library) are not modeled
   * here.
   */
  abstract predicate hasOnlySpecificReadSideEffects();

  /**
   * Holds if the function never writes to memory that remains allocated after the function
   * returns. This memory could be from global variables, or from other memory that was reachable
   * from a pointer that was passed into the function. Output side-effects, and writes to memory
   * that cannot be visible to the caller (for example a buffer inside an I/O library) are not
   * modeled here.
   */
  abstract predicate hasOnlySpecificWriteSideEffects();

  /**
   * Holds if the value pointed to by the parameter at index `i` is written to. `buffer` is true
   * if the write may be at an offset. `mustWrite` is true if the write is unconditional.
   */
  predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  /**
   * Holds if the value pointed to by the parameter at index `i` is read from. `buffer` is true
   * if the read may be at an offset.
   */
  predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) { none() }

  /**
   * Gets the index of the parameter that indicates the size of the buffer pointed to by the
   * parameter at index `i`.
   */
  ParameterIndex getParameterSizeIndex(ParameterIndex i) { none() }
}
