import javascript

query predicate test_FileSystemAccess(FileSystemAccess access) { any() }

query predicate test_MissingFileSystemAccess(VarAccess var) {
  var.getName().matches("file%") and
  not exists(FileSystemAccess access | access.getAPathArgument().asExpr() = var)
}
