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

module SideEffectModel {
  /**
   * Models the side effects of a library function.
   */
  abstract class SideEffectFunction extends Function {
    /**
     * Holds if the function may read from memory that was defined before entry to the function. This
     * memory could be from global variables, or from other memory that was reachable from a pointer
     * that was passed into the function.
     */
    abstract predicate readsMemory();

    /**
     * Holds if the function may write to memory that remains allocated after the function returns.
     * This memory could be from global variables, or from other memory that was reachable from a
     * pointer that was passed into the function.
     */
    abstract predicate writesMemory();
  }

  /**
    * Holds if the function `f` may read from memory that was defined before entry to the function.
    * This memory could be from global variables, or from other memory that was reachable from a
    * pointer that was passed into the function.
    */
  predicate functionReadsMemory(Function f) {
    not exists(SideEffectFunction sideEffect |
      sideEffect = f and not sideEffect.readsMemory()
    )
  }

  /**
  * Holds if the function `f` may write to memory that remains allocated after the function returns.
  * This memory could be from global variables, or from other memory that was reachable from a
  * pointer that was passed into the function.
  */
  predicate functionWritesMemory(Function f) {
    not exists(SideEffectFunction sideEffect |
      sideEffect = f and not sideEffect.writesMemory()
    )
  }
}
