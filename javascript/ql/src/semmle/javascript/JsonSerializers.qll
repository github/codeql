/**
 * Provides classes for working with JSON serializers.
 */

import javascript

/**
 * A call to a JSON serializer such as `JSON.stringify` or `require("util").inspect`.
 */
class JsonSerializeCall extends DataFlow::CallNode {
  JsonSerializeCall() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      callee = DataFlow::globalVarRef("JSON").getAPropertyRead("stringify") or
      callee = DataFlow::moduleMember("json3", "stringify") or
      callee =
        DataFlow::moduleImport(["json-stringify-safe", "json-stable-stringify", "stringify-object",
              "fast-json-stable-stringify", "fast-safe-stringify", "javascript-stringify",
              "js-stringify"]) or
      // require("util").inspect() and similar
      callee = DataFlow::moduleMember("util", "inspect") or
      callee = DataFlow::moduleImport(["pretty-format", "object-inspect"])
    )
  }

  /**
   * Gets the data flow node holding the input object to be serialized.
   */
  DataFlow::Node getInput() { result = getArgument(0) }

  /**
   * Gets the data flow node holding the resulting string.
   */
  DataFlow::SourceNode getOutput() { result = this }
}
