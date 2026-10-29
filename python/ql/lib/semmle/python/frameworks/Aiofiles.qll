/**
 * Provides classes modeling security-relevant aspects of the `aiofiles` PyPI package.
 *
 * See https://pypi.org/project/aiofiles.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `aiofiles` PyPI package.
 *
 * See https://pypi.org/project/aiofiles.
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
