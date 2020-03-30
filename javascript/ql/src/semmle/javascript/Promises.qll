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
 * An aggregated promise produced either by `Promise.all` or `Promise.race`.
 */
class AggregateES2015PromiseDefinition extends PromiseCreationCall {
  AggregateES2015PromiseDefinition() {
    exists(string m | m = "all" or m = "race" |
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
   */
  pragma[inline]
  DataFlow::Node promiseStep(DataFlow::Node pred, StepSummary summary) {
    exists(PromiseFlowStep step, string field | field = Promises::valueProp() |
      summary = LoadStep(field) and
      step.load(pred, result, field)
      or
      summary = StoreStep(field) and
      step.store(pred, result, field)
      or
      summary = CopyStep(field) and
      step.loadStore(pred, result, field)
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

/**
 * An `AdditionalFlowStep` used to model a data-flow step related to promises.
 *
 * The `loadStep`/`storeStep`/`loadStoreStep` methods are overloaded such that the new predicates
 * `load`/`store`/`loadStore` can be used in the `PromiseTypeTracking` module.
 * (Thereby avoiding conflicts with a "cousin" `AdditionalFlowStep` implementation.)
 *
 * The class is private and is only intended to be used inside the `PromiseTypeTracking` and `PromiseFlow` modules.
 */
abstract private class PromiseFlowStep extends DataFlow::AdditionalFlowStep {
  final override predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  final override predicate step(
    DataFlow::Node p, DataFlow::Node s, DataFlow::FlowLabel pl, DataFlow::FlowLabel sl
  ) {
    none()
  }

  /**
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  predicate load(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  final override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    this.load(pred, succ, prop)
  }

  /**
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   */
  predicate store(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  final override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    this.store(pred, succ, prop)
  }

  /**
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  final override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    this.loadStore(pred, succ, prop)
  }

  final override predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    none()
  }
}

/**
 * This module defines how data-flow propagates into and out of a Promise.
 * The data-flow is based on pseudo-properties rather than tainting the Promise object (which is what `PromiseTaintStep` does).
 */
private module PromiseFlow {
  private predicate valueProp = Promises::valueProp/0;

  private predicate errorProp = Promises::errorProp/0;

  /**
   * A flow step describing a promise definition.
   *
   * The resolved/rejected value is written to a pseudo-field on the promise.
   */
  class PromiseDefitionStep extends PromiseFlowStep {
    PromiseDefinition promise;

    PromiseDefitionStep() { this = promise }

    override predicate store(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      prop = valueProp() and
      pred = promise.getResolveParameter().getACall().getArgument(0) and
      succ = this
      or
      prop = errorProp() and
      (
        pred = promise.getRejectParameter().getACall().getArgument(0) or
        pred = promise.getExecutor().getExceptionalReturn()
      ) and
      succ = this
    }

    override predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      // Copy the value of a resolved promise to the value of this promise.
      prop = valueProp() and
      pred = promise.getResolveParameter().getACall().getArgument(0) and
      succ = this
    }
  }

  /**
   * A flow step describing the a Promise.resolve (and similar) call.
   */
  class CreationStep extends PromiseFlowStep {
    PromiseCreationCall promise;

    CreationStep() { this = promise }

    override predicate store(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      not promise instanceof PromiseAllCreation and
      prop = valueProp() and
      pred = promise.getValue() and
      succ = this
      or
      prop = valueProp() and
      pred = promise.(PromiseAllCreation).getArrayNode() and
      succ = this
    }

    override predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      // Copy the value of a resolved promise to the value of this promise.
      not promise instanceof PromiseAllCreation and
      prop = valueProp() and
      pred = promise.getValue() and
      succ = this
      or
      promise instanceof PromiseAllCreation and
      prop = valueProp() and
      pred = promise.(PromiseAllCreation).getArrayNode() and
      succ = this
    }
  }

  /**
   * A load step loading the pseudo-field describing that the promise is rejected.
   * The rejected value is thrown as a exception.
   */
  class AwaitStep extends PromiseFlowStep {
    DataFlow::Node operand;
    AwaitExpr await;

    AwaitStep() {
      this.getEnclosingExpr() = await and
      operand.getEnclosingExpr() = await.getOperand()
    }

    override predicate load(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = valueProp() and
      succ = this and
      pred = operand
      or
      prop = errorProp() and
      succ = await.getExceptionTarget() and
      pred = operand
    }
  }

  /**
   * A flow step describing the data-flow related to the `.then` method of a promise.
   */
  class ThenStep extends PromiseFlowStep, DataFlow::MethodCallNode {
    ThenStep() { this.getMethodName() = "then" }

    override predicate load(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = valueProp() and
      pred = getReceiver() and
      succ = getCallback(0).getParameter(0)
      or
      prop = errorProp() and
      pred = getReceiver() and
      succ = getCallback(1).getParameter(0)
    }

    override predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      not exists(this.getArgument(1)) and
      prop = errorProp() and
      pred = getReceiver() and
      succ = this
      or
      // read the value of a resolved/rejected promise that is returned
      (prop = errorProp() or prop = valueProp()) and
      pred = getCallback([0 .. 1]).getAReturn() and
      succ = this
    }

    override predicate store(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      prop = valueProp() and
      pred = getCallback([0 .. 1]).getAReturn() and
      succ = this
      or
      prop = errorProp() and
      pred = getCallback([0 .. 1]).getExceptionalReturn() and
      succ = this
    }
  }

  /**
   * A flow step describing the data-flow related to the `.catch` method of a promise.
   */
  class CatchStep extends PromiseFlowStep, DataFlow::MethodCallNode {
    CatchStep() { this.getMethodName() = "catch" }

    override predicate load(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = errorProp() and
      pred = getReceiver() and
      succ = getCallback(0).getParameter(0)
    }

    override predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = valueProp() and
      pred = getReceiver().getALocalSource() and
      succ = this
      or
      // read the value of a resolved/rejected promise that is returned
      (prop = errorProp() or prop = valueProp()) and
      pred = getCallback(0).getAReturn() and
      succ = this
    }

    override predicate store(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      prop = errorProp() and
      pred = getCallback(0).getExceptionalReturn() and
      succ = this
      or
      prop = valueProp() and
      pred = getCallback(0).getAReturn() and
      succ = this
    }
  }

  /**
   * A flow step describing the data-flow related to the `.finally` method of a promise.
   */
  class FinallyStep extends PromiseFlowStep, DataFlow::MethodCallNode {
    FinallyStep() { this.getMethodName() = "finally" }

    override predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      (prop = valueProp() or prop = errorProp()) and
      pred = getReceiver() and
      succ = this
      or
      // read the value of a rejected promise that is returned
      prop = errorProp() and
      pred = getCallback(0).getAReturn() and
      succ = this
    }

    override predicate store(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      prop = errorProp() and
      pred = getCallback(0).getExceptionalReturn() and
      succ = this
    }
  }
}

/**
 * DEPRECATED. Use `TaintTracking::promiseStep` instead.
 */
deprecated predicate promiseTaintStep = TaintTracking::promiseStep/2;

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
  private class ClosurePromiseTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      // static methods in goog.Promise
      exists(DataFlow::CallNode call, string name |
        call = Closure::moduleImport("goog.Promise." + name).getACall() and
        succ = call and
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
        succ = resolver.getAPropertyRead("promise") and
        pred = resolver.getAMethodCall("resolve").getArgument(0)
      )
    }
  }
}
