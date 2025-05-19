/**
 * Provides classes representing sources of local input.
 */

import powershell
private import FlowSources

/** A data flow source of local data. */
abstract class LocalFlowSource extends SourceNode {
  override string getSourceType() { result = "local flow source" }

  override string getThreatModel() { result = "local" }
}

private class ExternalLocalFlowSource extends LocalFlowSource {
  ExternalLocalFlowSource() { this = ModelOutput::getASourceNode("local", _).asSource() }

  override string getSourceType() { result = "external" }
}

/** A data flow source of local user input. */
abstract class LocalUserInputSource extends LocalFlowSource { }

/**
 * A dataflow source that represents the access of an environment variable.
 */
abstract class EnvironmentVariableSource extends LocalFlowSource {
  override string getThreatModel() { result = "environment" }

  override string getSourceType() { result = "environment variable" }
}

private class EnvironmentVariableEnv extends EnvironmentVariableSource {
  EnvironmentVariableEnv() { this.asExpr().getExpr() instanceof EnvVariable }
}

private class ExternalEnvironmentVariableSource extends EnvironmentVariableSource {
  ExternalEnvironmentVariableSource() {
    this = ModelOutput::getASourceNode("environment", _).asSource()
  }
}

/**
 * A dataflow source that represents the access of a command line argument.
 */
abstract class CommandLineArgumentSource extends LocalFlowSource {
  override string getThreatModel() { result = "commandargs" }

  override string getSourceType() { result = "command line argument" }
}

private class ExternalCommandLineArgumentSource extends CommandLineArgumentSource {
  ExternalCommandLineArgumentSource() {
    this = ModelOutput::getASourceNode("command-line", _).asSource()
  }
}

/**
 * A data flow source that represents the parameters of the `Main` method of a program.
 */
private class MainMethodArgumentSource extends CommandLineArgumentSource {
  MainMethodArgumentSource() { this.asParameter().getFunction() instanceof TopLevelFunction }
}

/**
 * A data flow source that represents the access of a value from the Windows registry.
 */
abstract class WindowsRegistrySource extends LocalFlowSource {
  override string getThreatModel() { result = "windows-registry" }

  override string getSourceType() { result = "a value from the Windows registry" }
}

private class ExternalWindowsRegistrySource extends WindowsRegistrySource {
  ExternalWindowsRegistrySource() {
    this = ModelOutput::getASourceNode("windows-registry", _).asSource()
  }
}

/**
 * A dataflow source that represents the reading from stdin.
 */
abstract class StdinSource extends LocalFlowSource {
  override string getThreatModel() { result = "stdin" }

  override string getSourceType() { result = "read from stdin" }
}

private class ExternalStdinSource extends StdinSource {
  ExternalStdinSource() { this = ModelOutput::getASourceNode("stdin", _).asSource() }
}
