/**
 * Provides classes representing sources of local input.
 */

import csharp
private import semmle.code.csharp.frameworks.system.windows.Forms
private import semmle.code.csharp.dataflow.ExternalFlow

/** A data flow source of local data. */
abstract class LocalFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this local flow source. */
  abstract string getSourceType();
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

/** A call to any `System.Console.Read*` method. */
private class SystemConsoleReadSourceModelCsv extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "System;Console;false;ReadLine;;;ReturnValue;local",
        "System;Console;false;Read;;;ReturnValue;local",
        "System;Console;false;ReadKey;;;ReturnValue;local"
      ]
  }
}
