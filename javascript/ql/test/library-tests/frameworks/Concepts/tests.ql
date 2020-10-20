import javascript

query DataFlow::Node getPathArgument(FileSystemAccess access) { result = access.getAPathArgument() }

query DataFlow::Node getReadNode(FileSystemReadAccess access) { result = access.getADataNode() }

query DataFlow::Node getWriteNode(FileSystemWriteAccess access) { result = access.getADataNode() }

query predicate fileNameSource(FileNameSource s) { any() }

query predicate persistentReadAccess_getAWrite(
  PersistentReadAccess read, PersistentWriteAccess write
) {
  write = read.getAWrite()
}

query predicate persistentReadAccess(PersistentReadAccess read) { any() }

query predicate persistentWriteAccess(PersistentWriteAccess write, DataFlow::Node value) {
  value = write.getValue()
}
