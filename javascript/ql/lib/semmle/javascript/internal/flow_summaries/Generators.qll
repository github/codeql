/**
 * Contains flow steps to model flow through generator functions.
 */

private import javascript
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal

/**
 * Steps modelling flow out of a generator function:
 * ```js
 * function* foo() {
 *   yield x;  // store 'x' in the return value's IteratorElement
 *   yield* y; // flow directly to return value, which has expectsContent, so only iterator contents can pass through.
 *   throw z;  // store 'z' in the return value's IteratorError
 * }
 * ```
 */
class GeneratorFunctionStep extends AdditionalFlowInternal {
  override predicate expectsContent(DataFlow::Node node, DataFlow::ContentSet contents) {
    // Ensure that the return value can only return iterator contents. This is needed for 'yield*'.
    exists(Function fun |
      fun.isGenerator() and
      node = TFunctionReturnNode(fun) and
      contents = DataFlow::ContentSet::iteratorFilter()
    )
  }

  override predicate storeStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    // `yield x`. Store into the return value's iterator element.
    exists(Function fun, YieldExpr yield | fun.isGenerator() |
      not yield.isDelegating() and
      yield.getContainer() = fun and
      pred = yield.getOperand().flow() and
      contents = DataFlow::ContentSet::iteratorElement() and
      succ = TFunctionReturnNode(fun)
    )
    or
    exists(Function f | f.isGenerator() |
      // Store thrown exceptions in the iterator-error
      pred = TExceptionalFunctionReturnNode(f) and
      succ = TFunctionReturnNode(f) and
      contents = DataFlow::ContentSet::iteratorError()
    )
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    // `yield* x`. Flow into the return value, which has expectsContent, so only iterator contents can pass through.
    exists(Function fun, YieldExpr yield |
      fun.isGenerator() and
      yield.getContainer() = fun and
      yield.isDelegating() and
      pred = yield.getOperand().flow() and
      succ = TFunctionReturnNode(fun)
    )
  }
}
