/**
 * Provides implementation classes modeling various methods of allocation
 * (`malloc`, `new` etc). See `semmle.code.cpp.models.interfaces.Allocation`
 * for usage information.
 */

import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.Taint

/**
 * An allocation function (such as `realloc`) that has an argument for the size
 * in bytes, and an argument for an existing pointer that is to be reallocated.
 */
private class ReallocAllocationFunction extends AllocationFunction, TaintFunction {
  int sizeArg;
  int reallocArg;

  ReallocAllocationFunction() {
    // --- C library allocation
    this.hasGlobalOrStdOrBslName("realloc") and // realloc(ptr, size)
    sizeArg = 1 and
    reallocArg = 0
    or
    this.hasGlobalName([
        // --- Windows Global / Local legacy allocation
        "LocalReAlloc", // LocalReAlloc(ptr, size, flags)
        "GlobalReAlloc", // GlobalReAlloc(ptr, size, flags)
        // --- Windows COM allocation
        "CoTaskMemRealloc", // CoTaskMemRealloc(ptr, size)
        // --- OpenSSL memory allocation
        "CRYPTO_realloc", // CRYPTO_realloc(void *addr, size_t num, const char *file, int line)
        "g_realloc", // g_realloc(mem, n_bytes);
        "g_try_realloc" // g_try_realloc(mem, n_bytes);
      ]) and
    sizeArg = 1 and
    reallocArg = 0
    or
    this.hasGlobalName("HeapReAlloc") and // HeapReAlloc(heap, flags, ptr, size)
    sizeArg = 3 and
    reallocArg = 2
  }

  override int getSizeArg() { result = sizeArg }

  override int getReallocPtrArg() { result = reallocArg }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(this.getReallocPtrArg()) and output.isReturnValueDeref()
  }
}

/**
 * A miscellaneous allocation function that has no explicit argument for
 * the size of the allocation.
 */
private class SizelessAllocationFunction extends AllocationFunction {
  SizelessAllocationFunction() {
    this.hasGlobalName([
        // --- Windows Memory Management for Windows Drivers
        "ExAllocateFromLookasideListEx", // ExAllocateFromLookasideListEx(list)
        "ExAllocateFromPagedLookasideList", // ExAllocateFromPagedLookasideList(list)
        "ExAllocateFromNPagedLookasideList", // ExAllocateFromNPagedLookasideList(list)
        "ExAllocateTimer", // ExAllocateTimer(callback, context, attributes)
        "IoAllocateWorkItem", // IoAllocateWorkItem(object)
        "MmMapLockedPagesWithReservedMapping", // MmMapLockedPagesWithReservedMapping(address, tag, list, type)
        "MmMapLockedPages", // MmMapLockedPages(list, mode)
        "MmMapLockedPagesSpecifyCache", // MmMapLockedPagesSpecifyCache(list, mode, type, address, flag, flag)
        // --- NetBSD pool manager
        "pool_get", // pool_get(pool, flags)
        "pool_cache_get" // pool_cache_get(pool, flags)
      ])
  }
}

/**
 * Holds if `sizeExpr` is an expression consisting of a subexpression
 * `lengthExpr` multiplied by a constant `sizeof` that is the result of a
 * `sizeof()` expression.  Alternatively if there isn't a suitable `sizeof()`
 * expression, `lengthExpr = sizeExpr` and `sizeof = 1`.  For example:
 * ```
 * malloc(a * 2 * sizeof(char32_t));
 * ```
 * In this case if the `sizeExpr` is the argument to `malloc`, the `lengthExpr`
 * is `a * 2` and `sizeof` is `4`.
 */
private predicate deconstructSizeExpr(Expr sizeExpr, Expr lengthExpr, int sizeof) {
  exists(SizeofOperator sizeofOp |
    sizeofOp = sizeExpr.(MulExpr).getAnOperand() and
    lengthExpr = sizeExpr.(MulExpr).getAnOperand() and
    not lengthExpr instanceof SizeofOperator and
    sizeof = sizeofOp.getValue().toInt()
  )
  or
  not exists(SizeofOperator sizeofOp, Expr lengthOp |
    sizeofOp = sizeExpr.(MulExpr).getAnOperand() and
    lengthOp = sizeExpr.(MulExpr).getAnOperand() and
    not lengthOp instanceof SizeofOperator and
    exists(sizeofOp.getValue().toInt())
  ) and
  lengthExpr = sizeExpr and
  sizeof = 1
}

/** A `Function` that is a call target of an allocation. */
private signature class CallAllocationExprTarget extends Function {
  /**
   * Gets the index of the input pointer argument to be reallocated, if
   * this is a `realloc` function.
   */
  int getReallocPtrArg();

  /**
   * Gets the index of the argument for the allocation size, if any. The actual
   * allocation size is the value of this argument multiplied by the result of
   * `getSizeMult()`, in bytes.
   */
  int getSizeArg();

  /**
   * Gets the index of an argument that multiplies the allocation size given
   * by `getSizeArg`, if any.
   */
  int getSizeMult();

  /**
   * Holds if this allocation requires a
   * corresponding deallocation of some sort (most do, but `alloca` for example
   * does not). If it is unclear, we default to no (for example a placement `new`
   * allocation may or may not require a corresponding `delete`).
   */
  predicate requiresDealloc();
}

