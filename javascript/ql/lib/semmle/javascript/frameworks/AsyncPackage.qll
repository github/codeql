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
   * Gets `Limit` or `Series` name variants for a given member name.
   *
   * For example, `memberNameVariant("map")` returns `map`, `mapLimit`, and `mapSeries`.
   */
  bindingset[name]
  string memberNameVariant(string name) {
    result = name or
    result = name + "Limit" or
    result = name + "Series"
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
    DataFlow::ArrayCreationNode getTaskArray() { result.flowsTo(this.getArgument(0)) }

    /**
     * Gets the callback to invoke after the last task in the array completes.
     */
    DataFlow::FunctionNode getFinalCallback() { result.flowsTo(this.getArgument(1)) }

    /**
     * Gets the `n`th task, if it can be found.
     */
    DataFlow::FunctionNode getTask(int n) { result.flowsTo(this.getTaskArray().getElement(n)) }

    /**
     * Gets the number of tasks.
     */
    int getNumTasks() { result = strictcount(this.getTaskArray().getAnElement()) }
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
  private class WaterfallNextTaskCall extends DataFlow::PartialInvokeNode::Range, DataFlow::CallNode
  {
    Waterfall waterfall;
    int n;

    WaterfallNextTaskCall() { this = getLastParameter(waterfall.getTask(n)).getACall() }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      // Pass results to next task
      index >= 0 and
      argument = this.getArgument(index + 1) and
      callback = waterfall.getTask(n + 1)
      or
      // For the last task, pass results to the final callback
      index >= 1 and
      n = waterfall.getNumTasks() - 1 and
      argument = this.getArgument(index) and
      callback = waterfall.getFinalCallback()
      or
      // Always pass error to the final callback
      index = 0 and
      argument = this.getArgument(0) and
      callback = waterfall.getFinalCallback()
    }
  }

  /**
   * A call that iterates over a collection with asynchronous operations.
   */
  class IterationCall extends DataFlow::InvokeNode {
    string name;
    int iteratorCallbackIndex;
    int finalCallbackIndex;

    IterationCall() {
      (
        (
          name =
            memberNameVariant([
                "concat", "detect", "each", "eachOf", "forEach", "forEachOf", "every", "filter",
                "groupBy", "map", "mapValues", "reject", "some", "sortBy",
              ]) and
          if name.matches("%Limit")
          then (
            iteratorCallbackIndex = 2 and finalCallbackIndex = 3
          ) else (
            iteratorCallbackIndex = 1 and finalCallbackIndex = 2
          )
        )
        or
        name = ["reduce", "reduceRight", "transform"] and
        iteratorCallbackIndex = 2 and
        finalCallbackIndex = 3
      ) and
      this = member(name).getACall()
    }

    /**
     * Gets the name of the iteration call
     */
    string getName() { result = name }

    /**
     * Gets the iterator callback index
     */
    int getIteratorCallbackIndex() { result = iteratorCallbackIndex }

    /**
     * Gets the final callback index
     */
    int getFinalCallbackIndex() { result = finalCallbackIndex }

    /**
     * Gets the node holding the collection being iterated over.
     */
    DataFlow::Node getCollection() { result = this.getArgument(0) }

    /**
     * Gets the node holding the function being called for each element in the collection.
     */
    DataFlow::FunctionNode getIteratorCallback() {
      result = this.getCallback(iteratorCallbackIndex)
    }

    /**
     * Gets the node holding the function being invoked after iteration is complete. (may not exist)
     */
    DataFlow::FunctionNode getFinalCallback() { result = this.getCallback(finalCallbackIndex) }
  }

  /**
   * An IterationCall with its iterator callback at index 1
   */
  private class IterationCallCallbacksFirstArg extends IterationCall {
    IterationCallCallbacksFirstArg() { this.getIteratorCallbackIndex() = 1 }
  }

  /**
   * An IterationCall with its iterator callback at index 2
   */
  private class IterationCallCallbacksSecondArg extends IterationCall {
    IterationCallCallbacksSecondArg() { this.getIteratorCallbackIndex() = 2 }
  }

  /**
   * The model with the iteratorCallbackIndex abstracted
   */
  bindingset[iteratorCallbackIndex]
  private predicate iterationCallPropagatesFlow(
    string input, string output, boolean preservesValue, int iteratorCallbackIndex
  ) {
    preservesValue = true and
    input = "Argument[0]." + ["ArrayElement", "SetElement", "IteratorElement", "AnyMember"] and
    output = "Argument[" + iteratorCallbackIndex + "].Parameter[0]"
  }

  /**
   * A taint step from the collection into the iterator callback (at index 1) of an iteration call.
   *
   * For example: `data -> item` in `async.each(data, (item, cb) => {})`.
   */
  class IterationCallCallbacksFirstArgFlowSummary extends DataFlow::SummarizedCallable {
    IterationCallCallbacksFirstArgFlowSummary() { this = "async.[IterationCallCallbacksFirstArg]" }

    override DataFlow::InvokeNode getACallSimple() {
      result instanceof IterationCallCallbacksFirstArg
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      iterationCallPropagatesFlow(input, output, preservesValue, 1)
    }
  }

  /**
   * A taint step from the collection into the iterator callback (at index 2) of an iteration call.
   *
   * For example: `data -> item` in `async.eachLimit(data, 1, (item, cb) => {})`.
   */
  class IterationCallCallbacksSecondArgFlowSummary extends DataFlow::SummarizedCallable {
    IterationCallCallbacksSecondArgFlowSummary() { this = "async.[IterationCallCallbackSecondArg]" }

    override DataFlow::InvokeNode getACallSimple() {
      result instanceof IterationCallCallbacksSecondArg
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      iterationCallPropagatesFlow(input, output, preservesValue, 2)
    }
  }

  /**
   * A taint step from the return value of an iterator callback to the result of the iteration
   * call.
   *
   * For example: `item + taint() -> result` in `async.map(data, (item, cb) => cb(null, item + taint()), (err, result) => {})`.
   */
  private class IterationOutputTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(
        DataFlow::FunctionNode iteratee, DataFlow::FunctionNode final, int i, IterationCall call
      |
        iteratee = call.getIteratorCallback() and
        final = call.getFinalCallback() and // Require a closure to avoid spurious call/return mismatch.
        pred = getLastParameter(iteratee).getACall().getArgument(i) and
        succ = final.getParameter(i) and
        exists(string name | name = call.getName() |
          name = ["concat", "map", "reduce", "reduceRight"]
        )
      )
    }
  }

  /**
   * A taint step from the input of an iteration call, directly to its output.
   *
   * For example: `data -> result` in `async.sortBy(data, orderingFn, (err, result) => {})`.
   */
  class IterationPreserveTaintStepFlowSummary extends DataFlow::SummarizedCallable {
    IterationPreserveTaintStepFlowSummary() { this = "async.sortBy" }

    override DataFlow::InvokeNode getACallSimple() {
      result instanceof IterationCall and
      result.(IterationCall).getName() = "sortBy"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      preservesValue = false and
      input = "Argument[0]." + ["ArrayElement", "SetElement", "IteratorElement", "AnyMember"] and
      output = "Argument[2].Parameter[1]"
    }
  }
}
