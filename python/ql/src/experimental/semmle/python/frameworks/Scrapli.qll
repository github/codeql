/**
 * Provides classes modeling security-relevant aspects of the `scrapli` PyPI package.
 * See https://pypi.org/project/scrapli/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
import experimental.semmle.python.security.SecondaryServerCmdInjectionCustomizations

/**
 * Provides models for the `scrapli` PyPI package.
 * See https://pypi.org/project/scrapli/.
 */
private module Scrapli {
  /**
   * Gets `scrapli` package.
   */
  private API::Node scrapli() { result = API::moduleImport("scrapli") }

  /**
   * Gets `scrapli.driver` package.
   */
  private API::Node scrapliDriver() { result = scrapli().getMember("driver") }

  /**
   * Gets `scrapli.driver.core` package.
   */
  private API::Node scrapliCore() { result = scrapliDriver().getMember("core") }

  /**
   * A `send_command` method responsible for executing commands on remote secondary servers.
   */
  class ScrapliSendCommand extends SecondaryCommandInjection::Sink {
    ScrapliSendCommand() {
      this =
        scrapliCore()
            .getMember([
                "AsyncNXOSDriver", "AsyncJunosDriver", "AsyncEOSDriver", "AsyncIOSXEDriver",
                "AsyncIOSXRDriver", "NXOSDriver", "JunosDriver", "EOSDriver", "IOSXEDriver",
                "IOSXRDriver"
              ])
            .getReturn()
            .getMember("send_command")
            .getACall()
            .getParameter(0, "command")
            .asSink()
      or
      this =
        scrapli()
            .getMember("Scrapli")
            .getReturn()
            .getMember("send_command")
            .getACall()
            .getParameter(0, "command")
            .asSink()
      or
      this =
        scrapliDriver()
            .getMember("GenericDriver")
            .getReturn()
            .getMember("send_command")
            .getACall()
            .getParameter(0, "command")
            .asSink()
    }
  }
}
