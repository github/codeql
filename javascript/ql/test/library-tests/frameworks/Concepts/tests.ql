import javascript

query DataFlow::Node getPathArgument(FileAccess access) { result = access.getAPathArgument() }

query DataFlow::Node getReadNode(FileReadAccess access) { result = access.getADataNode() }

query DataFlow::Node getWriteNode(FileWriteAccess access) { result = access.getADataNode() }

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
