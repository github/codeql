import codeql.ruby.Concepts
import codeql.ruby.DataFlow

query predicate fileSystemResolverAccesses(FileSystemAccess a, DataFlow::Node path) {
  a.getAPathArgument() = path
}
