/**
 * Provides implementation classes modeling various methods of allocation
 * (`malloc`, `new` etc). See `semmle.code.cpp.models.interfaces.Allocation`
 * for usage information.
 */

import semmle.code.cpp.models.interfaces.Allocation

/**
 * An allocation function (such as `malloc`) that has an argument for the size
 * in bytes.
 */
class MallocAllocationFunction extends AllocationFunction {
  int sizeArg;

  MallocAllocationFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      // malloc(size)
      (name = "malloc" and sizeArg = 0)
      or
      hasGlobalName(name) and
      (
        // ExAllocatePool(type, size)
        name = "ExAllocatePool" and sizeArg = 1
        or
        // ExAllocatePool(type, size, tag)
        name = "ExAllocatePoolWithTag" and sizeArg = 1
        or
        // ExAllocatePoolWithTagPriority(type, size, tag, priority)
        name = "ExAllocatePoolWithTagPriority" and sizeArg = 1
        or
        // ExAllocatePoolWithQuota(type, size)
        name = "ExAllocatePoolWithQuota" and sizeArg = 1
        or
        // ExAllocatePoolWithQuotaTag(type, size, tag)
        name = "ExAllocatePoolWithQuotaTag" and sizeArg = 1
        or
        // IoAllocateMdl(address, size, flag, flag, irp)
        name = "IoAllocateMdl" and sizeArg = 1
        or
        // IoAllocateErrorLogEntry(object, size)
        name = "IoAllocateErrorLogEntry" and sizeArg = 1
        or
        // MmAllocateContiguousMemory(size, maxaddress)
        name = "MmAllocateContiguousMemory" and sizeArg = 0
        or
        // MmAllocateContiguousNodeMemory(size, minaddress, maxaddress, bound, flag, prefer)
        name = "MmAllocateContiguousNodeMemory" and sizeArg = 0
        or
        // MmAllocateContiguousMemorySpecifyCache(size, minaddress, maxaddress, bound, type)
        name = "MmAllocateContiguousMemorySpecifyCache" and sizeArg = 0
        or
        // MmAllocateContiguousMemorySpecifyCacheNode(size, minaddress, maxaddress, bound, type, prefer)
        name = "MmAllocateContiguousMemorySpecifyCacheNode" and sizeArg = 0
        or
        // MmAllocateNonCachedMemory(size)
        name = "MmAllocateNonCachedMemory" and sizeArg = 0
        or
        // MmAllocateMappingAddress(size, tag)
        name = "MmAllocateMappingAddress" and sizeArg = 0
        or
        // MmAllocatePagesForMdl(minaddress, maxaddress, skip, size)
        name = "MmAllocatePagesForMdl" and sizeArg = 3
        or
        // MmAllocatePagesForMdlEx(minaddress, maxaddress, skip, size, type, flags)
        name = "MmAllocatePagesForMdlEx" and sizeArg = 3
        or
        // MmAllocateNodePagesForMdlEx(minaddress, maxaddress, skip, size, type, prefer, flags)
        name = "MmAllocateNodePagesForMdlEx" and sizeArg = 3
        or
        // LocalAlloc(flags, size)
        name = "LocalAlloc" and sizeArg = 1
        or
        // GlobalAlloc(flags, size)
        name = "GlobalAlloc" and sizeArg = 1
        or
        // HeapAlloc(heap, flags, size)
        name = "HeapAlloc" and sizeArg = 2
        or
        // VirtualAlloc(address, size, type, flag)
        name = "VirtualAlloc" and sizeArg = 1
        or
        // CoTaskMemAlloc(size)
        name = "CoTaskMemAlloc" and sizeArg = 0
        or
        // kmem_alloc(size, flags)
        name = "kmem_alloc" and sizeArg = 0
        or
        // kmem_zalloc(size, flags)
        name = "kmem_zalloc" and sizeArg = 0
        or
        // CRYPTO_malloc(size_t num, const char *file, int line)
        name = "CRYPTO_malloc" and sizeArg = 0
        or
        // CRYPTO_zalloc(size_t num, const char *file, int line)
        name = "CRYPTO_zalloc" and sizeArg = 0
        or
        // CRYPTO_secure_malloc(size_t num, const char *file, int line)
        name = "CRYPTO_secure_malloc" and sizeArg = 0
        or
        // CRYPTO_secure_zalloc(size_t num, const char *file, int line)
        name = "CRYPTO_secure_zalloc" and sizeArg = 0
      )
    )
  }

  override int getSizeArg() { result = sizeArg }
}

