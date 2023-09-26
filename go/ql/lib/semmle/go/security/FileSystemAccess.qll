import go

/**
 * The File system access sinks of `net/http` package
 */
class HttpServeFile extends FileSystemAccess::Range, DataFlow::CallNode {
  HttpServeFile() {
    exists(Function f |
      f.hasQualifiedName("net/http", "ServeFile") and
      this = f.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(2) }
}

/**
 * The File system access sinks of [beego](https://github.com/beego/beego) web framework
 */
class BeegoFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  int pathArg;

  BeegoFileSystemAccess() {
    exists(Method m |
      (
        m.hasQualifiedName(package("github.com/beego/beego", "server/web/context"), "BeegoOutput",
          "Download") and
        pathArg = 0
        or
        m.hasQualifiedName(package("github.com/beego/beego", "server/web"), "Controller",
          "SaveToFileWithBuffer") and
        pathArg = 1
      ) and
      this = m.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
}

/**
 * The File system access sinks of [beego](https://github.com/beego/beego) web framework
 */
class EchoFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  int pathArg;

  EchoFileSystemAccess() {
    exists(Method m |
      m.hasQualifiedName(package("github.com/labstack/echo", ""), "Context", ["Attachment", "File"]) and
      this = m.getACall() and
      pathArg = 0
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
}

/**
 * The File system access sinks of [gin](https://github.com/gin-gonic/gin) web framework
 */
class GinFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  int pathArg;

  GinFileSystemAccess() {
    exists(Method m |
      (
        m.hasQualifiedName(package("github.com/gin-gonic/gin", ""), "Context",
          ["File", "FileAttachment"]) and
        pathArg = 0
        or
        m.hasQualifiedName(package("github.com/gin-gonic/gin", ""), "Context", "SaveUploadedFile") and
        pathArg = 1
      ) and
      this = m.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
}

/**
 * The File system access sinks of [iris](https://github.com/kataras/iris) web framework
 */
class IrisFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  int pathArg;

  IrisFileSystemAccess() {
    exists(Method m |
      (
        m.hasQualifiedName(package("github.com/kataras/iris", "context"), "Context",
          ["SendFile", "ServeFile", "SendFileWithRate", "ServeFileWithRate", "UploadFormFiles"]) and
        pathArg = 0
        or
        m.hasQualifiedName(package("github.com/kataras/iris", "context"), "Context", "SaveFormFile") and
        pathArg = 1
      ) and
      this = m.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
}

/**
 * The File system access sinks of [fiber](https://github.com/gofiber/fiber) web framework
 */
class FiberSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  int pathArg;

  FiberSystemAccess() {
    exists(Method m |
      (
        m.hasQualifiedName(package("github.com/gofiber/fiber", ""), "Ctx", "SendFile") and
        pathArg = 0
        or
        m.hasQualifiedName(package("github.com/gofiber/fiber", ""), "Ctx", "SaveFile") and
        pathArg = 1
      ) and
      this = m.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
}

/**
 * Provide File system access sinks of [afero](https://github.com/spf13/afero) framework
 */
module Afero {
  string aferoPackage() { result = package("github.com/spf13/afero", "") }

  /**
   * The File system access sinks of [afero](https://github.com/spf13/afero) framework methods
   */
  class AferoSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    AferoSystemAccess() {
      exists(Method f |
        f.hasQualifiedName(aferoPackage(), "HttpFs",
          ["Create", "Open", "OpenFile", "Remove", "RemoveAll"]) and
        this = f.getACall()
        or
        f.hasQualifiedName(aferoPackage(), "RegexpFs",
          ["Create", "Open", "OpenFile", "Remove", "RemoveAll", "Mkdir", "MkdirAll"]) and
        this = f.getACall()
        or
        f.hasQualifiedName(aferoPackage(), "ReadOnlyFs",
          ["Create", "Open", "OpenFile", "ReadDir", "ReadlinkIfPossible", "Mkdir", "MkdirAll"]) and
        this = f.getACall()
        or
        f.hasQualifiedName(aferoPackage(), "OsFs",
          [
            "Create", "Open", "OpenFile", "ReadlinkIfPossible", "Remove", "RemoveAll", "Mkdir",
            "MkdirAll"
          ]) and
        this = f.getACall()
        or
        f.hasQualifiedName(aferoPackage(), "MemMapFs",
          ["Create", "Open", "OpenFile", "Remove", "RemoveAll", "Mkdir", "MkdirAll"]) and
        this = f.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
  }

  /**
   * The File system access sinks of [afero](https://github.com/spf13/afero) framework utility functions
   *
   * The Types that are not vulnerable: `afero.BasePathFs` and `afero.IOFS`
   */
  class AferoUtilityFunctionSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    AferoUtilityFunctionSystemAccess() {
      // utility functions
      exists(Function f |
        f.hasQualifiedName(aferoPackage(),
          ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"]) and
        this = f.getACall() and
        not aferoSanitizer(this.getArgument(0))
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(1) }
  }

  /**
   * Holds if the Afero utility function has a first argument of a safe type like `NewBasePathFs`.
   *
   * e.g.
   * ```
   * basePathFs := afero.NewBasePathFs(osFS, "tmp")
   * afero.ReadFile(basePathFs, filepath)
   * ```
   */
  predicate aferoSanitizer(DataFlow::Node n) {
    exists(Function f |
      f.hasQualifiedName(aferoPackage(), "NewBasePathFs") and
      DataFlow::localFlow(f.getACall(), n)
    )
  }

  /**
   * Holds if there is a dataflow node from n1 to n2 when initializing the Afero instance
   *
   * A helper for `aferoSanitizer` for when the Afero instance is initialized with one of the safe FS types like IOFS
   *
   * e.g.`n2 := &afero.Afero{Fs: afero.NewBasePathFs(osFS, "./")}` n1 is `afero.NewBasePathFs(osFS, "./")`
   */
  predicate additionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(StructLit st | st.getType().hasQualifiedName(aferoPackage(), "Afero") |
      n1.asExpr() = st.getAChildExpr().(KeyValueExpr).getAChildExpr() and
      n2.asExpr() = st
    )
  }
}
