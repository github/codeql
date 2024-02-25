/**
 * Provides classes modeling security-relevant aspects of the `paramiko` PyPI package.
 * See https://pypi.org/project/paramiko/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
import experimental.semmle.python.security.SecondaryServerCmdInjectionCustomizations

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
  class ParamikoExecCommand extends SecondaryCommandInjection::Sink {
    ParamikoExecCommand() {
      this =
        paramikoClient().getMember("exec_command").getACall().getParameter(0, "command").asSink()
    }
  }
}
