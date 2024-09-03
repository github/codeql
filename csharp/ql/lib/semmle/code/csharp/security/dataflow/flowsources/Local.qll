/**
 * Provides classes representing sources of local input.
 */

import csharp
private import semmle.code.csharp.frameworks.system.windows.Forms
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.commons.Util

/** A data flow source of local data. */
abstract class LocalFlowSource extends SourceNode {
  override string getSourceType() { result = "local flow source" }

  override string getThreatModel() { result = "local" }
}

private class ExternalLocalFlowSource extends LocalFlowSource {
  ExternalLocalFlowSource() { sourceNode(this, "local") }

  override string getSourceType() { result = "external" }
}

/** A data flow source of local user input. */
abstract class LocalUserInputSource extends LocalFlowSource { }

/** The text of a `TextBox`. */
class TextFieldSource extends LocalUserInputSource {
  TextFieldSource() { this.asExpr() = any(TextControl control).getARead() }

  override string getSourceType() { result = "TextBox text" }
}

/**
 * A dataflow source that represents the access of an environment variable.
 */
abstract class EnvironmentVariableSource extends LocalFlowSource {
  override string getThreatModel() { result = "environment" }

  override string getSourceType() { result = "environment variable" }
}

private class ExternalEnvironmentVariableSource extends EnvironmentVariableSource {
  ExternalEnvironmentVariableSource() { sourceNode(this, "environment") }
}

/**
 * A dataflow source that represents the access of a command line argument.
 */
abstract class CommandLineArgumentSource extends LocalFlowSource {
  override string getThreatModel() { result = "commandargs" }

  override string getSourceType() { result = "command line argument" }
}

private class ExternalCommandLineArgumentSource extends CommandLineArgumentSource {
  ExternalCommandLineArgumentSource() { sourceNode(this, "command-line") }
}

/**
 * A data flow source that represents the parameters of the `Main` method of a program.
 */
private class MainMethodArgumentSource extends CommandLineArgumentSource {
  MainMethodArgumentSource() { this.asParameter() = any(MainMethod mainMethod).getAParameter() }
}

/**
 * A data flow source that represents the access of a value from the Windows registry.
 */
abstract class WindowsRegistrySource extends LocalFlowSource {
  override string getThreatModel() { result = "windows-registry" }

  override string getSourceType() { result = "a value from the Windows registry" }
}

private class ExternalWindowsRegistrySource extends WindowsRegistrySource {
  ExternalWindowsRegistrySource() { sourceNode(this, "windows-registry") }
}

/**
 * A dataflow source that represents the reading from stdin.
 */
abstract class StdinSource extends LocalFlowSource {
  override string getThreatModel() { result = "stdin" }

  override string getSourceType() { result = "read from stdin" }
}

private class ExternalStdinSource extends StdinSource {
  ExternalStdinSource() { sourceNode(this, "stdin") }
}
