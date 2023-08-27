import go

class FastHttpFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  FastHttpFileSystemAccess() {
    exists(DataFlow::Method mcn |
      (
        mcn.hasQualifiedName("github.com/valyala/fasthttp.RequestCtx", ["SendFileBytes", "SendFile"]) or
        mcn.hasQualifiedName("github.com/valyala/fasthttp.Response", ["SendFile"])
      ) and
      this = mcn.getACall()
    )
    or
    exists(DataFlow::Function f |
      f.hasQualifiedName("github.com/valyala/fasthttp",
        [
          "ServeFile", "ServeFileUncompressed", "ServeFileBytes", "ServeFileBytesUncompressed",
          "SaveMultipartFile"
        ]) and
      this = f.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() {
    this.getTarget().getName() =
      [
        "ServeFile", "ServeFileUncompressed", "ServeFileBytes", "ServeFileBytesUncompressed",
        "SaveMultipartFile"
      ] and
    result = this.getArgument(1)
    or
    this.getTarget().getName() = ["SendFile", "SendFileBytes"] and
    result = this.getArgument(0)
  }
}

class HttpServeFile extends FileSystemAccess::Range, DataFlow::CallNode {
  HttpServeFile() {
    exists(DataFlow::Function mcn |
      mcn.hasQualifiedName("net/http", "ServeFile") and
      this = mcn.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(2) }
}

class BeegoFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  BeegoFileSystemAccess() {
    exists(DataFlow::Method mcn |
      (
        mcn.hasQualifiedName("github.com/beego/beego/v2/server/web/context.BeegoOutput", "Download") or
        mcn.hasQualifiedName("github.com/beego/beego/v2/server/web.Controller",
          "SaveToFileWithBuffer")
      ) and
      this = mcn.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() {
    this.getTarget()
        .hasQualifiedName("github.com/beego/beego/v2/server/web/context.BeegoOutput", "Download") and
    result = this.getArgument(0)
    or
    this.getTarget()
        .hasQualifiedName("github.com/beego/beego/v2/server/web.Controller", "SaveToFileWithBuffer") and
    result = this.getArgument(1)
  }
}

class EchoFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  EchoFileSystemAccess() {
    exists(DataFlow::Method mcn |
      mcn.hasQualifiedName("github.com/labstack/echo/v4.Context", ["Attachment", "File"]) and
      this = mcn.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
}

class GinFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  GinFileSystemAccess() {
    exists(DataFlow::Method mcn |
      mcn.hasQualifiedName("github.com/gin-gonic/gin.Context",
        ["File", "FileAttachment", "SaveUploadedFile"]) and
      this = mcn.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() {
    this.getTarget().getName() = ["File", "FileAttachment"] and result = this.getArgument(0)
    or
    this.getTarget().getName() = "SaveUploadedFile" and result = this.getArgument(1)
  }
}

class IrisFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  IrisFileSystemAccess() {
    exists(DataFlow::Method mcn |
      mcn.hasQualifiedName("github.com/kataras/iris/v12/context.Context",
        ["SendFile", "ServeFile", "SendFileWithRate", "ServeFileWithRate", "UploadFormFiles"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/kataras/iris/v12/context.Context", "SaveFormFile") and
      this = mcn.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() {
    this.getTarget().getName() =
      ["SendFile", "ServeFile", "SendFileWithRate", "ServeFileWithRate", "UploadFormFiles"] and
    result = this.getArgument(0)
    or
    this.getTarget().getName() = "SaveFormFile" and result = this.getArgument(1)
  }
}

class FiberSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  FiberSystemAccess() {
    exists(DataFlow::Method mcn |
      mcn.hasQualifiedName("github.com/gofiber/fiber/v2.Ctx", ["Attachment", "SendFile"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/gofiber/fiber/v2.Ctx", "SaveFile") and
      this = mcn.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() {
    this.getTarget().getName() = ["Attachment", "SendFile"] and result = this.getArgument(0)
    or
    this.getTarget().getName() = "SaveFile" and result = this.getArgument(1)
  }
}

class AferoSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  AferoSystemAccess() {
    exists(DataFlow::Function mcn |
      mcn.hasQualifiedName("github.com/spf13/afero",
        ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero", "Open") and
      this = mcn.getACall()
    )
    or
    exists(DataFlow::Function mcn |
      mcn.hasQualifiedName("github.com/spf13/afero",
        ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero", "Open") and
      this = mcn.getACall()
    )
    or
    exists(DataFlow::Method mcn |
      mcn.hasQualifiedName("github.com/spf13/afero.Afero",
        ["ReadFile", "ReadDir", "WriteReader", "WriteFile", "SafeWriteReader"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero.HttpFs", ["Open", "OpenFile", "Create"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero.RegexpFs",
        ["Create", "Open", "Remove", "OpenFile"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero.ReadOnlyFs",
        ["Create", "Open", "Remove", "OpenFile", "ReadDir", "ReadlinkIfPossible"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero.OsFs",
        ["Create", "Open", "Remove", "RemoveAll", "OpenFile", "ReadDir", "ReadlinkIfPossible"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero.OsFs",
        ["Create", "Open", "Remove", "RemoveAll", "OpenFile", "ReadDir", "ReadlinkIfPossible"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero.MemMapFs",
        ["Create", "Open", "OpenFile", "Remove", "RemoveAll"]) and
      this = mcn.getACall()
      or
      mcn.hasQualifiedName("github.com/spf13/afero.BasePathFs",
        ["Create", "Open", "OpenFile", "Remove", "RemoveAll", "ReadlinkIfPossible"]) and
      this = mcn.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() {
    if
      this.getTarget()
          .hasQualifiedName("github.com/spf13/afero",
            ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"]) or
      this.getTarget()
          .hasQualifiedName("github.com/spf13/afero",
            ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"])
    then result = this.getArgument(1)
    else result = this.getArgument(0)
  }
}
