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
 * This module defines how data-flow propagates into and out a Promise.
 */
private module PromiseFlow {
  /**
   * A promise from which data-flow can flow into or out of. 
   * 
   * This promise can both be a promise created by e.g. `new Promise(..)` or `Promise.resolve(..)`, 
   * or the result from calling a method on a promise e.g. `promise.then(..)`. 
   * 
   * The 4 methods in this class describe that ordinary and exceptional flow can flow into and out of this promise.
   */
  private abstract class PromiseNode extends DataFlow::SourceNode {

    /**
     * Get a DataFlow::Node for a value that this promise is resolved with. 
     * The value is sent either to a chained promise, or to an `await` expression. 
     * 
     * The value is e.g. an argument to `resolve(..)`, or a return value from a `.then(..)` handler. 
     */
    DataFlow::Node getASentResolveValue() { none() }
    
    /**
     * Get the DataFlow::Node that receives the value that this promise has been resolved with. 
     * 
     * E.g. the `x` in `promise.then((x) => ..)`. 
     */
    DataFlow::Node getReceivedResolveValue() { none() }
    
    /**
     * Get a DataFlow::Node for a value that this promise is rejected with. 
     * The value is sent either to a chained promise, or thrown by an `await` expression. 
     * 
     * The value is e.g. an argument to `reject(..)`, or an exception thrown by the promise executor. 
     */
    DataFlow::Node getASentRejectValue() { none() }
    
    /**
     * Get the DataFlow::Node that receives the value that this promise has been rejected with. 
     * 
     * E.g. the `x` in `promise.catch((x) => ..)`. 
     */
    DataFlow::Node getReceivedRejectValue() { none() }
  }

  /**
   * A PromiseNode for a PromiseDefinition. 
   * E.g. `new Promise(..)`. 
   */
  private class PromiseDefinitionNode extends PromiseNode {
    PromiseDefinition promise;

    PromiseDefinitionNode() { this = promise }

    override DataFlow::Node getASentResolveValue() {
      result = promise.getResolveParameter().getACall().getArgument(0)
    }

    override DataFlow::Node getASentRejectValue() {
      result = promise.getRejectParameter().getACall().getArgument(0)
      or
      result = promise.getExecutor().getExceptionalReturn()
    }
  }
  
  /**
   * A PromiseNode for a call that creates a promise. 
   * E.g. `Promise.resolve(..)` or `Promise.all(..)`. 
   */
  private class PromiseCreationNode extends PromiseNode {
    PromiseCreationCall promise;

    PromiseCreationNode() { this = promise }

    override DataFlow::Node getASentResolveValue() {
      exists(DataFlow::Node value | value = promise.getValue() | 
        not value instanceof PromiseNode and
        result = value
        or
        result = value.(PromiseNode).getASentResolveValue()
      )
    }

    override DataFlow::Node getASentRejectValue() {
      result = promise.getValue().(PromiseNode).getASentRejectValue()
    }
  }
  
  /**
   * A node referring to a PromiseNode through type-tracking.  
   */
  private class TrackedPromiseNode extends PromiseNode {
    PromiseNode base;
    TrackedPromiseNode() {
      this = trackPromise(DataFlow::TypeTracker::end(), base) and 
      not this instanceof PromiseDefinitionNode and
      not this instanceof PromiseCreationNode
    }

    override DataFlow::Node getASentResolveValue() { result = base.getASentResolveValue() }
    override DataFlow::Node getReceivedResolveValue() { result = base.getReceivedResolveValue() }
    override DataFlow::Node getASentRejectValue() { result = base.getASentRejectValue() }
    override DataFlow::Node getReceivedRejectValue() { result = base.getReceivedRejectValue() }
  }
  
  private DataFlow::SourceNode trackPromise(DataFlow::TypeTracker t, PromiseNode promise) {
    t.start() and result = promise
    or
    exists(DataFlow::TypeTracker t2 | result = trackPromise(t2, promise).track(t2, t))
  }

  /**
   * A PromiseNode that is a method call on an existing PromiseNode. 
   * E.g. `promise.then(..)`. 
   */
  private abstract class ChainedPromiseNode extends PromiseNode, DataFlow::MethodCallNode {
    PromiseNode base;

