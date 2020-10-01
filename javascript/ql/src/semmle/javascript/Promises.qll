/**
 * Provides classes for modelling promises and their data-flow.
 */

import javascript
private import dataflow.internal.StepSummary

/**
 * A definition of a `Promise` object.
 */
abstract class PromiseDefinition extends DataFlow::SourceNode {
  /** Gets the executor function of this promise object. */
  abstract DataFlow::FunctionNode getExecutor();

  /** Gets the `resolve` parameter of the executor function. */
  DataFlow::ParameterNode getResolveParameter() { result = getExecutor().getParameter(0) }

  /** Gets the `reject` parameter of the executor function. */
  DataFlow::ParameterNode getRejectParameter() { result = getExecutor().getParameter(1) }

  /** Gets the `i`th callback handler installed by method `m`. */
  private DataFlow::FunctionNode getAHandler(string m, int i) {
    result = getAMethodCall(m).getCallback(i)
  }

  /**
   * Gets a function that handles promise resolution, including both
   * `then` handlers and `finally` handlers.
   */
  DataFlow::FunctionNode getAResolveHandler() {
    result = getAHandler("then", 0) or
    result = getAFinallyHandler()
  }

  /**
   * Gets a function that handles promise rejection, including
   * `then` handlers, `catch` handlers and `finally` handlers.
   */
  DataFlow::FunctionNode getARejectHandler() {
    result = getAHandler("then", 1) or
    result = getACatchHandler() or
    result = getAFinallyHandler()
  }

  /**
   * Gets a `catch` handler of this promise.
   */
  DataFlow::FunctionNode getACatchHandler() { result = getAHandler("catch", 0) }

  /**
   * Gets a `finally` handler of this promise.
   */
  DataFlow::FunctionNode getAFinallyHandler() { result = getAHandler("finally", 0) }
}

/** Holds if the `i`th callback handler is installed by method `m`. */
private predicate hasHandler(DataFlow::InvokeNode promise, string m, int i) {
  exists(promise.getAMethodCall(m).getCallback(i))
}

/**
 * A call that looks like a Promise.
 *
 * For example, this could be the call `promise(f).then(function(v){...})`
 */
class PromiseCandidate extends DataFlow::InvokeNode {
  PromiseCandidate() {
    hasHandler(this, "then", [0 .. 1]) or
    hasHandler(this, "catch", 0) or
    hasHandler(this, "finally", 0)
  }
}

/**
 * A promise object created by the standard ECMAScript 2015 `Promise` constructor.
 */
private class ES2015PromiseDefinition extends PromiseDefinition, DataFlow::NewNode {
  ES2015PromiseDefinition() { this = DataFlow::globalVarRef("Promise").getAnInstantiation() }

  override DataFlow::FunctionNode getExecutor() { result = getCallback(0) }
}

/**
 * A promise that is created and resolved with one or more value.
 */
abstract class PromiseCreationCall extends DataFlow::CallNode {
  /**
   * Gets a value this promise is resolved with.
   */
  abstract DataFlow::Node getValue();
}

/**
 * A promise that is created using a `.resolve()` call.
 */
abstract class ResolvedPromiseDefinition extends PromiseCreationCall { }

/**
 * A promise that is created using a `Promise.all(array)` call.
 */
abstract class PromiseAllCreation extends PromiseCreationCall {
  /**
   * Gets a node for the array of values given to the `Promise.all(array)` call.
   */
  abstract DataFlow::Node getArrayNode();
}

/**
 * A resolved promise created by the standard ECMAScript 2015 `Promise.resolve` function.
 */
class ResolvedES2015PromiseDefinition extends ResolvedPromiseDefinition {
  ResolvedES2015PromiseDefinition() {
    this = DataFlow::globalVarRef("Promise").getAMemberCall("resolve")
  }

  override DataFlow::Node getValue() { result = getArgument(0) }
}

/**
 * An aggregated promise produced either by `Promise.all`, `Promise.race`, or `Promise.any`.
 */
class AggregateES2015PromiseDefinition extends PromiseCreationCall {
  AggregateES2015PromiseDefinition() {
    exists(string m | m = "all" or m = "race" or m = "any" |
      this = DataFlow::globalVarRef("Promise").getAMemberCall(m)
    )
  }

  override DataFlow::Node getValue() {
    result = getArgument(0).getALocalSource().(DataFlow::ArrayCreationNode).getAnElement()
  }
}

