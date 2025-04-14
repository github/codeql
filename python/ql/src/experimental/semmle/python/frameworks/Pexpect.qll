/**
 * Provides classes modeling security-relevant aspects of the `pexpect` PyPI package.
 * See https://pypi.org/project/pexpect/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.ApiGraphs
import experimental.semmle.python.Concepts

/**
 * Provides models for the `pexpect` PyPI package.
 * See https://pypi.org/project/pexpect/.
 */
private module Pexpect {
  /**
   * The calls to `pexpect.pxssh.pxssh` functions that execute commands
   * See https://pexpect.readthedocs.io/en/stable/api/pxssh.html
   */
  class PexpectCommandExec extends RemoteCommandExecution::Range, API::CallNode {
    PexpectCommandExec() {
      this =
        API::moduleImport("pexpect")
            .getMember("pxssh")
            .getMember("pxssh")
            .getReturn()
            .getMember(["send", "sendline"])
            .getACall()
    }

    override DataFlow::Node getCommand() { result = this.getParameter(0, "s").asSink() }
  }
}
