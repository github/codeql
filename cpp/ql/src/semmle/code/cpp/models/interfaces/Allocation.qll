/**
 * Provides an abstract class for modelling expressions that allocate or
 * deallocate memory, such as the standard `malloc` function.
 */

import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.models.Models

/**
 * An allocation function such as `malloc`.
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
}

/**
 * An allocation function (such as `malloc`) that has an argument for the size
 * in bytes.
 */
class MallocAllocationFunction extends AllocationFunction {
  int sizeArg;

  MallocAllocationFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      (
        (name = "malloc" and sizeArg = 0) // malloc(size)
      )
      or
      hasGlobalName(name) and
      (
        (name = "ExAllocatePool" and sizeArg = 1) or // ExAllocatePool(type, size)
        (name = "ExAllocatePoolWithTag" and sizeArg = 1) or // ExAllocatePool(type, size, tag)
        (name = "ExAllocatePoolWithTagPriority" and sizeArg = 1) or // ExAllocatePoolWithTagPriority(type, size, tag, priority)
        (name = "ExAllocatePoolWithQuota" and sizeArg = 1) or // ExAllocatePoolWithQuota(type, size)
        (name = "ExAllocatePoolWithQuotaTag" and sizeArg = 1) or // ExAllocatePoolWithQuotaTag(type, size, tag)
        (name = "IoAllocateMdl" and sizeArg = 1) or // IoAllocateMdl(address, size, flag, flag, irp)
        (name = "IoAllocateErrorLogEntry" and sizeArg = 1) or // IoAllocateErrorLogEntry(object, size)
        (name = "MmAllocateContiguousMemory" and sizeArg = 0) or // MmAllocateContiguousMemory(size, maxaddress)
        (name = "MmAllocateContiguousNodeMemory" and sizeArg = 0) or // MmAllocateContiguousNodeMemory(size, minaddress, maxaddress, bound, flag, prefer)
        (name = "MmAllocateContiguousMemorySpecifyCache" and sizeArg = 0) or // MmAllocateContiguousMemorySpecifyCache(size, minaddress, maxaddress, bound, type)
        (name = "MmAllocateContiguousMemorySpecifyCacheNode" and sizeArg = 0) or // MmAllocateContiguousMemorySpecifyCacheNode(size, minaddress, maxaddress, bound, type, prefer)
        (name = "MmAllocateNonCachedMemory" and sizeArg = 0) or // MmAllocateNonCachedMemory(size)
        (name = "MmAllocateMappingAddress" and sizeArg = 0) or // MmAllocateMappingAddress(size, tag)
        (name = "MmAllocatePagesForMdl" and sizeArg = 3) or // MmAllocatePagesForMdl(minaddress, maxaddress, skip, size)
        (name = "MmAllocatePagesForMdlEx" and sizeArg = 3) or // MmAllocatePagesForMdlEx(minaddress, maxaddress, skip, size, type, flags)
        (name = "MmAllocateNodePagesForMdlEx" and sizeArg = 3) or // MmAllocateNodePagesForMdlEx(minaddress, maxaddress, skip, size, type, prefer, flags)
        (name = "LocalAlloc" and sizeArg = 1) or // LocalAlloc(flags, size)
        (name = "GlobalAlloc" and sizeArg = 1) or // GlobalAlloc(flags, size)
        (name = "HeapAlloc" and sizeArg = 2) or // HeapAlloc(heap, flags, size)
        (name = "VirtualAlloc" and sizeArg = 1) or // VirtualAlloc(address, size, type, flag)
        (name = "CoTaskMemAlloc" and sizeArg = 0) // CoTaskMemAlloc(size)
      )
    )
  }

  override int getSizeArg() {
  	result = sizeArg
  }
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
      (name = "calloc" and sizeArg = 1 and multArg = 0) // calloc(num, size)
    )
  }

  override int getSizeArg() {
  	result = sizeArg
  }

  override int getSizeMult() {
  	result = multArg
  }
}

/**
 * An allocation function (such as `realloc`) that has an argument for the size
 * in bytes, and an argument for an existing pointer that is to be reallocated.
 */
class ReallocAllocationFunction extends AllocationFunction {
  int sizeArg;
  int reallocArg;

  ReallocAllocationFunction() {  exists(string name |
    hasGlobalOrStdName(name) and
    (
      (name = "realloc" and sizeArg = 1 and reallocArg = 0) // realloc(ptr, size)
    )
    or
    hasGlobalName(name) and
    (
      (name = "LocalReAlloc" and sizeArg = 1 and reallocArg = 0) or // LocalReAlloc(ptr, size, flags)
      (name = "GlobalReAlloc" and sizeArg = 1 and reallocArg = 0) or // GlobalReAlloc(ptr, size, flags)
      (name = "HeapReAlloc" and sizeArg = 3 and reallocArg = 2) or // HeapReAlloc(heap, flags, ptr, size)
      (name = "CoTaskMemRealloc" and sizeArg = 1 and reallocArg = 0) // CoTaskMemRealloc(ptr, size)
    )
  )
  }

  override int getSizeArg() {
  	result = sizeArg
  }

  override int getReallocPtrArg() {
    result = reallocArg
  }
}

/**
 * An allocation function (such as `strdup`) that has no explicit argument for
 * the size of the allocation.
 */