    ChainedPromiseNode() { this = base.getAMethodCall(_) }

    PromiseNode getBase() { result = base }
  }

  /**
   * A PromiseNode for the `.then(..)` method on an existing promise.
   */
  private class PromiseThenNode extends ChainedPromiseNode {
    PromiseThenNode() { this = base.getAMethodCall("then") }

    override DataFlow::Node getASentResolveValue() {
      exists(DataFlow::Node ret | ret = this.getCallback(0).getAReturn() |
        if ret instanceof PromiseNode
        then result = ret.(PromiseNode).getReceivedResolveValue()
        else result = ret
      )
    }

    override DataFlow::Node getASentRejectValue() {
      not exists(this.getCallback(1)) and result = base.getASentRejectValue()
      or
      result = this.getCallback([0..1]).getExceptionalReturn()
    }

    override DataFlow::Node getReceivedResolveValue() { result = this.getCallback(0).getParameter(0) }

    override DataFlow::Node getReceivedRejectValue() { result = this.getCallback(1).getParameter(0) }
  }

  /**
   * A PromiseNode for the `.finally(..)` method on an existing promise.
   */
  private class PromiseFinallyNode extends ChainedPromiseNode {
    PromiseFinallyNode() { this = base.getAMethodCall("finally") }

    override DataFlow::Node getASentResolveValue() { result = base.getASentResolveValue() }

    override DataFlow::Node getASentRejectValue() {
      result = base.getASentRejectValue()
      or
      result = this.getCallback(0).getExceptionalReturn()
    }
  }

  /**
   * A PromiseNode for the `.catch(..)` method on an existing promise.
   */
  private class PromiseCatchNode extends ChainedPromiseNode {
    PromiseCatchNode() { this = base.getAMethodCall("catch") }

    override DataFlow::Node getASentResolveValue() {
      exists(DataFlow::Node ret | ret = this.getCallback(0).getAReturn() |
        if ret instanceof PromiseNode
        then result = ret.(PromiseNode).getReceivedResolveValue()
        else result = ret
      )
      or
      result = base.getASentResolveValue()
    }

    override DataFlow::Node getASentRejectValue() { result = this.getCallback(0).getExceptionalReturn() }

    override DataFlow::Node getReceivedResolveValue() { none() }

    override DataFlow::Node getReceivedRejectValue() { result = this.getCallback(0).getParameter(0) }
  }

  
  private ChainedPromiseNode getAChainedPromise(PromiseNode p) { result.getBase() = p}
  
  /**
   * A data flow edge from a promise resolve/reject to the corresponding handler (or `await` expression).
   */
  private class PromiseFlowStep extends DataFlow::AdditionalFlowStep {
    PromiseNode promise;

    PromiseFlowStep() { this = promise }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = promise.getASentResolveValue() and
      succ = getAChainedPromise(promise).getReceivedResolveValue()
      or
      pred = promise.getASentRejectValue() and
      succ = getAChainedPromise(promise).getReceivedRejectValue()
      or
      pred = promise.getASentResolveValue() and
      exists(DataFlow::SourceNode awaitNode |
        awaitNode.asExpr().(AwaitExpr).getOperand() = promise.asExpr() and
        succ = awaitNode
      )
      or
      pred = promise.getASentRejectValue() and
      exists(DataFlow::SourceNode awaitNode |
        awaitNode.asExpr().(AwaitExpr).getOperand() = promise.asExpr() and
        succ = awaitNode.asExpr().getExceptionTarget()
      )
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
  exists(DataFlow::MethodCallNode thn, DataFlow::FunctionNode cb |
    thn.getMethodName() = "then" and cb = thn.getCallback(0)
  |
    // from `p` to `x` in `p.then(x => ...)`
    pred = thn.getReceiver() and
    succ = cb.getParameter(0)
    or
    // from `v` to `p.then(x => return v)`
    pred = cb.getAReturn() and
    succ = thn
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
      exists(string m | m = "all" or m = "race" or m = "map" | 
        this = bluebird().getAMemberCall(m)
      )
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
