/**
 * Provides an abstract class for modeling functions and expressions that
 * deallocate memory, such as the standard `free` function.  To use this QL
 * library, create one or more QL classes extending a class here with a
 * characteristic predicate that selects the functions or expressions you are
 * trying to model. Within that class, override the predicates provided
 * by the abstract class to match the specifics of those functions or
 * expressions. Finally, add a private import statement to `Models.qll`.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models

/**
 * An deallocation expression such as call to `free` or a `delete` expression.
 */
abstract class DeallocationExpr extends Expr {
  /**
   * Gets the expression that is freed by this function.
   */
  Expr getFreedExpr() { none() }
}

/**
 * A deallocation function such as `free`.
 *
 * Note: `DeallocationExpr` includes calls to deallocation functions, so prefer
 * to use that class unless you specifically need to reason about functions.
 */
abstract class DeallocationFunction extends Function {
  /**
   * Gets the index of the argument that is freed by this function.
   */
  int getFreedArg() { none() }
}

/**
 * Holds if an external deallocation model exists for the given parameters.
 */
extensible predicate deallocationFunctionModel(
  string namespace, string type, boolean subtypes, string name, string freedArg
);

/**
 * An `operator delete` or `operator delete[]` function that may be associated
 * with `delete` or `delete[]` expressions.  Note that `delete` and `delete[]`
 * are not function calls, but these functions may also be called directly.
 */
class OperatorDeleteDeallocationFunction extends DeallocationFunction {
  OperatorDeleteDeallocationFunction() {
    this.hasGlobalName([
        "operator delete", // operator delete(pointer, ...)
        "operator delete[]" // operator delete[](pointer, ...)
      ])
  }

  override int getFreedArg() { result = 0 }
}