/**
 * An aggregated promise created using `Promise.all()`.
 */
class ES2015PromiseAllDefinition extends AggregateES2015PromiseDefinition, PromiseAllCreation {
  ES2015PromiseAllDefinition() { this.getCalleeName() = "all" }

  override DataFlow::Node getArrayNode() { result = getArgument(0) }
}

/**
 * Common predicates shared between type-tracking and data-flow for promises.
 */
module Promises {
  /**
   * Gets the pseudo-field used to describe resolved values in a promise.
   */
  string valueProp() { result = "$PromiseResolveField$" }

  /**
   * Gets the pseudo-field used to describe rejected values in a promise.
   */
  string errorProp() { result = "$PromiseRejectField$" }
}

/**
 * A module for supporting promises in type-tracking predicates.
 * The `PromiseTypeTracking::promiseStep` predicate is used for type tracking in and out of promises,
 * and is included in the standard type-tracking steps (`SourceNode::track`).
 * The `TypeTracker::startInPromise()` predicate can be used to initiate a type-tracker
 * where the tracked value is a promise.
 *
 * The below is an example of a type-tracking predicate where the initial value is a promise:
 * ```
 * DataFlow::SourceNode myType(DataFlow::TypeTracker t) {
 *  t.startInPromise() and
 *  result = <the promise value> and
 *  or
 *  exists(DataFlow::TypeTracker t2 | result = myType(t2).track(t2, t))
 * }
 * ```
 *
 * The type-tracking predicate above will only end (`t = DataFlow::TypeTracker::end()`) after the tracked value has been
 * extracted from the promise.
 *
 * The `PromiseTypeTracking::promiseStep` predicate can be used instead of `SourceNode::track`
 * to get type-tracking only for promise steps.
 *
 * Replace `t.startInPromise()` in the above example with `t.start()` to create a type-tracking predicate
 * where the value is not initially inside a promise.
 */
module PromiseTypeTracking {
  /**
   * Gets the result from a single step through a promise, from `pred` to `result` summarized by `summary`.
   * This can be loading a resolved value from a promise, storing a value in a promise, or copying a resolved value from one promise to another.
   *
   * These type-tracking steps are already included in the default type-tracking steps (through `PreCallGraphStep`).
   */
  pragma[inline]
  DataFlow::Node promiseStep(DataFlow::Node pred, StepSummary summary) {
    exists(string field | field = Promises::valueProp() |
      summary = LoadStep(field) and
      PromiseFlow::loadStep(pred, result, field)
      or
      summary = StoreStep(field) and
      PromiseFlow::storeStep(pred, result, field)
      or
      summary = CopyStep(field) and
      PromiseFlow::loadStoreStep(pred, result, field)
    )
  }

  /**
   * Gets the result from a single step through a promise, from `pred` with tracker `t2` to `result` with tracker `t`.
   * This can be loading a resolved value from a promise, storing a value in a promise, or copying a resolved value from one promise to another.
   */
  pragma[inline]
  DataFlow::SourceNode promiseStep(
    DataFlow::SourceNode pred, DataFlow::TypeTracker t, DataFlow::TypeTracker t2
  ) {
    exists(DataFlow::Node mid, StepSummary summary | pred.flowsTo(mid) and t = t2.append(summary) |
      result = PromiseTypeTracking::promiseStep(mid, summary)
    )
  }

  /**
   * A class enabling the use of the `resolveField` as a pseudo-property in type-tracking predicates.
   */
  private class ResolveFieldAsTypeTrackingProperty extends TypeTrackingPseudoProperty {
    ResolveFieldAsTypeTrackingProperty() { this = Promises::valueProp() }
  }
}

private import semmle.javascript.dataflow.internal.PreCallGraphStep

/**
 * A step related to promises.
 *
 * These steps are for `await p`, `new Promise()`, `Promise.resolve()`,
 * `Promise.then()`, `Promise.catch()`, and `Promise.finally()`.
 */
private class PromiseStep extends PreCallGraphStep {
  override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
    PromiseFlow::loadStep(obj, element, prop)
  }

  override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
    PromiseFlow::storeStep(element, obj, prop)
  }

  override predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    PromiseFlow::loadStoreStep(pred, succ, prop)
  }
}

