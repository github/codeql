/**
 * Provides an abstract class for modeling functions and expressions that
 * allocate memory, such as the standard `malloc` function.  To use this QL
 * library, create one or more QL classes extending a class here with a
 * characteristic predicate that selects the functions or expressions you are
 * trying to model. Within that class, override the predicates provided
 * by the abstract class to match the specifics of those functions or
 * expressions. Finally, add a private import statement to `Models.qll`.
 */

import semmle.code.cpp.Function
import semmle.code.cpp.models.Models

/**
 * An allocation expression such as call to `malloc` or a `new` expression.
 */
abstract class AllocationExpr extends Expr {
  /**
   * Gets an expression for the allocation size, if any. The actual allocation
   * size is the value of this expression multiplied by the result of
   * `getSizeMult()`, in bytes.
   */
  Expr getSizeExpr() { none() }

  /**
   * Gets a constant multiplier for the allocation size given by `getSizeExpr`,
   * in bytes.
   */
  int getSizeMult() { none() }

  /**
   * Gets the size of this allocation in bytes, if it is a fixed size and that
   * size can be determined.
   */
  int getSizeBytes() { none() }

  /**
   * Gets the expression for the input pointer argument to be reallocated, if
   * this is a `realloc` function.
   */
  Expr getReallocPtr() { none() }

  /**
   * Gets the type of the elements that are allocated, if it can be determined.
   */
  Type getAllocatedElementType() { none() }

  /**
   * Whether or not this allocation requires a corresponding deallocation of
   * some sort (most do, but `alloca` for example does not).  If it is unclear,
   * we default to no (for example a placement `new` allocation may or may not
   * require a corresponding `delete`).
   */
  predicate requiresDealloc() { any() }
}

/**
 * An allocation function such as `malloc`.
 *
 * Note: `AllocationExpr` includes calls to allocation functions, so prefer
 * to use that class unless you specifically need to reason about functions.
 */
abstract class AllocationFunction extends Function {
  /**
   * Gets the index of the argument for the allocation size, if any. The actual
   * allocation size is the value of this argument multiplied by the result of
   * `getSizeMult()`, in bytes.
   */
  int getSizeArg() { none() }

  /**
   * Gets the index of an argument that multiplies the allocation size given by
   * `getSizeArg`, if any.
   */
  int getSizeMult() { none() }

  /**
   * Gets the index of the input pointer argument to be reallocated, if this
   * is a `realloc` function.
   */
  int getReallocPtrArg() { none() }

  /**
   * Whether or not this allocation requires a corresponding deallocation of
   * some sort (most do, but `alloca` for example does not).  If it is unclear,
   * we default to no (for example a placement `new` allocation may or may not
   * require a corresponding `delete`).
   */
  predicate requiresDealloc() { any() }
}

/**
 * Holds if an external allocation model exists for the given parameters.
 */
extensible predicate allocationFunctionModel(
  string namespace, string type, boolean subtypes, string name, string sizeArg, string multArg,
  string reallocPtrArg, boolean requiresDealloc
);

/**
 * An `operator new` or `operator new[]` function that may be associated with
 * `new` or `new[]` expressions.  Note that `new` and `new[]` are not function
 * calls, but these functions may also be called directly.
 */
class OperatorNewAllocationFunction extends AllocationFunction {
  OperatorNewAllocationFunction() {
    this.hasGlobalName([
        "operator new", // operator new(bytes, ...)
        "operator new[]" // operator new[](bytes, ...)
      ])
  }

  override int getSizeArg() { result = 0 }

  override predicate requiresDealloc() { not exists(this.getPlacementArgument()) }

  /**
   * Gets the position of the placement pointer if this is a placement
   * `operator new` function.
   */
  int getPlacementArgument() {
    this.getNumberOfParameters() = 2 and
    this.getParameter(1).getType() instanceof VoidPointerType and
    result = 1
  }
}

/**
 * An expression that _might_ allocate memory.
 *
 * Unlike `AllocationExpr`, this class uses heuristics (such as a call target's
 * name and parameters) to include additional expressions.
 */
abstract class HeuristicAllocationExpr extends Expr {
  /**
   * Gets an expression for the allocation size, if any. The actual allocation
   * size is the value of this expression multiplied by the result of
   * `getSizeMult()`, in bytes.
   */
  Expr getSizeExpr() { none() }

  /**
   * Gets a constant multiplier for the allocation size given by `getSizeExpr`,
   * in bytes. This predicate should be used with caution as it can be
   * inaccurate for allocations identified using heuristics.
   */
  int getSizeMult() { none() }

  /**
   * Gets the size of this allocation in bytes, if it is a fixed size and that
   * size can be determined. This predicate should be used with caution as it
   * can be inaccurate for allocations identified using heuristics.
   */
  int getSizeBytes() { none() }

  /**
   * Gets the expression for the input pointer argument to be reallocated, if
   * this is a `realloc` function.
   */
  Expr getReallocPtr() { none() }

  /**
   * Gets the type of the elements that are allocated, if it can be determined.
   */
  Type getAllocatedElementType() { none() }

  /**
   * Whether or not this allocation requires a corresponding deallocation of
   * some sort (most do, but `alloca` for example does not).  If it is unclear,
   * we default to no (for example a placement `new` allocation may or may not
   * require a corresponding `delete`).
   */
  predicate requiresDealloc() { any() }
}

/**
 * An function that _might_ allocate memory.
 *
 * Unlike `AllocationFunction`, this class uses heuristics (such as the function's
 * name and its parameters) to include additional functions.
 */
abstract class HeuristicAllocationFunction extends Function {
  /**
   * Gets the index of the argument for the allocation size, if any. The actual
   * allocation size is the value of this argument multiplied by the result of
   * `getSizeMult()`, in bytes.
   */
  int getSizeArg() { none() }

  /**
   * Gets the index of an argument that multiplies the allocation size given by
   * `getSizeArg`, if any.
   */
  int getSizeMult() { none() }

  /**
   * Gets the index of the input pointer argument to be reallocated, if this
   * is a `realloc` function.
   */
  int getReallocPtrArg() { none() }

  /**
   * Whether or not this allocation requires a corresponding deallocation of
   * some sort (most do, but `alloca` for example does not).  If it is unclear,
   * we default to no (for example a placement `new` allocation may or may not
   * require a corresponding `delete`).
   */
  predicate requiresDealloc() { any() }
}
