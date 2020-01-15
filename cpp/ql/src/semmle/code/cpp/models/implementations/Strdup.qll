import semmle.code.cpp.models.interfaces.Allocation

/**
 * A `strdup` style allocation function.
 */
class StrdupFunction extends AllocationFunction {
  StrdupFunction() {
    exists(string name |
      hasGlobalOrStdName(name) and
      (
        // strdup(str)
        name = "strdup"
        or
        // wcsdup(str)
        name = "wcsdup"
      )
      or
      hasGlobalName(name) and
      (
        // _strdup(str)
        name = "_strdup"
        or
        // _wcsdup(str)
        name = "_wcsdup"
        or
        // _mbsdup(str)
        name = "_mbsdup"
      )
    )
  }
}
