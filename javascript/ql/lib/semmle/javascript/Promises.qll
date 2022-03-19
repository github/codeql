/**
 * Provides classes for modeling promises and their data-flow.
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
  DataFlow::ParameterNode getResolveParameter() { result = this.getExecutor().getParameter(0) }

  /** Gets the `reject` parameter of the executor function. */
  DataFlow::ParameterNode getRejectParameter() { result = this.getExecutor().getParameter(1) }

  /** Gets the `i`th callback handler installed by method `m`. */
  private DataFlow::FunctionNode getAHandler(string m, int i) {
    result = this.getAMethodCall(m).getCallback(i)
  }

  /**
   * Gets a function that handles promise resolution, including both
   * `then` handlers and `finally` handlers.
   */
  DataFlow::FunctionNode getAResolveHandler() {
    result = this.getAHandler("then", 0) or
    result = this.getAFinallyHandler()
  }

  /**
   * Gets a function that handles promise rejection, including
   * `then` handlers, `catch` handlers and `finally` handlers.
   */
  DataFlow::FunctionNode getARejectHandler() {
    result = this.getAHandler("then", 1) or
    result = this.getACatchHandler() or
    result = this.getAFinallyHandler()
  }

  /**
   * Gets a `catch` handler of this promise.
   */
  DataFlow::FunctionNode getACatchHandler() { result = this.getAHandler("catch", 0) }

  /**
   * Gets a `finally` handler of this promise.
   */
  DataFlow::FunctionNode getAFinallyHandler() { result = this.getAHandler("finally", 0) }
}

/** Holds if the `i`th callback handler is installed by method `m`. */
private predicate hasHandler(DataFlow::InvokeNode promise, string m, int i) {
  exists(promise.getAMethodCall(m).getCallback(i))
}

/**
 * Gets a reference to the `Promise` object.
 * Either from the standard library, a polyfill import, or a polyfill that defines the global `Promise` variable.
 */
private DataFlow::SourceNode getAPromiseObject() {
  // Standard library, or polyfills like [es6-shim](https://npmjs.org/package/es6-shim).
  result = DataFlow::globalVarRef("Promise")
  or
  // polyfills from the [`promise`](https://npmjs.org/package/promise) library.
  result =
    DataFlow::moduleImport([
        "promise", "promise/domains", "promise/setimmediate", "promise/lib/es6-extensions",
        "promise/domains/es6-extensions", "promise/setimmediate/es6-extensions"
      ])
  or
  // polyfill from the [`promise-polyfill`](https://npmjs.org/package/promise-polyfill) library.
  result = DataFlow::moduleMember(["promise-polyfill", "promise-polyfill/src/polyfill"], "default")
  or
  result = DataFlow::moduleImport(["promise-polyfill", "promise-polyfill/src/polyfill"])
  or
  result = DataFlow::moduleMember(["es6-promise", "rsvp"], "Promise")
  or
  result = DataFlow::moduleImport("native-promise-only")
  or
  result = DataFlow::moduleImport("when")
  or
  result = DataFlow::moduleImport("pinkie-promise")
  or
  result = DataFlow::moduleImport("pinkie")
  or
  result = DataFlow::moduleMember("synchronous-promise", "SynchronousPromise")
  or
  result = DataFlow::moduleImport("any-promise")
  or
  result = DataFlow::moduleImport("lie")
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
 * A promise object created by the standard ECMAScript 2015 `Promise` constructor,
 * or a polyfill implementing a superset of the ECMAScript 2015 `Promise` API.
 */
private class ES2015PromiseDefinition extends PromiseDefinition, DataFlow::InvokeNode {
  ES2015PromiseDefinition() { this = getAPromiseObject().getAnInvocation() }

  override DataFlow::FunctionNode getExecutor() { result = this.getCallback(0) }
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
  ResolvedES2015PromiseDefinition() { this = getAPromiseObject().getAMemberCall("resolve") }

  override DataFlow::Node getValue() { result = this.getArgument(0) }
}

/**
 * An aggregated promise produced either by `Promise.all`, `Promise.race`, or `Promise.any`.
 */
class AggregateES2015PromiseDefinition extends PromiseCreationCall {
  AggregateES2015PromiseDefinition() {
    this = getAPromiseObject().getAMemberCall(["all", "race", "any", "allSettled"])
    or
    this = DataFlow::moduleImport("promise.allsettled").getACall()
  }

  override DataFlow::Node getValue() {
    result = this.getArgument(0).getALocalSource().(DataFlow::ArrayCreationNode).getAnElement()
  }
}

/**
 * An aggregated promise created using `Promise.all()`.
 */
class ES2015PromiseAllDefinition extends AggregateES2015PromiseDefinition, PromiseAllCreation {
  ES2015PromiseAllDefinition() { this.getCalleeName() = "all" }

  override DataFlow::Node getArrayNode() { result = this.getArgument(0) }
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
        [
          promise.getRejectParameter().getACall().getArgument(0),
          promise.getExecutor().getExceptionalReturn()
        ]
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
    or
    // return from `async` function
    exists(DataFlow::FunctionNode f | f.getFunction().isAsync() |
      // ordinary return
      prop = valueProp() and
      pred = f.getAReturn() and
      succ = f.getReturnNode()
    )
  }
}

private class PromiseTaintStep extends TaintTracking::SharedTaintStep {
  override predicate promiseStep(DataFlow::Node pred, DataFlow::Node succ) {
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
  private class AsyncTaintReturn extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Function f |
        f.isAsync() and
        returnExpr(f, pred, _) and
        succ.(DataFlow::FunctionReturnNode).getFunction() = f
      )
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

