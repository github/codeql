/**
 * Provides classes modeling security-relevant aspects of the `cherrypy` PyPI package.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `cherrypy` PyPI package.
 * See https://cherrypy.dev/.
 */
private module Cherrypy {
  /**
   * Holds for an instance of `cherrypy.lib.static`
   */
  API::Node libStatic() {
    result = API::moduleImport("cherrypy").getMember("lib").getMember("static")
  }

  /**
   * A call to the `serve_file` or `serve_download`or `staticfile` functions of `cherrypy.lib.static` as a sink for Filesystem access.
   */
  class FileResponseCall extends FileSystemAccess::Range, API::CallNode {
    string funcName;

    FileResponseCall() {
      this = libStatic().getMember("staticfile").getACall() and
      funcName = "staticfile"
      or
      this = libStatic().getMember("serve_file").getACall() and
      funcName = "serve_file"
      or
      this = libStatic().getMember("serve_download").getACall() and
      funcName = "serve_download"
    }

    override DataFlow::Node getAPathArgument() {
      result = this.getParameter(0, "path").asSink() and funcName = ["serve_download", "serve_file"]
      or
      result = this.getParameter(0, "filename").asSink() and
      funcName = "staticfile"
    }
  }
}
