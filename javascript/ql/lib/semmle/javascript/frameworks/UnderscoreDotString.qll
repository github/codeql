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
   * Holds if a call to an Underscore.string method clears array element content of the receiver.
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
