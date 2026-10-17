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

/** System arguments */
class MainMethodStringArgs extends LocalUserInputSource {
  MainMethodStringArgs() {
    exists(Method m, Parameter p |
      // Selects the main method of a C# class.
      m.hasName("Main") and
      m.isStatic() and
      m.getDeclaringType() instanceof Class and
      // Checks if the main method accepts a single argument of type 'string[]'.
      m.getParameter(0).getType() instanceof ArrayType and
      m.getParameter(0).getType().(ArrayType).getElementType() instanceof StringType and
      p = m.getParameter(0) and
      this.asExpr() = p.getAnAccess()
    )
  }

  override string getSourceType() { result = "Program arguments" }

}
