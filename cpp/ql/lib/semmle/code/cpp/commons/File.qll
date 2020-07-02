/**
 * Provides predicates for identifying function calls that open or close a file.
 */

import cpp

/**
 * A call to a library function that opens a file.
 */
predicate fopenCall(FunctionCall fc) {
  exists(Function f | f = fc.getTarget() |
    f.hasGlobalOrStdName("fopen") or
    f.hasGlobalName("open") or
    f.hasGlobalName("_open") or
    f.hasGlobalName("_wopen") or
    f.hasGlobalName("CreateFile") or
    f.hasGlobalName("CreateFileA") or
    f.hasGlobalName("CreateFileW") or
    f.hasGlobalName("CreateFileTransacted") or
    f.hasGlobalName("CreateFileTransactedA") or
    f.hasGlobalName("CreateFileTransactedW")
  )
}

/**
 * A call to a library function that closes a file.
 */
predicate fcloseCall(FunctionCall fc, Expr closed) {
  exists(Function f | f = fc.getTarget() |
    f.hasGlobalOrStdName("fclose") and
    closed = fc.getArgument(0)
    or
    f.hasGlobalName("close") and
    closed = fc.getArgument(0)
    or
    f.hasGlobalName("_close") and
    closed = fc.getArgument(0)
    or
    f.hasGlobalOrStdName("CloseHandle") and
    closed = fc.getArgument(0)
  )
}
