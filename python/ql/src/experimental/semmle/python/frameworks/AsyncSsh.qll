/**
 * Provides classes modeling security-relevant aspects of the `asyncssh` PyPI package.
 * See https://pypi.org/project/asyncssh/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
import experimental.semmle.python.Concepts

/**
 * Provides models for the `asyncssh` PyPI package.
 * See https://pypi.org/project/asyncssh/.
 */
private module Asyncssh {
  /**
   * Gets `asyncssh` package.
   */
  private API::Node asyncssh() { result = API::moduleImport("asyncssh") }

  /**
   * A `run` method responsible for executing commands on remote secondary servers.
   */
  class AsyncsshRun extends RemoteCommandExecution::Range, API::CallNode {
    AsyncsshRun() { this = asyncssh().getMember("connect").getReturn().getMember("run").getACall() }

    override DataFlow::Node getCommand() { result = this.getParameter(0, "command").asSink() }
  }
}