/**
 * This module defines how data-flow propagates into and out of a Promise.
 * The data-flow is based on pseudo-properties rather than tainting the Promise object (which is what `PromiseTaintStep` does).
 */
module PromiseFlow {
  private predicate valueProp = Promises::valueProp/0;

  private predicate errorProp = Promises::errorProp/0;

  /**
   * Holds if there is a step for loading a `value` from a `promise`.
   * `prop` is either `valueProp()` if the value is a resolved value, or `errorProp()` if the promise has been rejected.
   */
  predicate loadStep(DataFlow::Node promise, DataFlow::Node value, string prop) {
    // await promise.
    exists(AwaitExpr await | await.getOperand() = promise.asExpr() |
      prop = valueProp() and
      value.asExpr() = await
      or
      prop = errorProp() and
      value = await.getExceptionTarget()
    )
    or
    // promise.then()
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = "then" and promise = call.getReceiver()
    |
      prop = valueProp() and
      value = call.getCallback(0).getParameter(0)
      or
      prop = errorProp() and
      value = call.getCallback(1).getParameter(0)
    )
    or
    // promise.catch()
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "catch" |
      prop = errorProp() and
      promise = call.getReceiver() and
      value = call.getCallback(0).getParameter(0)
    )
  }

  /**
   * Holds if there is a step for storing a `value` into a promise `obj`.
   * `prop` is either `valueProp()` if the value is a resolved value, or `errorProp()` if the promise has been rejected.
   */
  predicate storeStep(DataFlow::Node value, DataFlow::SourceNode obj, string prop) {
    // promise definition, e.g. `new Promise()`
    exists(PromiseDefinition promise | obj = promise |
      prop = valueProp() and
      value = promise.getResolveParameter().getACall().getArgument(0)
      or
      prop = errorProp() and
      value =
        [promise.getRejectParameter().getACall().getArgument(0),
            promise.getExecutor().getExceptionalReturn()]
    )
    or
    // promise creation call, e.g. `Promise.resolve`.
    exists(PromiseCreationCall promise | obj = promise |
      not promise instanceof PromiseAllCreation and
      prop = valueProp() and
      value = promise.getValue()
      or
      prop = valueProp() and
      value = promise.(PromiseAllCreation).getArrayNode()
    )
    or
    // promise.then()
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "then" and obj = call |
      prop = valueProp() and
      value = call.getCallback([0 .. 1]).getAReturn()
      or
      prop = errorProp() and
      value = call.getCallback([0 .. 1]).getExceptionalReturn()
    )
    or
    // promise.catch()
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "catch" and obj = call |
      prop = errorProp() and
      value = call.getCallback(0).getExceptionalReturn()
      or
      prop = valueProp() and
      value = call.getCallback(0).getAReturn()
    )
    or
    // promise.finally()
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "finally" |
      prop = errorProp() and
      value = call.getCallback(0).getExceptionalReturn() and
      obj = call
    )
  }

  /**
   * Holds if there is a step copying a resolved/rejected promise value from promise `pred` to promise `succ`.
   * `prop` is either `valueProp()` if the value is a resolved value, or `errorProp()` if the promise has been rejected.
   */
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    // promise definition, e.g. `new Promise()`
    exists(PromiseDefinition promise | succ = promise |
      // Copy the value of a resolved promise to the value of this promise.
      prop = valueProp() and
      pred = promise.getResolveParameter().getACall().getArgument(0)
    )
    or
    // promise creation call, e.g. `Promise.resolve`.
    exists(PromiseCreationCall promise | succ = promise |
      // Copy the value of a resolved promise to the value of this promise.
      not promise instanceof PromiseAllCreation and
      pred = promise.getValue() and
      prop = valueProp()
      or
      pred = promise.(PromiseAllCreation).getArrayNode() and
      prop = valueProp()
    )
    or
    // promise.then()
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "then" and succ = call |
      not exists(call.getArgument(1)) and
      prop = errorProp() and
      pred = call.getReceiver()
      or
      // read the value of a resolved/rejected promise that is returned
      (prop = errorProp() or prop = valueProp()) and
      pred = call.getCallback([0 .. 1]).getAReturn()
    )
    or
    // promise.catch()
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "catch" and succ = call |
      prop = valueProp() and
      pred = call.getReceiver()
      or
      // read the value of a resolved/rejected promise that is returned
      (prop = errorProp() or prop = valueProp()) and
      pred = call.getCallback(0).getAReturn()
    )
    or
    // promise.finally()
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "finally" and succ = call |
      (prop = valueProp() or prop = errorProp()) and
      pred = call.getReceiver()
      or
      // read the value of a rejected promise that is returned
      prop = errorProp() and
      pred = call.getCallback(0).getAReturn()
    )
  }
}

