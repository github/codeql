/**
 * Provides classes for working the `github.com/gofiber/fiber` package.
 */

import go

private module Fiber {
  /** Gets the package name `github.com/gofiber/fiber`. */
  string packagePath() { result = package("github.com/gofiber/fiber", "") }

  /** Gets the v2 module path `github.com/gofiber/fiber/v2` */
  string v2modulePath() { result = "github.com/gofiber/fiber/v2" }

  /**
   * The File system access sinks
   */
  class FsOperations extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathArg;

    FsOperations() {
      exists(Method m |
        (
          m.hasQualifiedName(packagePath(), "Ctx", ["SendFile", "Download"]) and
          pathArg = 0
          or
          m.hasQualifiedName(packagePath(), "Ctx", "SaveFile") and
          pathArg = 1
          or
          m.hasQualifiedName(v2modulePath(), "Ctx", "SaveFileToStorage") and
          pathArg = 1
        ) and
        this = m.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
  }
}
