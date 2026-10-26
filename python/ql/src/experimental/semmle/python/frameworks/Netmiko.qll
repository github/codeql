/**
 * Provides classes modeling security-relevant aspects of the `netmiko` PyPI package.
 * See https://pypi.org/project/netmiko/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
import experimental.semmle.python.Concepts

/**
 * Provides models for the `netmiko` PyPI package.
 * See https://pypi.org/project/netmiko/.
 */
private module Netmiko {
  /**
   * Gets `netmiko` package.
   */
  private API::Node netmiko() { result = API::moduleImport("netmiko") }

  /**
   * Gets `netmiko.ConnectHandler` return value.
   */
  private API::Node netmikoConnectHandler() {
    result = netmiko().getMember("ConnectHandler").getReturn()
  }

  /**
   * The `send_*` methods responsible for executing commands on remote secondary servers.
   */
  class NetmikoSendCommand extends RemoteCommandExecution::Range, API::CallNode {
    boolean isMultiline;

    NetmikoSendCommand() {
      this =
        netmikoConnectHandler()
            .getMember(["send_command", "send_command_expect", "send_command_timing"])
            .getACall() and
      isMultiline = false
      or
      this =
        netmikoConnectHandler().getMember(["send_multiline", "send_multiline_timing"]).getACall() and
      isMultiline = true
    }

    override DataFlow::Node getCommand() {
      result = this.getParameter(0, "command_string").asSink() and
      isMultiline = false
      or
      result = this.getParameter(0, "commands").asSink() and
      isMultiline = true
    }
  }
}
