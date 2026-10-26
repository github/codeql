/**
 * Provides classes modeling security-relevant aspects of the `twisted` PyPI package.
 * See https://twistedmatrix.com/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
import experimental.semmle.python.Concepts

/**
 * Provides models for the `twisted` PyPI package.
 * See https://docs.twistedmatrix.com/en/stable/api/twisted.conch.endpoints.SSHCommandClientEndpoint.html
 */
private module Twisted {
  /**
   * The `newConnection` and `existingConnection` functions of `twisted.conch.endpoints.SSHCommandClientEndpoint` class execute command on ssh target server
   */
  class ParamikoExecCommand extends RemoteCommandExecution::Range, API::CallNode {
    ParamikoExecCommand() {
      this =
        API::moduleImport("twisted")
            .getMember("conch")
            .getMember("endpoints")
            .getMember("SSHCommandClientEndpoint")
            .getMember(["newConnection", "existingConnection"])
            .getACall()
    }

    override DataFlow::Node getCommand() { result = this.getParameter(1, "command").asSink() }
  }
}