/**
 * Holds if taint propagates from `pred` to `succ` through promises.
 */
predicate promiseTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  // from `x` to `new Promise((res, rej) => res(x))`
  pred = succ.(PromiseDefinition).getResolveParameter().getACall().getArgument(0)
  or
  // from `x` to `Promise.resolve(x)`
  pred = succ.(PromiseCreationCall).getValue() and
  not succ instanceof PromiseAllCreation
  or
  // from `arr` to `Promise.all(arr)`
  pred = succ.(PromiseAllCreation).getArrayNode()
  or
  exists(DataFlow::MethodCallNode thn | thn.getMethodName() = "then" |
    // from `p` to `x` in `p.then(x => ...)`
    pred = thn.getReceiver() and
    succ = thn.getCallback(0).getParameter(0)
    or
    // from `v` to `p.then(x => return v)`
    pred = thn.getCallback([0 .. 1]).getAReturn() and
    succ = thn
  )
  or
  exists(DataFlow::MethodCallNode catch | catch.getMethodName() = "catch" |
    // from `p` to `p.catch(..)`
    pred = catch.getReceiver() and
    succ = catch
    or
    // from `v` to `p.catch(x => return v)`
    pred = catch.getCallback(0).getAReturn() and
    succ = catch
  )
  or
  // from `p` to `p.finally(..)`
  exists(DataFlow::MethodCallNode finally | finally.getMethodName() = "finally" |
    pred = finally.getReceiver() and
    succ = finally
  )
  or
  // from `x` to `await x`
  exists(AwaitExpr await |
    pred.getEnclosingExpr() = await.getOperand() and
    succ.getEnclosingExpr() = await
  )
  or
  exists(DataFlow::CallNode mapSeries |
    mapSeries = DataFlow::moduleMember("bluebird", "mapSeries").getACall()
  |
    // from `xs` to `x` in `require("bluebird").mapSeries(xs, (x) => {...})`.
    pred = mapSeries.getArgument(0) and
    succ = mapSeries.getABoundCallbackParameter(1, 0)
    or
    // from `y` to `require("bluebird").mapSeries(x, x => y)`.
    pred = mapSeries.getCallback(1).getAReturn() and
    succ = mapSeries
  )
}

/**
 * An additional taint step that involves promises.
 */
private class PromiseTaintStep extends TaintTracking::AdditionalTaintStep {
  DataFlow::Node source;

  PromiseTaintStep() { promiseTaintStep(source, this) }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = source and succ = this
  }
}

/**
 * Defines flow steps for return on async functions.
 */
private module AsyncReturnSteps {
  private predicate valueProp = Promises::valueProp/0;

  private predicate errorProp = Promises::errorProp/0;

  private import semmle.javascript.dataflow.internal.FlowSteps

  /**
   * A data-flow step for ordinary and exceptional returns from async functions.
   */
  private class AsyncReturn extends PreCallGraphStep {
    override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      exists(DataFlow::FunctionNode f | f.getFunction().isAsync() |
        // ordinary return
        prop = valueProp() and
        pred = f.getAReturn() and
        succ = f.getReturnNode()
        or
        // exceptional return
        prop = errorProp() and
        localExceptionStepWithAsyncFlag(pred, succ, true)
      )
    }
  }

  /**
   * A data-flow step for ordinary return from an async function in a taint configuration.
   */
  private class AsyncTaintReturn extends TaintTracking::AdditionalTaintStep, DataFlow::FunctionNode {
    Function f;

    AsyncTaintReturn() { this.getFunction() = f and f.isAsync() }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      returnExpr(f, pred, _) and
      succ.(DataFlow::FunctionReturnNode).getFunction() = f
    }
  }
}

/**
 * Provides classes for working with the `bluebird` library (http://bluebirdjs.com).
 */
module Bluebird {
  private DataFlow::SourceNode bluebird() {
    result = DataFlow::globalVarRef("Promise") or // same as ES2015PromiseDefinition!
    result = DataFlow::moduleImport("bluebird")
  }

