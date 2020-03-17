import javascript

query DataFlow::Node getPathArgument(FileSystemAccess access) { result = access.getAPathArgument() }

query DataFlow::Node getReadNode(FileSystemReadAccess access) { result = access.getADataNode() }

query DataFlow::Node getWriteNode(FileSystemWriteAccess access) { result = access.getADataNode() }
