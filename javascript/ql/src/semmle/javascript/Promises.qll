/**
 * Provides classes for modelling promises and their data-flow.
 */

import javascript

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
   * Gets the value this promise is resolved with.
   */
  abstract DataFlow::Node getValue();
}

/**
 * A promise that is created using a `.resolve()` call.
 */
abstract class ResolvedPromiseDefinition extends PromiseCreationCall { }

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
 * This module defines how data-flow propagates into and out of a Promise.
 * The data-flow is based on pseudo-properties rather than tainting the Promise object (which is what `PromiseTaintStep` does).
 */
private module PromiseFlow {
  /**
   * Gets the pseudo-field used to describe resolved values in a promise.
   */
  string resolveField() { result = "$PromiseResolveField$" }

  /**
   * Gets the pseudo-field used to describe rejected values in a promise.
   */
  string rejectField() { result = "$PromiseRejectField$" }

  /**
   * A flow step describing a promise definition.
   *
   * The resolved/rejected value is written to a pseudo-field on the promise.
   */
  class PromiseDefitionStep extends DataFlow::AdditionalFlowStep {
    PromiseDefinition promise;

    PromiseDefitionStep() { this = promise }

    override predicate storeStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = resolveField() and
      pred = promise.getResolveParameter().getACall().getArgument(0) and
      succ = this
      or
      prop = rejectField() and
      (
        pred = promise.getRejectParameter().getACall().getArgument(0) or
        pred = promise.getExecutor().getExceptionalReturn()
      ) and
      succ = this
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      // Copy the value of a resolved promise to the value of this promise.
      prop = resolveField() and
      pred = promise.getResolveParameter().getACall().getArgument(0) and
      succ = this
    }
  }

  /**
   * A flow step describing the a Promise.resolve (and similar) call.
   */
  class CreationStep extends DataFlow::AdditionalFlowStep {
    PromiseCreationCall promise;

    CreationStep() { this = promise }

    override predicate storeStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = resolveField() and
      pred = promise.getValue() and
      succ = this
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      // Copy the value of a resolved promise to the value of this promise.
      prop = resolveField() and
      pred = promise.getValue() and
      succ = this
    }
  }

  /**
   * A load step loading the pseudo-field describing that the promise is rejected.
   * The rejected value is thrown as a exception.
   */
  class AwaitStep extends DataFlow::AdditionalFlowStep {
    DataFlow::Node operand;
    AwaitExpr await;

    AwaitStep() {
      this.getEnclosingExpr() = await and
      operand.getEnclosingExpr() = await.getOperand()
    }

    override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = resolveField() and
      succ = this and
      pred = operand
      or
      prop = rejectField() and
      succ = await.getExceptionTarget() and
      pred = operand
    }
  }

  /**
   * A flow step describing the data-flow related to the `.then` method of a promise.
   */
  class ThenStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ThenStep() { this.getMethodName() = "then" }

    override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = resolveField() and
      pred = getReceiver() and
      succ = getCallback(0).getParameter(0)
      or
      prop = rejectField() and
      pred = getReceiver() and
      succ = getCallback(1).getParameter(0)
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      not exists(this.getArgument(1)) and
      prop = rejectField() and
      pred = getReceiver() and
      succ = this
      or
      // read the value of a resolved/rejected promise that is returned
      (prop = rejectField() or prop = resolveField()) and
      pred = getCallback([0 .. 1]).getAReturn() and
      succ = this
    }

    override predicate storeStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = resolveField() and
      pred = getCallback([0 .. 1]).getAReturn() and
      succ = this
      or
      prop = rejectField() and
      pred = getCallback([0 .. 1]).getExceptionalReturn() and
      succ = this
    }
  }

  /**
   * A flow step describing the data-flow related to the `.catch` method of a promise.
   */
  class CatchStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    CatchStep() { this.getMethodName() = "catch" }

    override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = rejectField() and
      pred = getReceiver() and
      succ = getCallback(0).getParameter(0)
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = resolveField() and
      pred = getReceiver().getALocalSource() and
      succ = this
      or
      // read the value of a resolved/rejected promise that is returned
      (prop = rejectField() or prop = resolveField()) and
      pred = getCallback(0).getAReturn() and
      succ = this
    }

    override predicate storeStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = rejectField() and
      pred = getCallback(0).getExceptionalReturn() and
      succ = this
      or
      prop = resolveField() and
      pred = getCallback(0).getAReturn() and
      succ = this
    }
  }

  /**
   * A flow step describing the data-flow related to the `.finally` method of a promise.
   */
  class FinallyStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    FinallyStep() { this.getMethodName() = "finally" }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      (prop = resolveField() or prop = rejectField()) and
      pred = getReceiver() and
      succ = this
      or
      // read the value of a rejected promise that is returned
      prop = rejectField() and
      pred = getCallback(0).getAReturn() and
      succ = this
    }

    override predicate storeStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = rejectField() and
      pred = getCallback(0).getExceptionalReturn() and
      succ = this
    }
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
  pred = succ.(PromiseCreationCall).getValue()
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
