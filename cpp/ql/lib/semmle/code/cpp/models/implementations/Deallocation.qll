/**
 * Provides implementation classes  modeling various methods of deallocation
 * (`free`, `delete` etc). See `semmle.code.cpp.models.interfaces.Deallocation`
 * for usage information.
 */

import semmle.code.cpp.models.interfaces.Deallocation

/**
 * A deallocation function such as `free`.
 */
private class StandardDeallocationFunction extends DeallocationFunction {
  int freedArg;

  StandardDeallocationFunction() {
    hasGlobalOrStdOrBslName([
        // --- C library allocation
        "free", "realloc"
      ]) and
    freedArg = 0
    or
    hasGlobalName([
        // --- OpenSSL memory allocation
        "CRYPTO_free", "CRYPTO_secure_free"
      ]) and
    freedArg = 0
    or
    hasGlobalOrStdName([
        // --- Windows Memory Management for Windows Drivers
        "ExFreePoolWithTag", "ExDeleteTimer", "IoFreeMdl", "IoFreeWorkItem", "IoFreeErrorLogEntry",
        "MmFreeContiguousMemory", "MmFreeContiguousMemorySpecifyCache", "MmFreeNonCachedMemory",
        "MmFreeMappingAddress", "MmFreePagesFromMdl", "MmUnmapReservedMapping",
        "MmUnmapLockedPages",
        // --- Windows Global / Local legacy allocation
        "LocalFree", "GlobalFree", "LocalReAlloc", "GlobalReAlloc",
        // --- Windows System Services allocation
        "VirtualFree",
        // --- Windows COM allocation
        "CoTaskMemFree", "CoTaskMemRealloc",
        // --- Windows Automation
        "SysFreeString",
        // --- Solaris/BSD kernel memory allocator
        "kmem_free"
      ]) and
    freedArg = 0
    or
    hasGlobalOrStdName([
        // --- Windows Memory Management for Windows Drivers
        "ExFreeToLookasideListEx", "ExFreeToPagedLookasideList", "ExFreeToNPagedLookasideList",
        // --- NetBSD pool manager
        "pool_put", "pool_cache_put"
      ]) and
    freedArg = 1
    or
    hasGlobalOrStdName(["HeapFree", "HeapReAlloc"]) and
    freedArg = 2
  }

  override int getFreedArg() { result = freedArg }
}

/**
 * An deallocation expression that is a function call, such as call to `free`.
 */
private class CallDeallocationExpr extends DeallocationExpr, FunctionCall {
  DeallocationFunction target;

  CallDeallocationExpr() { target = getTarget() }

  override Expr getFreedExpr() { result = getArgument(target.getFreedArg()) }
}

/**
 * An deallocation expression that is a `delete` expression.
 */
private class DeleteDeallocationExpr extends DeallocationExpr, DeleteExpr {
  DeleteDeallocationExpr() { this instanceof DeleteExpr }

  override Expr getFreedExpr() { result = getExpr() }
}

/**
 * An deallocation expression that is a `delete []` expression.
 */
private class DeleteArrayDeallocationExpr extends DeallocationExpr, DeleteArrayExpr {
  DeleteArrayDeallocationExpr() { this instanceof DeleteArrayExpr }

  override Expr getFreedExpr() { result = getExpr() }
}
