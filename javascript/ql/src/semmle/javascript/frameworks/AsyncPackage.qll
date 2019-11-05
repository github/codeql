/**
 * Provides classes for working with [async](https://www.npmjs.com/package/async).
 */

import javascript

module AsyncPackage {
  /**
   * Gets a reference the given member of the `async` or `async-es` package.
   */
  pragma[noopt]
  DataFlow::SourceNode member(string name) {
    result = DataFlow::moduleMember("async", name) or
    result = DataFlow::moduleMember("async-es", name)
  }

  /**
   * Gets a reference to the given member or one of its `Limit` or `Series` variants.
   *
   * For example, `memberVariant("map")` finds references to `map`, `mapLimit`, and `mapSeries`.
   */
  DataFlow::SourceNode memberVariant(string name) {
    result = member(name) or
    result = member(name + "Limit") or
    result = member(name + "Series")
  }

  /**
   * A call to `async.waterfall`.
   */
  class Waterfall extends DataFlow::InvokeNode {
    Waterfall() {
      this = member("waterfall").getACall() or
      this = DataFlow::moduleImport("a-sync-waterfall").getACall()
    }

    /**
     * Gets the array of tasks, if it can be found.
     */
    DataFlow::ArrayCreationNode getTaskArray() { result.flowsTo(getArgument(0)) }

    /**
     * Gets the callback to invoke after the last task in the array completes.
     */
    DataFlow::FunctionNode getFinalCallback() { result.flowsTo(getArgument(1)) }

    /**
     * Gets the `n`th task, if it can be found.
     */
    DataFlow::FunctionNode getTask(int n) { result.flowsTo(getTaskArray().getElement(n)) }

    /**
     * Gets the number of tasks.
     */
    int getNumTasks() { result = strictcount(getTaskArray().getAnElement()) }
  }

  /**
   * Gets the last parameter declared by the given function, unless that's a rest parameter.
   */
  private DataFlow::ParameterNode getLastParameter(DataFlow::FunctionNode function) {
    not function.hasRestParameter() and
    result = function.getParameter(function.getNumParameter() - 1)
  }

  /**
   * An invocation of the callback in a waterfall task, passing arguments to the next waterfall task.
   *
   * Such a callback has the form `callback(err, result1, result2, ...)`. The error is propagated
   * to the first parameter of the final callback, while `result1, result2, ...` are propagated to
   * the parameters of the following task.
   */
  private class WaterfallNextTaskCall extends DataFlow::PartialInvokeNode::Range, DataFlow::CallNode {
    Waterfall waterfall;
    int n;

    WaterfallNextTaskCall() { this = getLastParameter(waterfall.getTask(n)).getACall() }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      // Pass results to next task
      index >= 0 and
      argument = getArgument(index + 1) and
      callback = waterfall.getTask(n + 1)
      or
      // For the last task, pass results to the final callback
      index >= 1 and
      n = waterfall.getNumTasks() - 1 and
      argument = getArgument(index) and
      callback = waterfall.getFinalCallback()
      or
      // Always pass error to the final callback
      index = 0 and
      argument = getArgument(0) and
      callback = waterfall.getFinalCallback()
    }
  }

  /**
   * A call that iterates over a collection with asynchronous operations.
   */
  class IterationCall extends DataFlow::InvokeNode {
    string name;

    IterationCall() {
      this = memberVariant(name).getACall() and
      (
        name = "concat" or
        name = "detect" or
        name = "each" or
        name = "eachOf" or
        name = "forEach" or
        name = "forEachOf" or
        name = "every" or
        name = "filter" or
        name = "groupBy" or
        name = "map" or
        name = "mapValues" or
        name = "reduce" or
        name = "reduceRight" or
        name = "reject" or
        name = "some" or
        name = "sortBy" or
        name = "transform"
      )
    }

    /**
     * Gets the name of the iteration call, without the `Limit` or `Series` suffix.
     */
    string getName() { result = name }

    /**
     * Gets the node holding the collection being iterated over.
     */
    DataFlow::Node getCollection() { result = getArgument(0) }

    /**
     * Gets the node holding the function being called for each element in the collection.
     */
    DataFlow::Node getIteratorCallback() { result = getArgument(getNumArgument() - 2) }

    /**
     * Gets the node holding the function being invoked after iteration is complete.
     */
    DataFlow::Node getFinalCallback() { result = getArgument(getNumArgument() - 1) }
  }

  /**
   * A taint step from the collection into the iterator callback of an iteration call.
   *
   * For example: `data -> item` in `async.each(data, (item, cb) => {})`.
   */
  private class IterationInputTaintStep extends TaintTracking::AdditionalTaintStep, IterationCall {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::FunctionNode iteratee |
        iteratee = getIteratorCallback() and // Require a closure to avoid spurious call/return mismatch.
        pred = getCollection() and
        succ = iteratee.getParameter(0)
      )
    }
  }

  /**
   * A taint step from the return value of an iterator callback to the result of the iteration
   * call.
   *
   * For example: `item + taint()` -> result` in `async.map(data, (item, cb) => cb(null, item + taint()), (err, result) => {})`.
   */
  private class IterationOutputTaintStep extends TaintTracking::AdditionalTaintStep, IterationCall {
    IterationOutputTaintStep() {
      name = "concat" or
      name = "map" or
      name = "reduce" or
      name = "reduceRight"
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::FunctionNode iteratee, DataFlow::FunctionNode final, int i |
        iteratee = getIteratorCallback().getALocalSource() and
        final = getFinalCallback() and // Require a closure to avoid spurious call/return mismatch.
        pred = getLastParameter(iteratee).getACall().getArgument(i) and
        succ = final.getParameter(i)
      )
    }
  }

  /**
   * A taint step from the input of an iteration call, directly to its output.
   *
   * For example: `data -> result` in `async.sortBy(data, orderingFn, (err, result) => {})`.
   */
  private class IterationPreserveTaintStep extends TaintTracking::AdditionalTaintStep, IterationCall {
    IterationPreserveTaintStep() {
      name = "sortBy"
      // We don't currently include `filter` and `reject` as they could act as sanitizers.
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::FunctionNode final |
        final = getFinalCallback() and // Require a closure to avoid spurious call/return mismatch.
        pred = getCollection() and
        succ = final.getParameter(1)
      )
    }
  }
}
