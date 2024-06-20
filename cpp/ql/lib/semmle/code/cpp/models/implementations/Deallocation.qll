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
    this.hasGlobalOrStdOrBslName([
        // --- C library allocation
        "free", "realloc"
      ]) and
    freedArg = 0
    or
    this.hasGlobalName([
        // --- OpenSSL memory deallocation
        "CRYPTO_free", "CRYPTO_secure_free",
        // --- glib memory deallocation
        "g_free"
      ]) and
    freedArg = 0
    or
    this.hasGlobalOrStdName([
        // --- Windows Memory Management for Windows Drivers
        "ExFreePool", "ExFreePoolWithTag", "ExDeleteTimer", "IoFreeIrp", "IoFreeMdl",
        "IoFreeErrorLogEntry", "IoFreeWorkItem", "MmFreeContiguousMemory",
        "MmFreeContiguousMemorySpecifyCache", "MmFreeNonCachedMemory", "MmFreeMappingAddress",
        "MmFreePagesFromMdl", "MmUnmapReservedMapping", "MmUnmapLockedPages",
        "NdisFreeGenericObject", "NdisFreeMemory", "NdisFreeMemoryWithTag", "NdisFreeMdl",
        "NdisFreeNetBufferListPool", "NdisFreeNetBufferPool",
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
    this.hasGlobalOrStdName([
        // --- Windows Memory Management for Windows Drivers
        "ExFreeToLookasideListEx", "ExFreeToPagedLookasideList", "ExFreeToNPagedLookasideList",
        "NdisFreeMemoryWithTagPriority", "StorPortFreeMdl", "StorPortFreePool",
        // --- NetBSD pool manager
        "pool_put", "pool_cache_put"
      ]) and
    freedArg = 1
    or
    this.hasGlobalOrStdName(["HeapFree", "HeapReAlloc"]) and
    freedArg = 2
  }

  override int getFreedArg() { result = freedArg }
}

/**
 * Holds if `f` is an deallocation function according to the
 * extensible `deallocationFunctionModel` predicate.
 */
private predicate isDeallocationFunctionFromModel(
  Function f, string namespace, string type, string name
) {
  exists(boolean subtypes | deallocationFunctionModel(namespace, type, subtypes, name, _) |
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
 * A deallocation function modeled via the extensible `deallocationFunctionModel` predicate.
 */
private class DeallocationFunctionFromModel extends DeallocationFunction {
  string namespace;
  string type;
  string name;

  DeallocationFunctionFromModel() { isDeallocationFunctionFromModel(this, namespace, type, name) }

  final override int getFreedArg() {
    exists(string freedArg |
      deallocationFunctionModel(namespace, type, _, name, freedArg) and
      result = freedArg.toInt()
    )
  }
}

/**
 * An deallocation expression that is a function call, such as call to `free`.
 */
private class CallDeallocationExpr extends DeallocationExpr, FunctionCall {
  DeallocationFunction target;

  CallDeallocationExpr() { target = this.getTarget() }

  override Expr getFreedExpr() { result = this.getArgument(target.getFreedArg()) }
}

/**
 * An deallocation expression that is a `delete` expression.
 */
private class DeleteDeallocationExpr extends DeallocationExpr, DeleteExpr {
  DeleteDeallocationExpr() { this instanceof DeleteExpr }

  override Expr getFreedExpr() { result = this.getExpr() }
}

/**
 * An deallocation expression that is a `delete []` expression.
 */
private class DeleteArrayDeallocationExpr extends DeallocationExpr, DeleteArrayExpr {
  DeleteArrayDeallocationExpr() { this instanceof DeleteArrayExpr }

  override Expr getFreedExpr() { result = this.getExpr() }
}
