/**
 * Provides classes for working with JSON parsers.
 */

import javascript

/**
 * A call to a JSON parser such as `JSON.parse`.
 */
abstract class JsonParserCall extends DataFlow::CallNode {
  /**
   * Gets the data flow node holding the input string to be parsed.
   */
  abstract DataFlow::Node getInput();

  /**
   * Gets the data flow node holding the resulting JSON object.
   */
  abstract DataFlow::SourceNode getOutput();
}

/**
 * A JSON parser that returns its result.
 */
private class PlainJsonParserCall extends JsonParserCall {
  PlainJsonParserCall() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      callee = DataFlow::globalVarRef("JSON").getAPropertyRead("parse") or
      callee = DataFlow::moduleImport("parse-json") or
      callee = DataFlow::moduleImport("json-parse-better-errors") or
      callee = DataFlow::moduleImport("json-safe-parse") or
      callee = AngularJS::angular().getAPropertyRead("fromJson")
    )
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::SourceNode getOutput() { result = this }
}

/**
 * A JSON parser that returns its result wrapped in a another object.
 */
private class JsonParserCallWithWrapper extends JsonParserCall {
  string outputPropName;

  JsonParserCallWithWrapper() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      callee = DataFlow::moduleImport("safe-json-parse/tuple") and outputPropName = "1"
      or
      callee = DataFlow::moduleImport("safe-json-parse/result") and outputPropName = "v"
      or
      callee = DataFlow::moduleImport("fast-json-parse") and outputPropName = "value"
      or
      callee = DataFlow::moduleImport("json-parse-safe") and outputPropName = "value"
    )
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::SourceNode getOutput() { result = this.getAPropertyRead(outputPropName) }
}

/**
 * A JSON parser that returns its result through a callback argument.
 */
private class JsonParserCallWithCallback extends JsonParserCall {
  JsonParserCallWithCallback() {
    this = DataFlow::moduleImport("safe-json-parse/callback").getACall()
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::SourceNode getOutput() { result = getCallback(1).getParameter(1) }
}
