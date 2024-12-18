/**
 * Provides classes modeling security-relevant aspects of the `paramiko` PyPI package.
 * See https://pypi.org/project/paramiko/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `paramiko` PyPI package.
 * See https://pypi.org/project/paramiko/.
 */
private module Paramiko {
  /**
   * The first argument of `paramiko.ProxyCommand`.
   *
   * the `paramiko.ProxyCommand` is equivalent of `ssh -o ProxyCommand="CMD"`
   * which runs `CMD` on the local system.
   * See https://paramiko.pydata.org/docs/reference/api/paramiko.eval.html
   */
  class ParamikoProxyCommand extends SystemCommandExecution::Range, API::CallNode {
    ParamikoProxyCommand() {
      this = API::moduleImport("paramiko").getMember("ProxyCommand").getACall()
    }

    override DataFlow::Node getCommand() { result = this.getParameter(0, "command_line").asSink() }

    override predicate isShellInterpreted(DataFlow::Node arg) { none() }
  }
}
