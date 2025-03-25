/**
 * Provides classes for modeling data flow behavior of the Underscore.string library (https://www.npmjs.com/package/underscore.string).
 */

private import javascript
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal

/**
 * Models data flow for the Underscore.string library.
 */
private class UnderscoreDotString extends AdditionalFlowInternal {
  /**
   * Some of the methods in `underscore.string` have the same name as methods from `Array.prototype`.
   * This prevents methods like `splice` from propagating into Argument[this].ArrayElement.
   */
  override predicate clearsContent(DataFlow::Node node, DataFlow::ContentSet contents) {
    exists(DataFlow::CallNode call |
      call =
        ModelOutput::getATypeNode(["'underscore.string'.Wrapper", "'underscore.string'"])
            .getAMember()
            .getACall() and
      node = call.getReceiver().getPostUpdateNode() and
      contents = DataFlow::ContentSet::arrayElement()
    )
  }
}
