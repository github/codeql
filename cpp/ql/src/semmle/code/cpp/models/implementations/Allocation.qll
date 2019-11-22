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
      (
        // malloc(size)
        (name = "malloc" and sizeArg = 0)
      )
      or
      hasGlobalName(name) and
      (
        // ExAllocatePool(type, size)
        (name = "ExAllocatePool" and sizeArg = 1) or
        // ExAllocatePool(type, size, tag)
        (name = "ExAllocatePoolWithTag" and sizeArg = 1) or
        // ExAllocatePoolWithTagPriority(type, size, tag, priority)
        (name = "ExAllocatePoolWithTagPriority" and sizeArg = 1) or
        // ExAllocatePoolWithQuota(type, size)
        (name = "ExAllocatePoolWithQuota" and sizeArg = 1) or
        // ExAllocatePoolWithQuotaTag(type, size, tag)
        (name = "ExAllocatePoolWithQuotaTag" and sizeArg = 1) or
        // IoAllocateMdl(address, size, flag, flag, irp)
        (name = "IoAllocateMdl" and sizeArg = 1) or
        // IoAllocateErrorLogEntry(object, size)
        (name = "IoAllocateErrorLogEntry" and sizeArg = 1) or
        // MmAllocateContiguousMemory(size, maxaddress)
        (name = "MmAllocateContiguousMemory" and sizeArg = 0) or
        // MmAllocateContiguousNodeMemory(size, minaddress, maxaddress, bound, flag, prefer)
        (name = "MmAllocateContiguousNodeMemory" and sizeArg = 0) or
        // MmAllocateContiguousMemorySpecifyCache(size, minaddress, maxaddress, bound, type)
        (name = "MmAllocateContiguousMemorySpecifyCache" and sizeArg = 0) or
        // MmAllocateContiguousMemorySpecifyCacheNode(size, minaddress, maxaddress, bound, type, prefer)
        (name = "MmAllocateContiguousMemorySpecifyCacheNode" and sizeArg = 0) or
        // MmAllocateNonCachedMemory(size)
        (name = "MmAllocateNonCachedMemory" and sizeArg = 0) or
        // MmAllocateMappingAddress(size, tag)
        (name = "MmAllocateMappingAddress" and sizeArg = 0) or
        // MmAllocatePagesForMdl(minaddress, maxaddress, skip, size)
        (name = "MmAllocatePagesForMdl" and sizeArg = 3) or
        // MmAllocatePagesForMdlEx(minaddress, maxaddress, skip, size, type, flags)
        (name = "MmAllocatePagesForMdlEx" and sizeArg = 3) or
        // MmAllocateNodePagesForMdlEx(minaddress, maxaddress, skip, size, type, prefer, flags)
        (name = "MmAllocateNodePagesForMdlEx" and sizeArg = 3) or
        // LocalAlloc(flags, size)
        (name = "LocalAlloc" and sizeArg = 1) or
        // GlobalAlloc(flags, size)
        (name = "GlobalAlloc" and sizeArg = 1) or
        // HeapAlloc(heap, flags, size)
        (name = "HeapAlloc" and sizeArg = 2) or
        // VirtualAlloc(address, size, type, flag)
        (name = "VirtualAlloc" and sizeArg = 1) or
        // CoTaskMemAlloc(size)
        (name = "CoTaskMemAlloc" and sizeArg = 0)
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
      // calloc(num, size)
      (name = "calloc" and sizeArg = 1 and multArg = 0)
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
      // realloc(ptr, size)
      (name = "realloc" and sizeArg = 1 and reallocArg = 0)
    )
    or
    hasGlobalName(name) and
    (
      // LocalReAlloc(ptr, size, flags)
      (name = "LocalReAlloc" and sizeArg = 1 and reallocArg = 0) or
      // GlobalReAlloc(ptr, size, flags)
      (name = "GlobalReAlloc" and sizeArg = 1 and reallocArg = 0) or
      // HeapReAlloc(heap, flags, ptr, size)
      (name = "HeapReAlloc" and sizeArg = 3 and reallocArg = 2) or
      // CoTaskMemRealloc(ptr, size)
      (name = "CoTaskMemRealloc" and sizeArg = 1 and reallocArg = 0)
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
        // strdup(str)
        name = "strdup" or
        // wcsdup(str)
        name = "wcsdup"
      )
      or
      hasGlobalName(name) and
      (
        // _strdup(str)
        name = "_strdup" or
        // _wcsdup(str)
        name = "_wcsdup" or
        // _mbsdup(str)
        name = "_mbsdup" or
        // ExAllocateFromLookasideListEx(list)
        name = "ExAllocateFromLookasideListEx" or
        // ExAllocateFromPagedLookasideList(list)
        name = "ExAllocateFromPagedLookasideList" or
        // ExAllocateFromNPagedLookasideList(list)
        name = "ExAllocateFromNPagedLookasideList" or
        // ExAllocateTimer(callback, context, attributes)
        name = "ExAllocateTimer" or
        // IoAllocateWorkItem(object)
        name = "IoAllocateWorkItem" or
        // MmMapLockedPagesWithReservedMapping(address, tag, list, type)
        name = "MmMapLockedPagesWithReservedMapping" or
        // MmMapLockedPages(list, mode)
        name = "MmMapLockedPages" or
        // MmMapLockedPagesSpecifyCache(list, mode, type, address, flag, flag)
        name = "MmMapLockedPagesSpecifyCache"
      )
    )
  }
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
