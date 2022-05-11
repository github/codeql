import java

/**
 * A `File.setWritable(..)` method.
 */
class SetWritable extends Method {
  SetWritable() {
    getDeclaringType() instanceof TypeFile and
    hasName("setWritable")
  }
}

/**
 * Gets an `EnumConstant` that may be in the `Set` of `Enum`s represented by `enumSetRef`.
 */
private EnumConstant getAContainedEnumConstant(Expr enumSetRef) {
  enumSetRef
      .getType()
      .(RefType)
      .getAnAncestor()
      .getSourceDeclaration()
      .hasQualifiedName("java.util", "Set") and
  (
    // The set is defined inline using `EnumSet.of(...)`.
    exists(MethodAccess enumSetOf |
      enumSetOf = enumSetRef and
      enumSetOf.getMethod().hasName("of") and
      enumSetOf
          .getMethod()
          .getDeclaringType()
          .getSourceDeclaration()
          .hasQualifiedName("java.util", "EnumSet")
    |
      // Any argument to `EnumSet.of(...)` is an `EnumConstant`.
      result = enumSetOf.getAnArgument().(VarAccess).getVariable()
    )
    or
    // The set reference is an access of a variable...
    exists(VarAccess enumSetAccess | enumSetAccess = enumSetRef |
      // ...if the definition contains a value...
      result = getAContainedEnumConstant(enumSetAccess.getVariable().getAnAssignedValue())
      or
      // ...or the value is added to the set.
      exists(MethodAccess addToSet |
        addToSet.getQualifier() = enumSetAccess.getVariable().getAnAccess()
      |
        // Call to `add(..)` on the enum set variable.
        addToSet.getMethod().hasName("add") and
        result = addToSet.getArgument(0).(VarAccess).getVariable()
        or
        // Call to `addAll(..)` on the enum set variable.
        addToSet.getMethod().hasName("addAll") and
        result = getAContainedEnumConstant(addToSet.getArgument(0))
      )
    )
  )
}

/**
 * Gets a `VarAccess` to a `File` that is converted to a `Path` by `pathExpr`.
 */
private VarAccess getFileForPathConversion(Expr pathExpr) {
  pathExpr.getType().(RefType).hasQualifiedName("java.nio.file", "Path") and
  (
    // Look for conversion from `File` to `Path` using `file.toPath()`.
    exists(MethodAccess fileToPath |
      fileToPath = pathExpr and
      result = fileToPath.getQualifier() and
      fileToPath.getMethod().hasName("toPath") and
      fileToPath.getMethod().getDeclaringType() instanceof TypeFile
    )
    or
    // Look for the pattern `Paths.get(file.get*Path())` for converting between a `File` and a `Path`.
    exists(MethodAccess pathsGet, MethodAccess fileGetPath |
      pathsGet = pathExpr and
      pathsGet.getMethod().hasName("get") and
      pathsGet.getMethod().getDeclaringType().hasQualifiedName("java.nio.file", "Paths") and
      fileGetPath = pathsGet.getArgument(0) and
      result = fileGetPath.getQualifier()
    |
      fileGetPath.getMethod().hasName("getPath") or
      fileGetPath.getMethod().hasName("getAbsolutePath") or
      fileGetPath.getMethod().hasName("getCanonicalPath")
    )
  )
}

/**
 * Holds if `fileAccess` is used in the `setWorldWritableExpr` to set the file to be world writable.
 */
private predicate fileSetWorldWritable(VarAccess fileAccess, Expr setWorldWritable) {
  // Calls to `File.setWritable(.., false)`.
  exists(MethodAccess fileSetWritable |
    // A call to the `setWritable` method.
    fileSetWritable.getMethod() instanceof SetWritable and
    // Where we may be setting `writable` to `true`.
    not fileSetWritable.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = false and
    // The permission applies to everyone.
    fileSetWritable.getArgument(1).(CompileTimeConstantExpr).getBooleanValue() = false and
    setWorldWritable = fileSetWritable and
    fileAccess = fileSetWritable.getQualifier()
  )
  or
  // Calls to `Files.setPosixFilePermissions(...)`.
  exists(MethodAccess setPosixPerms |
    setPosixPerms = setWorldWritable and
    setPosixPerms.getMethod().hasName("setPosixFilePermissions") and
    setPosixPerms.getMethod().getDeclaringType().hasQualifiedName("java.nio.file", "Files") and
    (
      fileAccess = setPosixPerms.getArgument(0)
      or
      // The argument was a file that has been converted to a path.
      fileAccess = getFileForPathConversion(setPosixPerms.getArgument(0))
    )
  |
    // The second argument is a set of `FilePermission`s.
    getAContainedEnumConstant(setPosixPerms.getArgument(1)).hasName("OTHERS_WRITE")
  )
  or
  // Calls to something that indirectly sets the file permissions.
  exists(Call call, int parameterPos, VarAccess nestedFileAccess, Expr nestedSetWorldWritable |
    call = setWorldWritable and
    fileSetWorldWritable(nestedFileAccess, nestedSetWorldWritable) and
    call.getCallee().getParameter(parameterPos) = nestedFileAccess.getVariable() and
    fileAccess = call.getArgument(parameterPos)
  )
}

/**
 * An expression that, directly or indirectly, makes the file argument world writable.
 */
class SetFileWorldWritable extends Expr {
  SetFileWorldWritable() { fileSetWorldWritable(_, this) }

  /**
   * Gets the `VarAccess` representing the file that is set world writable.
   */
  VarAccess getFileVarAccess() { fileSetWorldWritable(result, this) }
}
