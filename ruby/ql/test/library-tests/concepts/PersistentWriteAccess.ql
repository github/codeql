import codeql.ruby.DataFlow
import codeql.ruby.Concepts

query predicate persistentWriteAccesses(PersistentWriteAccess acc, DataFlow::Node value) {
  value = acc.getValue()
}
