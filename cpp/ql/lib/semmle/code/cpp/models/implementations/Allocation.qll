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
private class MallocAllocationFunction extends AllocationFunction {
  int sizeArg;

  MallocAllocationFunction() {
    // --- C library allocation
    this.hasGlobalOrStdOrBslName("malloc") and // malloc(size)
    sizeArg = 0
    or
    this.hasGlobalName([
        // --- Windows Memory Management for Windows Drivers
        "MmAllocateContiguousMemory", // MmAllocateContiguousMemory(size, maxaddress)
        "MmAllocateContiguousNodeMemory", // MmAllocateContiguousNodeMemory(size, minaddress, maxaddress, bound, flag, prefer)
        "MmAllocateContiguousMemorySpecifyCache", // MmAllocateContiguousMemorySpecifyCache(size, minaddress, maxaddress, bound, type)
        "MmAllocateContiguousMemorySpecifyCacheNode", // MmAllocateContiguousMemorySpecifyCacheNode(size, minaddress, maxaddress, bound, type, prefer)
        "MmAllocateNonCachedMemory", // MmAllocateNonCachedMemory(size)
        "MmAllocateMappingAddress", // MmAllocateMappingAddress(size, tag)
        // --- Windows COM allocation
        "CoTaskMemAlloc", // CoTaskMemAlloc(size)
        // --- Solaris/BSD kernel memory allocator
        "kmem_alloc", // kmem_alloc(size, flags)
        "kmem_zalloc", // kmem_zalloc(size, flags)
        // --- OpenSSL memory allocation
        "CRYPTO_malloc", // CRYPTO_malloc(size_t num, const char *file, int line)
        "CRYPTO_zalloc", // CRYPTO_zalloc(size_t num, const char *file, int line)
        "CRYPTO_secure_malloc", // CRYPTO_secure_malloc(size_t num, const char *file, int line)
        "CRYPTO_secure_zalloc" // CRYPTO_secure_zalloc(size_t num, const char *file, int line)
      ]) and
    sizeArg = 0
    or
    this.hasGlobalName([
        // --- Windows Memory Management for Windows Drivers
        "ExAllocatePool", // ExAllocatePool(type, size)
        "ExAllocatePool2", // ExAllocatePool2(flags, size, tag)
        "ExAllocatePool3", // ExAllocatePool3(flags, size, tag, extparams, extparamscount)
        "ExAllocatePoolWithTag", // ExAllocatePool(type, size, tag)
        "ExAllocatePoolWithTagPriority", // ExAllocatePoolWithTagPriority(type, size, tag, priority)
        "ExAllocatePoolWithQuota", // ExAllocatePoolWithQuota(type, size)
        "ExAllocatePoolWithQuotaTag", // ExAllocatePoolWithQuotaTag(type, size, tag)
        "ExAllocatePoolZero", // ExAllocatePoolZero(type, size, tag)
        "IoAllocateMdl", // IoAllocateMdl(address, size, flag, flag, irp)
        "IoAllocateErrorLogEntry", // IoAllocateErrorLogEntry(object, size)
        // --- Windows Global / Local legacy allocation
        "LocalAlloc", // LocalAlloc(flags, size)
        "GlobalAlloc", // GlobalAlloc(flags, size)
        // --- Windows System Services allocation
        "VirtualAlloc" // VirtualAlloc(address, size, type, flag)
      ]) and
    sizeArg = 1
    or
    this.hasGlobalName("HeapAlloc") and // HeapAlloc(heap, flags, size)
    sizeArg = 2
    or
    this.hasGlobalName([
        // --- Windows Memory Management for Windows Drivers
        "MmAllocatePagesForMdl", // MmAllocatePagesForMdl(minaddress, maxaddress, skip, size)
        "MmAllocatePagesForMdlEx", // MmAllocatePagesForMdlEx(minaddress, maxaddress, skip, size, type, flags)
        "MmAllocateNodePagesForMdlEx" // MmAllocateNodePagesForMdlEx(minaddress, maxaddress, skip, size, type, prefer, flags)
      ]) and
    sizeArg = 3
  }

  override int getSizeArg() { result = sizeArg }
}

/**
 * An allocation function (such as `alloca`) that does not require a
 * corresponding free (and has an argument for the size in bytes).
 */
private class AllocaAllocationFunction extends AllocationFunction {
  int sizeArg;

  AllocaAllocationFunction() {
    this.hasGlobalName([
        // --- stack allocation
        "alloca", // // alloca(size)
        "__builtin_alloca", // __builtin_alloca(size)
        "_alloca", // _alloca(size)
        "_malloca" // _malloca(size)
      ]) and
    sizeArg = 0
  }

  override int getSizeArg() { result = sizeArg }

  override predicate requiresDealloc() { none() }
}

/**
 * An allocation function (such as `calloc`) that has an argument for the size
 * and another argument for the size of those units (in bytes).
 */
private class CallocAllocationFunction extends AllocationFunction {
  int sizeArg;
  int multArg;

