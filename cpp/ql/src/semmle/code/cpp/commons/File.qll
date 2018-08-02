import cpp

/**
 * A call to a library function that opens a file.
 */
predicate fopenCall(FunctionCall fc)
{
  exists(Function f | f = fc.getTarget() |
    f.hasQualifiedName("fopen") or
    f.hasQualifiedName("open") or
    f.hasQualifiedName("_open") or
    f.hasQualifiedName("_wopen") or
    f.hasQualifiedName("CreateFile") or
    f.hasQualifiedName("CreateFileA") or
    f.hasQualifiedName("CreateFileW") or
    f.hasQualifiedName("CreateFileTransacted") or
    f.hasQualifiedName("CreateFileTransactedA") or
    f.hasQualifiedName("CreateFileTransactedW")
  )
}

/**
 * A call to a library function that closes a file.
 */
predicate fcloseCall(FunctionCall fc, Expr closed)
{
  exists(Function f | f = fc.getTarget() |
    (
      f.hasQualifiedName("fclose") and
      closed = fc.getArgument(0)
    ) or (
      f.hasQualifiedName("close") and
      closed = fc.getArgument(0)
    ) or (
      f.hasQualifiedName("_close") and
      closed = fc.getArgument(0)
    ) or (
      f.hasQualifiedName("CloseHandle") and
      closed = fc.getArgument(0)
    )
  )
}