/**
 * This module abstracts over the type of allocation call-targets and provides a
 * class `CallAllocationExprImpl` which contains the implementation of the various
 * predicates required by the `Allocation` class.
 *
 * This module is then instantiated for two types of allocation call-targets:
 * - `AllocationFunction`: Functions that we've explicitly modeled as functions that
 * perform allocations (i.e., `malloc`).
 * - `HeuristicAllocationFunction`: Functions that we deduce as behaving like an allocation
 * function using various heuristics.
 */
private module CallAllocationExprBase<CallAllocationExprTarget Target> {
  /**
   * An allocation expression that is a function call, such as call to `malloc`.
   */
  class CallAllocationExprImpl instanceof FunctionCall {
    Target target;

    CallAllocationExprImpl() {
      target = this.getTarget() and
      // realloc(ptr, 0) only frees the pointer
      not (
        exists(target.getReallocPtrArg()) and
        this.getArgument(target.getSizeArg()).getValue().toInt() = 0
      ) and
      // these are modeled directly (and more accurately), avoid duplication
      not exists(NewOrNewArrayExpr new | new.getAllocatorCall() = this)
    }

    string toString() { result = super.toString() }

    Expr getSizeExprImpl() {
      exists(Expr sizeExpr | sizeExpr = super.getArgument(target.getSizeArg()) |
        if exists(target.getSizeMult())
        then result = sizeExpr
        else
          exists(Expr lengthExpr |
            deconstructSizeExpr(sizeExpr, lengthExpr, _) and
            result = lengthExpr
          )
      )
    }

    int getSizeMultImpl() {
      // malloc with multiplier argument that is a constant
      result = super.getArgument(target.getSizeMult()).getValue().toInt()
      or
      // malloc with no multiplier argument
      not exists(target.getSizeMult()) and
      deconstructSizeExpr(super.getArgument(target.getSizeArg()), _, result)
    }

    int getSizeBytesImpl() {
      result = this.getSizeExprImpl().getValue().toInt() * this.getSizeMultImpl()
    }

    Expr getReallocPtrImpl() { result = super.getArgument(target.getReallocPtrArg()) }

    Type getAllocatedElementTypeImpl() {
      result =
        super.getFullyConverted().getType().stripTopLevelSpecifiers().(PointerType).getBaseType() and
      not result instanceof VoidType
    }

    predicate requiresDeallocImpl() { target.requiresDealloc() }
  }
}

private module CallAllocationExpr {
  /**
   * A class that provides the implementation of `AllocationExpr` for an allocation
   * that calls an `AllocationFunction`.
   */
  private class Base = CallAllocationExprBase<AllocationFunction>::CallAllocationExprImpl;

  class CallAllocationExpr extends AllocationExpr, Base {
    override Expr getSizeExpr() { result = super.getSizeExprImpl() }

    override int getSizeMult() { result = super.getSizeMultImpl() }

    override Type getAllocatedElementType() { result = super.getAllocatedElementTypeImpl() }

    override predicate requiresDealloc() { super.requiresDeallocImpl() }

    override int getSizeBytes() { result = super.getSizeBytesImpl() }

    override Expr getReallocPtr() { result = super.getReallocPtrImpl() }

    override string toString() { result = AllocationExpr.super.toString() }
  }
}

/**
 * An allocation expression that is a `new` expression.
 */
private class NewAllocationExpr extends AllocationExpr, NewExpr {
  NewAllocationExpr() { this instanceof NewExpr }

  override int getSizeBytes() { result = this.getAllocatedType().getSize() }

  override Type getAllocatedElementType() { result = this.getAllocatedType() }

  override predicate requiresDealloc() { not exists(this.getPlacementPointer()) }
}

/**
 * An allocation expression that is a `new []` expression.
 */
private class NewArrayAllocationExpr extends AllocationExpr, NewArrayExpr {
  NewArrayAllocationExpr() { this instanceof NewArrayExpr }

  override Expr getSizeExpr() {
    // new array expr with variable size
    result = this.getExtent()
  }

  override int getSizeMult() {
    // new array expr with variable size
    exists(this.getExtent()) and
    result = this.getAllocatedElementType().getSize()
  }

  override Type getAllocatedElementType() { result = NewArrayExpr.super.getAllocatedElementType() }

  override int getSizeBytes() { result = this.getAllocatedType().getSize() }

  override predicate requiresDealloc() { not exists(this.getPlacementPointer()) }
}

/**
 * Holds if `f` is an allocation function according to the
 * extensible `allocationFunctionModel` predicate.
 */
