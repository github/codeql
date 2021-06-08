/**
 * Provides classes representing sources of local input.
 */

import csharp
private import semmle.code.csharp.frameworks.system.windows.Forms

/** A data flow source of local data. */
abstract class LocalFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this local flow source. */
  abstract string getSourceType();
}

/** A data flow source of local user input. */
abstract class LocalUserInputSource extends LocalFlowSource { }

/** The text of a `TextBox`. */
class TextFieldSource extends LocalUserInputSource {
  TextFieldSource() { this.asExpr() = any(TextControl control).getARead() }

  override string getSourceType() { result = "TextBox text" }
}

/** A call to any `System.Console.Read*` method. */
class SystemConsoleReadSource extends LocalUserInputSource {
  SystemConsoleReadSource() {
    this.asExpr() =
      any(MethodCall call |
        call.getTarget().hasQualifiedName("System.Console", ["ReadLine", "Read", "ReadKey"])
      )
  }

  override string getSourceType() { result = "System.Console input" }
}