/**
 * An allocation function (such as `alloca`) that does not require a
 * corresponding free (and has an argument for the size in bytes).
 */
class AllocaAllocationFunction extends AllocationFunction {
  int sizeArg;

  AllocaAllocationFunction() {
    exists(string name |
      hasGlobalName(name) and
      (
        // alloca(size)
        name = "alloca" and sizeArg = 0
        or
        // __builtin_alloca(size)
        name = "__builtin_alloca" and sizeArg = 0
      )
    )
  }

  override int getSizeArg() { result = sizeArg }

  override predicate requiresDealloc() { none() }
}

/**
 * An allocation function (such as `calloc`) that has an argument for the size
 * and another argument for the size of those units (in bytes).
 */
class CallocAllocationFunction extends AllocationFunction {
  int sizeArg;
  int multArg;

  CallocAllocationFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      // calloc(num, size)
      (name = "calloc" and sizeArg = 1 and multArg = 0)
    )
  }

  override int getSizeArg() { result = sizeArg }

  override int getSizeMult() { result = multArg }
}

/**
 * An allocation function (such as `realloc`) that has an argument for the size
 * in bytes, and an argument for an existing pointer that is to be reallocated.
 */
class ReallocAllocationFunction extends AllocationFunction {
  int sizeArg;
  int reallocArg;

  ReallocAllocationFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      // realloc(ptr, size)
      (name = "realloc" and sizeArg = 1 and reallocArg = 0)
      or
      hasGlobalName(name) and
      (
        // LocalReAlloc(ptr, size, flags)
        name = "LocalReAlloc" and sizeArg = 1 and reallocArg = 0
        or
        // GlobalReAlloc(ptr, size, flags)
        name = "GlobalReAlloc" and sizeArg = 1 and reallocArg = 0
        or
        // HeapReAlloc(heap, flags, ptr, size)
        name = "HeapReAlloc" and sizeArg = 3 and reallocArg = 2
        or
        // CoTaskMemRealloc(ptr, size)
        name = "CoTaskMemRealloc" and sizeArg = 1 and reallocArg = 0
        or
        // CRYPTO_realloc(void *addr, size_t num, const char *file, int line);
        name = "CRYPTO_realloc" and sizeArg = 1 and reallocArg = 0
      )
    )
  }

  override int getSizeArg() { result = sizeArg }

  override int getReallocPtrArg() { result = reallocArg }
}

/**
 * A miscellaneous allocation function that has no explicit argument for
 * the size of the allocation.
 */
class SizelessAllocationFunction extends AllocationFunction {
  SizelessAllocationFunction() {
    exists(string name |
      hasGlobalName(name) and
      (
        // ExAllocateFromLookasideListEx(list)
        name = "ExAllocateFromLookasideListEx"
        or
        // ExAllocateFromPagedLookasideList(list)
        name = "ExAllocateFromPagedLookasideList"
        or
        // ExAllocateFromNPagedLookasideList(list)
        name = "ExAllocateFromNPagedLookasideList"
        or
        // ExAllocateTimer(callback, context, attributes)
        name = "ExAllocateTimer"
        or
        // IoAllocateWorkItem(object)
        name = "IoAllocateWorkItem"
        or
        // MmMapLockedPagesWithReservedMapping(address, tag, list, type)
        name = "MmMapLockedPagesWithReservedMapping"
        or
        // MmMapLockedPages(list, mode)
        name = "MmMapLockedPages"
        or
        // MmMapLockedPagesSpecifyCache(list, mode, type, address, flag, flag)
        name = "MmMapLockedPagesSpecifyCache"
        or
        // pool_get(pool, flags)
        name = "pool_get"
        or
        // pool_cache_get(pool, flags)
        name = "pool_cache_get"
      )
    )
  }
}

