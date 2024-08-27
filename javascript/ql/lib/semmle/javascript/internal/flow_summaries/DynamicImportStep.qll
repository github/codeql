/**
 * Contains flow steps to model flow from a module into a dynamic `import()` expression.
 */

private import javascript
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.internal.DataFlowPrivate

/**
 * Flow steps for dynamic import expressions.
 *
 * The default export of the imported module must be boxed in a promise, so we pass
 * it through a synthetic node.
 */
class DynamicImportStep extends AdditionalFlowInternal {
  override predicate needsSynthesizedNode(AstNode node, string tag, DataFlowCallable container) {
    node instanceof DynamicImportExpr and
    tag = "imported-value" and
    container.asSourceCallable() = node.getContainer()
  }

  override predicate jumpStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DynamicImportExpr expr |
      pred = expr.getImportedModule().getAnExportedValue("default") and
      succ = getSynthesizedNode(expr, "imported-value")
    )
  }

  override predicate storeStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(DynamicImportExpr expr |
      pred = getSynthesizedNode(expr, "imported-value") and
      contents = DataFlow::ContentSet::promiseValue() and
      succ = TValueNode(expr)
    )
  }
}
