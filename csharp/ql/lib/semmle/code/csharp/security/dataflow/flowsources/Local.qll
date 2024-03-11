/**
 * Provides classes representing sources of local input.
 */

import csharp
private import semmle.code.csharp.frameworks.system.windows.Forms
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources

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
