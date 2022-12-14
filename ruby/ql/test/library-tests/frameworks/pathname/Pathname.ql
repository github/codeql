private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.stdlib.Pathname

query predicate pathnameInstances(Pathname::PathnameInstance i) { any() }

query predicate fileSystemAccesses(FileSystemAccess a, DataFlow::Node p) {
  p = a.getAPathArgument()
}

query predicate fileNameSources(FileNameSource s) { any() }

query predicate fileSystemReadAccesses(FileSystemReadAccess a, DataFlow::Node d) {
  d = a.getADataNode()
}

query predicate fileSystemWriteAccesses(FileSystemWriteAccess a, DataFlow::Node d) {
  d = a.getADataNode()
}

query predicate fileSystemPermissionModifications(
  FileSystemPermissionModification m, DataFlow::Node p
) {
  p = m.getAPermissionNode()
}
