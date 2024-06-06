/**
 * Provides classes modeling security-relevant aspects of the `sanic` PyPI package.
 * See https://sanic.dev/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `sanic` PyPI package.
 * See https://sanic.dev/.
 */
private module Sanic {
  /**
   * Provides models for Sanic applications (an instance of `sanic.Sanic`).
   */
  module App {
    /** Gets a reference to a Sanic application (an instance of `sanic.Sanic`). */
    API::Node instance() { result = API::moduleImport("sanic").getMember("Sanic").getReturn() }
  }

  /**
   * A call to the `file` or `file_stream` functions of `sanic.response` as a sink for Filesystem access.
   */
  class FileResponseCall extends FileSystemAccess::Range, API::CallNode {
    FileResponseCall() {
      this =
        API::moduleImport("sanic")
            .getMember("response")
            .getMember(["file", "file_stream"])
            .getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result = this.getParameter(0, "location").asSink()
    }
  }
}
