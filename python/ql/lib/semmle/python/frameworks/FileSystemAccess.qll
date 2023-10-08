/**
 * Provides classes modeling security-relevant aspects of the I/O file write or file read operations
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `aiofile` PyPI package.
 * See https://github.com/agronholm/anyio.
 */
private module Aiofile {
  /**
   * A call to the `async_open` function or `AIOFile` constructor from `aiofile` as a sink for Filesystem access.
   */
  class FileResponseCall extends FileSystemAccess::Range, API::CallNode {
    string methodName;

    FileResponseCall() {
      this = API::moduleImport("aiofile").getMember("async_open").getACall() and
      methodName = "async_open"
      or
      this = API::moduleImport("aiofile").getMember("AIOFile").getACall() and
      methodName = "AIOFile"
    }

    override DataFlow::Node getAPathArgument() {
      result = this.getParameter(0, "file_specifier").asSink() and
      methodName = "async_open"
      or
      result = this.getParameter(0, "filename").asSink() and
      methodName = "AIOFile"
    }
  }
}

/**
 * Provides models for the `aiofiles` PyPI package.
 * See https://github.com/Tinche/aiofiles.
 */
private module Aiofiles {
  /**
   * A call to the `open` function from `aiofiles` as a sink for Filesystem access.
   */
  class FileResponseCall extends FileSystemAccess::Range, API::CallNode {
    FileResponseCall() { this = API::moduleImport("aiofiles").getMember("open").getACall() }

    override DataFlow::Node getAPathArgument() { result = this.getParameter(0, "file").asSink() }
  }
}

/**
 * Provides models for the `anyio` PyPI package.
 * See https://github.com/agronholm/anyio.
 */
private module Anyio {
  /**
   * A call to the `from_path` function from `FileReadStream` or `FileWriteStream` constructors of `anyio.streams.file` as a sink for Filesystem access.
   */
  class FileStreamCall extends FileSystemAccess::Range, API::CallNode {
    FileStreamCall() {
      this =
        API::moduleImport("anyio")
            .getMember("streams")
            .getMember("file")
            .getMember(["FileReadStream", "FileWriteStream"])
            .getMember("from_path")
            .getACall()
    }

    override DataFlow::Node getAPathArgument() { result = this.getParameter(0, "path").asSink() }
  }

  /**
   * A call to the `Path` constructor from `anyio` as a sink for Filesystem access.
   */
  class PathCall extends FileSystemAccess::Range, API::CallNode {
    PathCall() { this = API::moduleImport("anyio").getMember("Path").getACall() }

    override DataFlow::Node getAPathArgument() { result = this.getParameter(0).asSink() }
  }

  /**
   * A call to the `open_file` function from `anyio` as a sink for Filesystem access.
   */
  class OpenFileCall extends FileSystemAccess::Range, API::CallNode {
    OpenFileCall() { this = API::moduleImport("anyio").getMember("open_file").getACall() }

    override DataFlow::Node getAPathArgument() { result = this.getParameter(0, "file").asSink() }
  }
}
