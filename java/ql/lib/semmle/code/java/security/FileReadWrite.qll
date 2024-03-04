import java

/**
 * Holds if `fileAccess` is directly used in the `fileReadingExpr` to read the represented file.
 */
private predicate directFileRead(Expr fileAccess, Expr fileReadingExpr) {
  // `fileAccess` used to construct a class that reads a file.
  exists(ClassInstanceExpr cie |
    cie = fileReadingExpr and
    cie.getArgument(0) = fileAccess
  |
    cie.getConstructedType()
        .hasQualifiedName("java.io", ["RandomAccessFile", "FileReader", "FileInputStream"])
  )
  or
  exists(MethodCall ma, Method filesMethod | ma = fileReadingExpr and filesMethod = ma.getMethod() |
    (
      // Identify all method calls on the `Files` class that imply that we are reading the file
      // represented by the first argument.
      filesMethod.getDeclaringType().hasQualifiedName("java.nio.file", "Files") and
      fileAccess = ma.getArgument(0) and
      filesMethod
          .hasName([
              "readAllBytes", "readAllLines", "readString", "lines", "newBufferedReader",
              "newInputStream", "newByteChannel"
            ])
    )
  )
}

/**
 * Holds if `fileAccess` is used in the `fileReadingExpr` to read the represented file.
 */
private predicate fileRead(VarAccess fileAccess, Expr fileReadingExpr) {
  directFileRead(fileAccess, fileReadingExpr)
  or
  // The `fileAccess` is used in a call which directly or indirectly accesses the file.
  exists(Call call, int parameterPos, VarAccess nestedFileAccess |
    call = fileReadingExpr and
    fileRead(nestedFileAccess, _) and
    call.getCallee().getParameter(parameterPos) = nestedFileAccess.getVariable() and
    fileAccess = call.getArgument(parameterPos)
  )
}

/**
 * An expression that, directly or indirectly, reads from a file.
 */
class FileReadExpr extends Expr {
  FileReadExpr() { fileRead(_, this) }

  /**
   * Gets the `VarAccess` representing the file that is read.
   */
  VarAccess getFileVarAccess() { fileRead(result, this) }
}

/**
 * An expression that directly reads from a file and returns its contents.
 */
class DirectFileReadExpr extends Expr {
  DirectFileReadExpr() { directFileRead(_, this) }

  /**
   * Gets the `Expr` representing the file that is read.
   */
  Expr getFileExpr() { directFileRead(result, this) }
}