class StrdupAllocationFunction extends AllocationFunction {
  StrdupAllocationFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      (
        name = "strdup" or // strdup(str)
        name = "wcsdup" // wcsdup(str)
      )
      or
      hasGlobalName(name) and
      (
        name = "_strdup" or // _strdup(str)
        name = "_wcsdup" or // _wcsdup(str)
        name = "_mbsdup" or // _mbsdup(str)
        name = "ExAllocateFromLookasideListEx" or // ExAllocateFromLookasideListEx(list)
        name = "ExAllocateFromPagedLookasideList" or // ExAllocateFromPagedLookasideList(list)
        name = "ExAllocateFromNPagedLookasideList" or // ExAllocateFromNPagedLookasideList(list)
        name = "ExAllocateTimer" or // ExAllocateTimer(callback, context, attributes)
        name = "IoAllocateWorkItem" or // IoAllocateWorkItem(object)
        name = "MmMapLockedPagesWithReservedMapping" or // MmMapLockedPagesWithReservedMapping(address, tag, list, type)
        name = "MmMapLockedPages" or // MmMapLockedPages(list, mode)
        name = "MmMapLockedPagesSpecifyCache" // MmMapLockedPagesSpecifyCache(list, mode, type, address, flag, flag)
      )
    )
  }
}

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
  	)
  }

  override Expr getSizeExpr() {
  	result = getArgument(target.getSizeArg())
  }

  override int getSizeMult() {
  	// malloc with multiplier argument that is a constant
    result = getArgument(target.getSizeMult()).getValue().toInt()
    or
    // malloc with no multiplier argument
    (
  	  not exists(target.getSizeMult()) and
  	  result = 1
  	)
  }

  override int getSizeBytes() {
  	result = getSizeExpr().getValue().toInt() * getSizeMult()
  }

  override Expr getReallocPtr() {
  	result = getArgument(target.getReallocPtrArg())
  }
}

/**
 * An allocation expression that is a `new` expression.
 */
class NewAllocationExpr extends AllocationExpr, NewExpr {
  NewAllocationExpr() {
  	this instanceof NewExpr
  }

  override int getSizeBytes() {
    result = getAllocatedType().getSize()
  }
}

/**
 * An allocation expression that is a `new []` expression.
 */
class NewArrayAllocationExpr extends AllocationExpr, NewArrayExpr {
  NewArrayAllocationExpr() {
  	this instanceof NewArrayExpr
  }

  override Expr getSizeExpr() {
  	// new array expr with variable size
  	result = getExtent()
  }

  override int getSizeMult() {
   // new array expr with variable size
   exists(getExtent()) and
   result = getAllocatedElementType().getSize()
  }

  override int getSizeBytes() {
    result = getAllocatedType().getSize()
  }
}

/**
 * A deallocation function such as `free`.
 */
abstract class DeallocationFunction extends Function {
  /**
   * Gets the index of the argument that is freed by this function.
   */
  int getFreedArg() { none() }
}

/**
 * A deallocation function such as `free`.
 */
class StandardDeallocationFunction extends DeallocationFunction {
  int freedArg;

  StandardDeallocationFunction() {
    exists(string name |
      hasGlobalName(name) and
      (
        name = "free" and freedArg = 0
        or
        name = "realloc" and freedArg = 0
      )
      or
      hasGlobalOrStdName(name) and
      (
        name = "ExFreePoolWithTag" and freedArg = 0
        or
        name = "ExFreeToLookasideListEx" and freedArg = 1
        or
        name = "ExFreeToPagedLookasideList" and freedArg = 1
        or
        name = "ExFreeToNPagedLookasideList" and freedArg = 1
        or
        name = "ExDeleteTimer" and freedArg = 0
        or
        name = "IoFreeMdl" and freedArg = 0
        or
        name = "IoFreeWorkItem" and freedArg = 0
        or
        name = "IoFreeErrorLogEntry" and freedArg = 0
        or
        name = "MmFreeContiguousMemory" and freedArg = 0
        or
        name = "MmFreeContiguousMemorySpecifyCache" and freedArg = 0
        or
        name = "MmFreeNonCachedMemory" and freedArg = 0
        or
        name = "MmFreeMappingAddress" and freedArg = 0
        or
        name = "MmFreePagesFromMdl" and freedArg = 0
        or
        name = "MmUnmapReservedMapping" and freedArg = 0
        or
        name = "MmUnmapLockedPages" and freedArg = 0
        or
        name = "LocalFree" and freedArg = 0
        or
        name = "GlobalFree" and freedArg = 0
        or
        name = "HeapFree" and freedArg = 2
        or
        name = "VirtualFree" and freedArg = 0
        or
        name = "CoTaskMemFree" and freedArg = 0
        or
        name = "SysFreeString" and freedArg = 0
        or
        name = "LocalReAlloc" and freedArg = 0
        or
        name = "GlobalReAlloc" and freedArg = 0
        or
        name = "HeapReAlloc" and freedArg = 2
        or
        name = "CoTaskMemRealloc" and freedArg = 0
      )
    )
  }

  override int getFreedArg() {
  	result = freedArg
  }
}

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
 * An deallocation expression that is a function call, such as call to `free`.
 */
class CallDeallocationExpr extends DeallocationExpr, FunctionCall {
  DeallocationFunction target;

  CallDeallocationExpr() {
  	target = getTarget()
  }

  override Expr getFreedExpr() {
    result = getArgument(target.getFreedArg())
  }
}

/**
 * An deallocation expression that is a `delete` expression.
 */
class DeleteDeallocationExpr extends DeallocationExpr, DeleteExpr {
  DeleteDeallocationExpr() {
    this instanceof DeleteExpr
  }

  override Expr getFreedExpr() {
    result = getExpr()
  }
}

/**
 * An deallocation expression that is a `delete []` expression.
 */
class DeleteArrayDeallocationExpr extends DeallocationExpr, DeleteArrayExpr {
  DeleteArrayDeallocationExpr() {
    this instanceof DeleteArrayExpr
  }

  override Expr getFreedExpr() {
    result = getExpr()
  }
}