/**
 * An `operator new` or `operator new[]` function that may be associated with `new` or
 * `new[]` expressions.  Note that `new` and `new[]` are not function calls, but these
 * functions may also be called directly.
 */
class OperatorNewAllocationFunction extends AllocationFunction {
  OperatorNewAllocationFunction() {
    exists(string name |
      hasGlobalName(name) and
      (
        // operator new(bytes, ...)
        name = "operator new"
        or
        // operator new[](bytes, ...)
        name = "operator new[]"
      )
    )
  }

  override int getSizeArg() { result = 0 }

  override predicate requiresDealloc() { not exists(getPlacementArgument()) }

  /**
   * Gets the position of the placement pointer if this is a placement
   * `operator new` function.
   */
  int getPlacementArgument() {
    getNumberOfParameters() = 2 and
    getParameter(1).getType() instanceof VoidPointerType and
    result = 1
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

/**
 * An allocation expression that is a function call, such as call to `malloc`.
 */
class CallAllocationExpr extends AllocationExpr, FunctionCall {
  AllocationFunction target;

  CallAllocationExpr() {
    target = getTarget() and
    // realloc(ptr, 0) only frees the pointer
    not (
      exists(target.getReallocPtrArg()) and
      getArgument(target.getSizeArg()).getValue().toInt() = 0
    ) and
    // these are modelled directly (and more accurately), avoid duplication
    not exists(NewOrNewArrayExpr new | new.getAllocatorCall() = this)
  }

  override Expr getSizeExpr() {
    exists(Expr sizeExpr | sizeExpr = getArgument(target.getSizeArg()) |
      if exists(target.getSizeMult())
      then result = sizeExpr
      else
        exists(Expr lengthExpr |
          deconstructSizeExpr(sizeExpr, lengthExpr, _) and
          result = lengthExpr
        )
    )
  }

  override int getSizeMult() {
    // malloc with multiplier argument that is a constant
    result = getArgument(target.getSizeMult()).getValue().toInt()
    or
    // malloc with no multiplier argument
    not exists(target.getSizeMult()) and
    deconstructSizeExpr(getArgument(target.getSizeArg()), _, result)
  }

  override int getSizeBytes() { result = getSizeExpr().getValue().toInt() * getSizeMult() }

  override Expr getReallocPtr() { result = getArgument(target.getReallocPtrArg()) }

  override Type getAllocatedElementType() {
    result =
      this.getFullyConverted().getType().stripTopLevelSpecifiers().(PointerType).getBaseType() and
    not result instanceof VoidType
  }

  override predicate requiresDealloc() { target.requiresDealloc() }
}

/**
 * An allocation expression that is a `new` expression.
 */
class NewAllocationExpr extends AllocationExpr, NewExpr {
  NewAllocationExpr() { this instanceof NewExpr }

  override int getSizeBytes() { result = getAllocatedType().getSize() }

  override Type getAllocatedElementType() { result = getAllocatedType() }

  override predicate requiresDealloc() { not exists(getPlacementPointer()) }
}

/**
 * An allocation expression that is a `new []` expression.
 */
class NewArrayAllocationExpr extends AllocationExpr, NewArrayExpr {
  NewArrayAllocationExpr() { this instanceof NewArrayExpr }

  override Expr getSizeExpr() {
    // new array expr with variable size
    result = getExtent()
  }

  override int getSizeMult() {
    // new array expr with variable size
    exists(getExtent()) and
    result = getAllocatedElementType().getSize()
  }

  override Type getAllocatedElementType() { result = NewArrayExpr.super.getAllocatedElementType() }

  override int getSizeBytes() { result = getAllocatedType().getSize() }

  override predicate requiresDealloc() { not exists(getPlacementPointer()) }
}
