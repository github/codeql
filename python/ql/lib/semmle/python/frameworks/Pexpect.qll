/**
 * Provides classes modeling security-relevant aspects of the `pexpect` PyPI package.
 * See https://pypi.org/project/pexpect/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `pexpect` PyPI package.
 * See https://pypi.org/project/pexpect/.
 */
private module Pexpect {
  /**
   * The calls to `pexpect.*` functions that execute commands
   * See https://pexpect.readthedocs.io/en/stable/api/pexpect.html#pexpect.spawn
   * See https://pexpect.readthedocs.io/en/stable/api/pexpect.html#pexpect.run
   */
  class PexpectCommandExec extends SystemCommandExecution::Range, API::CallNode {
    PexpectCommandExec() {
      this = API::moduleImport("pexpect").getMember(["run", "runu", "spawn", "spawnu"]).getACall()
    }

    override DataFlow::Node getCommand() { result = this.getParameter(0, "command").asSink() }

    override predicate isShellInterpreted(DataFlow::Node arg) { none() }
  }

  /**
   * A call to `pexpect.popen_spawn.PopenSpawn`
   * See https://pexpect.readthedocs.io/en/stable/api/popen_spawn.html#pexpect.popen_spawn.PopenSpawn
   */
  class PexpectPopenSpawn extends SystemCommandExecution::Range, API::CallNode {
    PexpectPopenSpawn() {
      this =
        API::moduleImport("pexpect").getMember("popen_spawn").getMember("PopenSpawn").getACall()
    }

    override DataFlow::Node getCommand() { result = this.getParameter(0, "cmd").asSink() }

    override predicate isShellInterpreted(DataFlow::Node arg) { none() }
  }
}