    override DataFlow::FunctionNode getExecutor() { result = this.getCallback(0) }
  }

  /**
   * A resolved promise created by the bluebird `Promise.resolve` function.
   */
  class ResolvedBluebidPromiseDefinition extends ResolvedPromiseDefinition {
    ResolvedBluebidPromiseDefinition() { this = bluebird().getAMemberCall("resolve") }

    override DataFlow::Node getValue() { result = this.getArgument(0) }
  }

  /**
   * An aggregated promise produced either by `Promise.all`, `Promise.race` or `Promise.map`.
   */
  class AggregateBluebirdPromiseDefinition extends PromiseCreationCall {
    AggregateBluebirdPromiseDefinition() {
      exists(string m | m = "all" or m = "race" or m = "map" | this = bluebird().getAMemberCall(m))
    }

    override DataFlow::Node getValue() {
      result = this.getArgument(0).getALocalSource().(DataFlow::ArrayCreationNode).getAnElement()
    }
  }

  /**
   * A promise created using `Promise.all`:
   */
  class BluebirdPromiseAllDefinition extends AggregateBluebirdPromiseDefinition, PromiseAllCreation {
    BluebirdPromiseAllDefinition() { this.getCalleeName() = "all" }

    override DataFlow::Node getArrayNode() { result = this.getArgument(0) }
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
      callback = this.getArgument(0) and
      result = this
    }
  }
}

/**
 * Provides classes for working with the `q` library (https://github.com/kriskowal/q) and the compatible `kew` library (https://github.com/Medium/kew).
 */
module Q {
  /**
   * A promise object created by the q `Promise` constructor.
   */
  private class QPromiseDefinition extends PromiseDefinition, DataFlow::CallNode {
    QPromiseDefinition() { this = DataFlow::moduleMember(["q", "kew"], "Promise").getACall() }

    override DataFlow::FunctionNode getExecutor() { result = this.getCallback(0) }
  }
}

private module ClosurePromise {
  /**
   * A promise created by a call `new goog.Promise(executor)`.
   */
  private class ClosurePromiseDefinition extends PromiseDefinition, DataFlow::NewNode {
    ClosurePromiseDefinition() { this = Closure::moduleImport("goog.Promise").getACall() }

    override DataFlow::FunctionNode getExecutor() { result = this.getCallback(0) }
  }

  /**
   * A promise created by a call `goog.Promise.resolve(value)`.
   */
  private class ResolvedClosurePromiseDefinition extends ResolvedPromiseDefinition {
    pragma[noinline]
    ResolvedClosurePromiseDefinition() {
      this = Closure::moduleImport("goog.Promise.resolve").getACall()
    }

    override DataFlow::Node getValue() { result = this.getArgument(0) }
  }

  /**
   * Taint steps through closure promise methods.
   */
  private class ClosurePromiseTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      // static methods in goog.Promise
      exists(DataFlow::CallNode call, string name |
        call = Closure::moduleImport("goog.Promise." + name).getACall() and
        succ = call and
        pred = call.getAnArgument()
      |
        name = ["all", "allSettled", "firstFulfilled", "race"]
      )
      or
      // promise created through goog.promise.withResolver()
      exists(DataFlow::CallNode resolver |
        resolver = Closure::moduleImport("goog.Promise.withResolver").getACall() and
        succ = resolver.getAPropertyRead("promise") and
        pred = resolver.getAMethodCall("resolve").getArgument(0)
      )
    }
  }
}

private module DynamicImportSteps {
  /**
   * A step from an export value to its uses via dynamic imports.
   *
   * For example:
   * ```js
   * // foo.js
   * export default Foo
   *
   * // bar.js
   * let Foo = await import('./foo');
   * ```
   */
  class DynamicImportStep extends PreCallGraphStep {
    override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      exists(DynamicImportExpr imprt |
        pred = imprt.getImportedModule().getAnExportedValue("default") and
        succ = imprt.flow() and
        prop = Promises::valueProp()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      // Special-case code like `(await import(x)).Foo` to boost type tracking depth.
      exists(
        DynamicImportExpr imprt, string name, DataFlow::Node mid, DataFlow::SourceNode awaited
      |
        pred = imprt.getImportedModule().getAnExportedValue(name) and
        mid.getALocalSource() = imprt.flow() and
        PromiseFlow::loadStep(mid, awaited, Promises::valueProp()) and
        succ = awaited.getAPropertyRead(name)
      )
    }
  }
}

/**
 * Provides classes modeling libraries implementing `promisify` functions.
 * That is, functions that convert callback style functions to functions that return a promise.
 */
module Promisify {
  /**
   * A call to a `promisifyAll` function.
   * E.g. `require("bluebird").promisifyAll(...)`.
   */
  class PromisifyAllCall extends DataFlow::CallNode {
    PromisifyAllCall() {
      this =
        [
          DataFlow::moduleMember("bluebird", "promisifyAll"),
          DataFlow::moduleImport(["util-promisifyall", "pify"])
        ].getACall()
    }
  }

  /**
   * A call to a `promisify` function.
   * E.g. `require("util").promisify(...)`.
   */
  class PromisifyCall extends DataFlow::CallNode {
    PromisifyCall() {
      this = DataFlow::moduleImport(["util", "bluebird"]).getAMemberCall("promisify")
      or
      this = DataFlow::moduleImport(["pify", "util.promisify"]).getACall()
      or
      this = DataFlow::moduleImport("thenify").getACall()
      or
      this = DataFlow::moduleMember("thenify", "withCallback").getACall()
    }
  }
}
