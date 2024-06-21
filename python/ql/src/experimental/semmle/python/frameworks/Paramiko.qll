/**
 * Provides classes modeling security-relevant aspects of the `paramiko` PyPI package.
 * See https://pypi.org/project/paramiko/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
import experimental.semmle.python.Concepts

/**
 * Provides models for the `paramiko` PyPI package.
 * See https://pypi.org/project/paramiko/.
 */
private module Paramiko {
  /**
   * Gets `paramiko` package.
   */
  private API::Node paramiko() { result = API::moduleImport("paramiko") }

  /**
   * Gets `paramiko.SSHClient` return value.
   */
  private API::Node paramikoClient() { result = paramiko().getMember("SSHClient").getReturn() }

  /**
   * The `exec_command` of `paramiko.SSHClient` class execute command on ssh target server
   */
  class ParamikoExecCommand extends RemoteCommandExecution::Range, API::CallNode {
    ParamikoExecCommand() { this = paramikoClient().getMember("exec_command").getACall() }

    override DataFlow::Node getCommand() { result = this.getParameter(0, "command").asSink() }
  }
}
