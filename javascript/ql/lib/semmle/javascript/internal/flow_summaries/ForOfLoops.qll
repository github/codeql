/**
 * Contains flow steps to model flow through `for..of` loops.
 */

private import javascript
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.internal.DataFlowPrivate

class ForOfLoopStep extends AdditionalFlowInternal {
  override predicate needsSynthesizedNode(AstNode node, string tag, DataFlowCallable container) {
    // Intermediate nodes to convert (MapKey, MapValue) to a `[key, value]` array.
    //
    // For the loop `for (let lvalue of domain)` we generate the following steps:
    //
    //      domain --- READ[MapKey]   ---> synthetic node 1 --- STORE[0] ---> lvalue
    //      domain --- READ[MapValue] ---> synthetic node 2 --- STORE[1] ---> lvalue
    //
    node instanceof ForOfStmt and
    tag = ["for-of-map-key", "for-of-map-value"] and
    container.asSourceCallable() = node.getContainer()
  }

  override predicate readStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(ForOfStmt stmt | pred = stmt.getIterationDomain().flow() |
      contents =
        [
          DataFlow::ContentSet::arrayElement(), DataFlow::ContentSet::setElement(),
          DataFlow::ContentSet::iteratorElement()
        ] and
      succ = DataFlow::lvalueNode(stmt.getLValue())
      or
      contents = DataFlow::ContentSet::mapKey() and
      succ = getSynthesizedNode(stmt, "for-of-map-key")
      or
      contents = DataFlow::ContentSet::mapValueAll() and
      succ = getSynthesizedNode(stmt, "for-of-map-value")
      or
      contents = DataFlow::ContentSet::iteratorError() and
      succ = stmt.getIterationDomain().getExceptionTarget()
    )
  }

  override predicate storeStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(ForOfStmt stmt |
      pred = getSynthesizedNode(stmt, "for-of-map-key") and
      contents.asSingleton().asArrayIndex() = 0
      or
      pred = getSynthesizedNode(stmt, "for-of-map-value") and
      contents.asSingleton().asArrayIndex() = 1
    |
      succ = DataFlow::lvalueNode(stmt.getLValue())
    )
  }
}
