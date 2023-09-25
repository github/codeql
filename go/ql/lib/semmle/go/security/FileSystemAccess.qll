import go


/**
 * The File system access sinks of `net/http` package
 */
class HttpServeFile extends FileSystemAccess::Range, DataFlow::CallNode {
  int pathArg;

  HttpServeFile() {
    exists(Function f |
      f.hasQualifiedName("net/http", "ServeFile") and
      this = f.getACall() and
      pathArg = 2
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
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
 * Provide File system access sinks of [beego](https://github.com/beego/beego) web framework
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

string aferoPackage() { result = "github.com/spf13/afero" }

/**
 * Provide File system access sinks of [afero](https://github.com/spf13/afero) filesystem framework
 * The Types that are not vulnerable: `afero.BasePathFs` and `afero.IOFS`
 */
class AferoSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  int pathArg;

  AferoSystemAccess() {
    // utility functions
    exists(Function f |
      f.hasQualifiedName(package(aferoPackage(), ""),
        ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"]) and
      this = f.getACall() and
      pathArg = 1
    )
    or
    // afero FS Types
    exists(Method f |
      f.hasQualifiedName(package(aferoPackage(), ""), "HttpFs",
        ["Create", "Open", "OpenFile", "Remove", "RemoveAll"]) and
      this = f.getACall() and
      pathArg = 0
      or
      f.hasQualifiedName(package(aferoPackage(), ""), "RegexpFs",
        ["Create", "Open", "OpenFile", "Remove", "RemoveAll", "Mkdir", "MkdirAll"]) and
      this = f.getACall() and
      pathArg = 0
      or
      f.hasQualifiedName(package(aferoPackage(), ""), "ReadOnlyFs",
        ["Create", "Open", "OpenFile", "ReadDir", "ReadlinkIfPossible", "Mkdir", "MkdirAll"]) and
      this = f.getACall() and
      pathArg = 0
      or
      f.hasQualifiedName(package(aferoPackage(), ""), "OsFs",
        [
          "Create", "Open", "OpenFile", "ReadlinkIfPossible", "Remove", "RemoveAll", "Mkdir",
          "MkdirAll"
        ]) and
      this = f.getACall() and
      pathArg = 0
      or
      f.hasQualifiedName(package(aferoPackage(), ""), "MemMapFs",
        ["Create", "Open", "OpenFile", "Remove", "RemoveAll", "Mkdir", "MkdirAll"]) and
      this = f.getACall() and
      pathArg = 0
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
}