  CallocAllocationFunction() {
    // --- C library allocation
    this.hasGlobalOrStdOrBslName("calloc") and // calloc(num, size)
    sizeArg = 1 and
    multArg = 0
  }

  override int getSizeArg() { result = sizeArg }

  override int getSizeMult() { result = multArg }
}

/**
 * An allocation function (such as `realloc`) that has an argument for the size
 * in bytes, and an argument for an existing pointer that is to be reallocated.
 */
private class ReallocAllocationFunction extends AllocationFunction {
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
        "CRYPTO_realloc" // CRYPTO_realloc(void *addr, size_t num, const char *file, int line)
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

private signature class CallAllocationExprTarget extends Function;

private module CallAllocationExprBase<CallAllocationExprTarget Target> {
  signature int getReallocPtrArgSig(Target target);

  signature int getSizeArgSig(Target target);

  signature int getSizeMultSig(Target target);

  signature predicate requiresDeallocSig(Target target);

  module With<
  getReallocPtrArgSig/1 getReallocPtrArg, getSizeArgSig/1 getSizeArg, getSizeMultSig/1 getSizeMult,
  requiresDeallocSig/1 requiresDealloc> {
    /**
     * An allocation expression that is a function call, such as call to `malloc`.
     */
    class CallAllocationExprImpl instanceof FunctionCall {
      Target target;

      CallAllocationExprImpl() {
        target = this.getTarget() and
        // realloc(ptr, 0) only frees the pointer
        not (
          exists(getReallocPtrArg(target)) and
          this.getArgument(getSizeArg(target)).getValue().toInt() = 0
        ) and
        // these are modeled directly (and more accurately), avoid duplication
        not exists(NewOrNewArrayExpr new | new.getAllocatorCall() = this)
      }

      string toString() { result = super.toString() }

      Expr getSizeExprImpl() {
        exists(Expr sizeExpr | sizeExpr = super.getArgument(getSizeArg(target)) |
          if exists(getSizeMult(target))
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
        result = super.getArgument(getSizeMult(target)).getValue().toInt()
        or
        // malloc with no multiplier argument
        not exists(getSizeMult(target)) and
        deconstructSizeExpr(super.getArgument(getSizeArg(target)), _, result)
      }

      int getSizeBytesImpl() {
        result = this.getSizeExprImpl().getValue().toInt() * this.getSizeMultImpl()
      }

      Expr getReallocPtrImpl() { result = super.getArgument(getReallocPtrArg(target)) }

      Type getAllocatedElementTypeImpl() {
        result =
          super.getFullyConverted().getType().stripTopLevelSpecifiers().(PointerType).getBaseType() and
        not result instanceof VoidType
      }

      predicate requiresDeallocImpl() { requiresDealloc(target) }
    }
  }
}

private module CallAllocationExpr {
  private int getReallocPtrArg(AllocationFunction f) { result = f.getReallocPtrArg() }

  private int getSizeArg(AllocationFunction f) { result = f.getSizeArg() }

  private int getSizeMult(AllocationFunction f) { result = f.getSizeMult() }

  private predicate requiresDealloc(AllocationFunction f) { f.requiresDealloc() }

  private class Base =
    CallAllocationExprBase<AllocationFunction>::With<getReallocPtrArg/1, getSizeArg/1, getSizeMult/1, requiresDealloc/1>::CallAllocationExprImpl;

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

private module HeuristicAllocation {
  private class HeuristicAllocationModeled extends HeuristicAllocationExpr instanceof AllocationExpr {
    override Expr getSizeExpr() { result = AllocationExpr.super.getSizeExpr() }

    override int getSizeMult() { result = AllocationExpr.super.getSizeMult() }

    override int getSizeBytes() { result = AllocationExpr.super.getSizeBytes() }

    override Expr getReallocPtr() { result = AllocationExpr.super.getReallocPtr() }

    override Type getAllocatedElementType() {
      result = AllocationExpr.super.getAllocatedElementType()
    }

    override predicate requiresDealloc() { AllocationExpr.super.requiresDealloc() }
  }

  private class HeuristicAllocationFunctionModeled extends HeuristicAllocationFunction instanceof AllocationFunction {
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

  private class HeuristicAllocationFunctionByName extends HeuristicAllocationFunction instanceof Function {
    int sizeArg;

    HeuristicAllocationFunctionByName() {
      Function.super.getName().matches("%alloc%") and
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

  private int getReallocPtrArg(HeuristicAllocationFunction f) { result = f.getReallocPtrArg() }

  private int getSizeArg(HeuristicAllocationFunction f) { result = f.getSizeArg() }

  private int getSizeMult(HeuristicAllocationFunction f) { result = f.getSizeMult() }

  private predicate requiresDealloc(HeuristicAllocationFunction f) { f.requiresDealloc() }

  private class Base =
    CallAllocationExprBase<HeuristicAllocationFunction>::With<getReallocPtrArg/1, getSizeArg/1, getSizeMult/1, requiresDealloc/1>::CallAllocationExprImpl;

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
