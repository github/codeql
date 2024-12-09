private import javascript
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.DataFlowPrivate

/**
 * Gets a data-flow node synthesized using `AdditionalFlowInternal#needsSynthesizedNode`.
 */
DataFlow::Node getSynthesizedNode(AstNode node, string tag) {
  result = TGenericSynthesizedNode(node, tag, _)
}

DataFlowCallable getSynthesizedCallable(AstNode node, string tag) {
  result = MkGenericSynthesizedCallable(node, tag)
}

DataFlowCall getSynthesizedCall(AstNode node, string tag) {
  result = MkGenericSynthesizedCall(node, tag, _)
}

/**
 * An extension to `AdditionalFlowStep` with additional internal-only predicates.
 */
class AdditionalFlowInternal extends DataFlow::AdditionalFlowStep {
  /**
   * Holds if a data-flow node should be synthesized for the pair `(node, tag)`.
   *
   * The node can be obtained using `getSynthesizedNode(node, tag)`.
   *
   * `container` will be seen as the node's enclosing container.
   */
  predicate needsSynthesizedNode(AstNode node, string tag, DataFlowCallable container) { none() }

  predicate needsSynthesizedCallable(AstNode node, string tag) { none() }

  predicate needsSynthesizedCall(AstNode node, string tag, DataFlowCallable container) { none() }

  /**
   * Holds if `node` should only permit flow of values stored in `contents`.
   */
  predicate expectsContent(DataFlow::Node node, DataFlow::ContentSet contents) { none() }

  /**
   * Holds if `node` should not permit flow of values stored in `contents`.
   */
  predicate clearsContent(DataFlow::Node node, DataFlow::ContentSet contents) { none() }

  predicate argument(DataFlowCall call, ArgumentPosition pos, DataFlow::Node value) { none() }

  predicate postUpdate(DataFlow::Node pre, DataFlow::Node post) { none() }

  predicate viableCallable(DataFlowCall call, DataFlowCallable target) { none() }
}
