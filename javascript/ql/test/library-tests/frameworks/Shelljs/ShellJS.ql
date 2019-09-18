import javascript

query predicate test_FileSystemAccess(FileSystemAccess access) { any() }

query predicate test_MissingFileSystemAccess(VarAccess var) {
  var.getName().matches("file%") and
  not exists(FileSystemAccess access | access.getAPathArgument().asExpr() = var)
}

query predicate test_SystemCommandExecution(SystemCommandExecution exec) { any() }

query predicate test_FileNameSource(FileNameSource exec) { any() }
