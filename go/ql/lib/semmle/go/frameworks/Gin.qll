/**
 * Provides classes for working with the `github.com/gin-gonic/gin` package.
 */

import go

private module Gin {
  /** Gets the package name `github.com/gin-gonic/gin`. */
  string packagePath() { result = package("github.com/gin-gonic/gin", "") }

  /**
   * The File system access sinks
   */
  class FsOperations extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathArg;

    FsOperations() {
      exists(Method m |
        (
          m.hasQualifiedName(packagePath(), "Context", ["File", "FileAttachment"]) and
          pathArg = 0
          or
          m.hasQualifiedName(packagePath(), "Context", "SaveUploadedFile") and
          pathArg = 1
        ) and
        this = m.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
  }
}
