/**
 * Provides classes modeling security-relevant aspects of the `ssh2-python` PyPI package.
 * See https://pypi.org/project/ssh2-python/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
import experimental.semmle.python.Concepts

/**
 * Provides models for the `ssh2-python` PyPI package.
 * See https://pypi.org/project/ssh2-python/.
 */
private module Ssh2 {
  /**
   * Gets `ssh2` package.
   */
  private API::Node ssh2() { result = API::moduleImport("ssh2") }

  /**
   * Gets `ssh2.session.Session` return value.
   */
  private API::Node ssh2Session() {
    result = ssh2().getMember("session").getMember("Session").getReturn()
  }

  /**
   * An `execute` method responsible for executing commands on remote secondary servers.
   */
  class Ssh2Execute extends RemoteCommandExecution::Range, API::CallNode {
    Ssh2Execute() {
      this = ssh2Session().getMember("open_session").getReturn().getMember("execute").getACall()
    }

    override DataFlow::Node getCommand() { result = this.getParameter(0, "command").asSink() }
  }
}
