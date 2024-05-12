/**
 * Provides classes modeling security-relevant aspects of the `baize` PyPI package.
 *
 * See https://pypi.org/project/baize.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.Stdlib

/**
 * Provides models for `baize` PyPI package.
 *
 * See https://pypi.org/project/baize.
 */
module Baize {
  /**
   * A call to the `baize.asgi.FileResponse` constructor as a sink for Filesystem access.
   *
   * it is not contained to Starlette source code but it is mentioned in documents as an alternative to Starlette FileResponse
   */
  class BaizeFileResponseCall extends FileSystemAccess::Range, API::CallNode {
    BaizeFileResponseCall() {
      this = API::moduleImport("baize").getMember("asgi").getMember("FileResponse").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result = this.getParameter(0, "filepath").asSink()
    }
  }
}