private predicate isAllocationFunctionFromModel(
  Function f, string namespace, string type, string name
) {
  exists(boolean subtypes | allocationFunctionModel(namespace, type, subtypes, name, _, _, _, _) |
    if type = ""
    then f.hasQualifiedName(namespace, "", name)
    else
      exists(Class c |
        c.hasQualifiedName(namespace, type) and f.hasQualifiedName(namespace, _, name)
      |
        if subtypes = true
        then f = c.getADerivedClass*().getAMemberFunction()
        else f = c.getAMemberFunction()
      )
  )
}

/**
 * An allocation function modeled via the extensible `allocationFunctionModel` predicate.
 */
private class AllocationFunctionFromModel extends AllocationFunction {
  string namespace;
  string type;
  string name;

  AllocationFunctionFromModel() { isAllocationFunctionFromModel(this, namespace, type, name) }

  final override int getSizeArg() {
    exists(string sizeArg |
      allocationFunctionModel(namespace, type, _, name, sizeArg, _, _, _) and
      result = sizeArg.toInt()
    )
  }

  final override int getSizeMult() {
    exists(string sizeMult |
      allocationFunctionModel(namespace, type, _, name, _, sizeMult, _, _) and
      result = sizeMult.toInt()
    )
  }

  final override int getReallocPtrArg() {
    exists(string reallocPtrArg |
      allocationFunctionModel(namespace, type, _, name, _, _, reallocPtrArg, _) and
      result = reallocPtrArg.toInt()
    )
  }

  final override predicate requiresDealloc() {
    allocationFunctionModel(namespace, type, _, name, _, _, _, true)
  }
}

private module HeuristicAllocation {
  /** A class that maps an `AllocationExpr` to an `HeuristicAllocationExpr`. */
  private class HeuristicAllocationModeled extends HeuristicAllocationExpr instanceof AllocationExpr
  {
    override Expr getSizeExpr() { result = AllocationExpr.super.getSizeExpr() }

    override int getSizeMult() { result = AllocationExpr.super.getSizeMult() }

    override int getSizeBytes() { result = AllocationExpr.super.getSizeBytes() }

    override Expr getReallocPtr() { result = AllocationExpr.super.getReallocPtr() }

    override Type getAllocatedElementType() {
      result = AllocationExpr.super.getAllocatedElementType()
    }

    override predicate requiresDealloc() { AllocationExpr.super.requiresDealloc() }
  }

  /** A class that maps an `AllocationFunction` to an `HeuristicAllocationFunction`. */
  private class HeuristicAllocationFunctionModeled extends HeuristicAllocationFunction instanceof AllocationFunction
  {
    override int getSizeArg() { result = AllocationFunction.super.getSizeArg() }

    override int getSizeMult() { result = AllocationFunction.super.getSizeMult() }

    override int getReallocPtrArg() { result = AllocationFunction.super.getReallocPtrArg() }

    override predicate requiresDealloc() { AllocationFunction.super.requiresDealloc() }
  }

  private int getAnUnsignedParameter(Function f) {
    f.getParameter(result).getUnspecifiedType().(IntegralType).isUnsigned()
  }

  private int getAPointerParameter(Function f) {
    f.getParameter(result).getUnspecifiedType() instanceof PointerType
  }

  /**
   * A class that uses heuristics to find additional allocation functions. The required are as follows:
   * 1. The word `alloc` must appear in the function name
   * 2. The function must return a pointer type
   * 3. There must be a unique parameter of unsigned integral type.
   */
  private class HeuristicAllocationFunctionByName extends HeuristicAllocationFunction instanceof Function
  {
    int sizeArg;

    HeuristicAllocationFunctionByName() {
      Function.super.getName().matches(["%alloc%", "%Alloc%"]) and
      Function.super.getUnspecifiedType() instanceof PointerType and
      sizeArg = unique( | | getAnUnsignedParameter(this))
    }

    override int getSizeArg() { result = sizeArg }

    override int getReallocPtrArg() {
      Function.super.getName().matches("%realloc%") and
      result = unique( | | getAPointerParameter(this))
    }

    override predicate requiresDealloc() { none() }
  }

  /**
   * A class that provides the implementation of `AllocationExpr` for an allocation
   * that calls an `HeuristicAllocationFunction`.
   */
  private class Base = CallAllocationExprBase<HeuristicAllocationFunction>::CallAllocationExprImpl;

  private class CallAllocationExpr extends HeuristicAllocationExpr, Base {
    override Expr getSizeExpr() { result = super.getSizeExprImpl() }

    override int getSizeMult() { result = super.getSizeMultImpl() }

    override Type getAllocatedElementType() { result = super.getAllocatedElementTypeImpl() }

    override predicate requiresDealloc() { super.requiresDeallocImpl() }

    override int getSizeBytes() { result = super.getSizeBytesImpl() }

    override Expr getReallocPtr() { result = super.getReallocPtrImpl() }

    override string toString() { result = HeuristicAllocationExpr.super.toString() }
  }
}
