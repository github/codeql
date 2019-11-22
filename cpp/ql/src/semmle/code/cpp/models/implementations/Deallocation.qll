import semmle.code.cpp.models.interfaces.Allocation

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
