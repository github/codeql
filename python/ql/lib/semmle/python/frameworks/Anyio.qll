/**
 * Provides classes modeling security-relevant aspects of the `anyio` PyPI package.
 *
 * See https://pypi.org/project/anyio.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `anyio` PyPI package.
 *
 * See https://pypi.org/project/anyio.
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