  /**
   * A promise object created by the bluebird `Promise` constructor.
   */
  private class BluebirdPromiseDefinition extends PromiseDefinition, DataFlow::NewNode {
    BluebirdPromiseDefinition() { this = bluebird().getAnInstantiation() }

    override DataFlow::FunctionNode getExecutor() { result = getCallback(0) }
  }

  /**
   * A resolved promise created by the bluebird `Promise.resolve` function.
   */
  class ResolvedBluebidPromiseDefinition extends ResolvedPromiseDefinition {
    ResolvedBluebidPromiseDefinition() { this = bluebird().getAMemberCall("resolve") }

    override DataFlow::Node getValue() { result = getArgument(0) }
  }

  /**
   * An aggregated promise produced either by `Promise.all`, `Promise.race` or `Promise.map`.
   */
  class AggregateBluebirdPromiseDefinition extends PromiseCreationCall {
    AggregateBluebirdPromiseDefinition() {
      exists(string m | m = "all" or m = "race" or m = "map" | this = bluebird().getAMemberCall(m))
    }

    override DataFlow::Node getValue() {
      result = getArgument(0).getALocalSource().(DataFlow::ArrayCreationNode).getAnElement()
    }
  }

  /**
   * A promise created using `Promise.all`:
   */
  class BluebirdPromiseAllDefinition extends AggregateBluebirdPromiseDefinition, PromiseAllCreation {
    BluebirdPromiseAllDefinition() { this.getCalleeName() = "all" }

    override DataFlow::Node getArrayNode() { result = getArgument(0) }
  }

  /**
   * An async function created using a call to `bluebird.coroutine`.
   */
  class BluebirdCoroutineDefinition extends DataFlow::CallNode {
    BluebirdCoroutineDefinition() { this = bluebird().getAMemberCall("coroutine") }
  }

  private class BluebirdCoroutineDefinitionAsPartialInvoke extends DataFlow::PartialInvokeNode::Range,
    BluebirdCoroutineDefinition {
    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      boundArgs = 0 and
      callback = getArgument(0) and
      result = this
    }
  }
}

/**
 * Provides classes for working with the `q` library (https://github.com/kriskowal/q).
 */
module Q {
  /**
   * A promise object created by the q `Promise` constructor.
   */
  private class QPromiseDefinition extends PromiseDefinition, DataFlow::CallNode {
    QPromiseDefinition() { this = DataFlow::moduleMember("q", "Promise").getACall() }

    override DataFlow::FunctionNode getExecutor() { result = getCallback(0) }
  }
}

private module ClosurePromise {
  /**
   * A promise created by a call `new goog.Promise(executor)`.
   */
  private class ClosurePromiseDefinition extends PromiseDefinition, DataFlow::NewNode {
    ClosurePromiseDefinition() { this = Closure::moduleImport("goog.Promise").getACall() }

    override DataFlow::FunctionNode getExecutor() { result = getCallback(0) }
  }

  /**
   * A promise created by a call `goog.Promise.resolve(value)`.
   */
  private class ResolvedClosurePromiseDefinition extends ResolvedPromiseDefinition {
    ResolvedClosurePromiseDefinition() {
      this = Closure::moduleImport("goog.Promise.resolve").getACall()
    }

    override DataFlow::Node getValue() { result = getArgument(0) }
  }

  /**
   * Taint steps through closure promise methods.
   */
  private class ClosurePromiseTaintStep extends TaintTracking::AdditionalTaintStep {
    DataFlow::Node pred;

    ClosurePromiseTaintStep() {
      // static methods in goog.Promise
      exists(DataFlow::CallNode call, string name |
        call = Closure::moduleImport("goog.Promise." + name).getACall() and
        this = call and
        pred = call.getAnArgument()
      |
        name = "all" or
        name = "allSettled" or
        name = "firstFulfilled" or
        name = "race"
      )
      or
      // promise created through goog.promise.withResolver()
      exists(DataFlow::CallNode resolver |
        resolver = Closure::moduleImport("goog.Promise.withResolver").getACall() and
        this = resolver.getAPropertyRead("promise") and
        pred = resolver.getAMethodCall("resolve").getArgument(0)
      )
    }

    override predicate step(DataFlow::Node src, DataFlow::Node dst) { src = pred and dst = this }
  }
}
