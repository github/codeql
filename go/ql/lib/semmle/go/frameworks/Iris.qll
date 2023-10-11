/**
 * Provides classes for working the `github.com/kataras/iris` package.
 */

import go

private module Iris {
  /** Gets the v1 module path `github.com/kataras/iris`. */
  string v1modulePath() { result = "github.com/kataras/iris" }

  /** Gets the v12 module path `github.com/kataras/iris/v12` */
  string v12modulePath() { result = "github.com/kataras/iris/v12" }

  /** Gets the path for the context package of all versions of beego. */
  string contextPackagePath() {
    result = v12contextPackagePath()
    or
    result = v1contextPackagePath()
  }

  /** Gets the path for the context package of beego v12. */
  string v12contextPackagePath() { result = v12modulePath() + "/context" }

  /** Gets the path for the context package of beego v1. */
  string v1contextPackagePath() { result = v1modulePath() + "/server/web/context" }

  /**
   * The File system access sinks
   */
  class FsOperations extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathArg;

    FsOperations() {
      exists(Method m |
        (
          m.hasQualifiedName(contextPackagePath(), "Context",
            ["SendFile", "ServeFile", "SendFileWithRate", "ServeFileWithRate", "UploadFormFiles"]) and
          pathArg = 0
          or
          m.hasQualifiedName(v12contextPackagePath(), "Context", "SaveFormFile") and
          pathArg = 1
        ) and
        this = m.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
  }
}
