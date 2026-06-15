/**
 * Provides classes modeling security-relevant aspects of the `aiofile` PyPI package.
 *
 * See https://pypi.org/project/aiofile.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `aiofile` PyPI package.
 *
 * See https://pypi.org/project/aiofile.
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
