/**
 * Provides classes for working with promises.
 */

import javascript

/**
 * A promise object created by the standard ECMAScript 2015 `Promise` constructor.
 */
private class ES2015PromiseDefinition extends PromiseDefinition, DataFlow::NewNode {
  ES2015PromiseDefinition() {
    this = DataFlow::globalVarRef("Promise").getAnInstantiation()
  }

  override DataFlow::FunctionNode getExecutor()  {
    result = getCallback(0)
  }
}

/**
 * A data flow edge from a promise reaction to the corresponding handler.
 */
private class PromiseFlowStep extends DataFlow::AdditionalFlowStep {
  PromiseDefinition p;

  PromiseFlowStep() {
    this = p
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = p.getResolveParameter().getACall().getArgument(0) and
    succ = p.getAResolveHandler().getParameter(0)
    or
    pred = p.getRejectParameter().getACall().getArgument(0) and
    succ = p.getARejectHandler().getParameter(0)
  }
}

/**
 * Holds if taint propagates from `pred` to `succ` through promises.
 */
private predicate promiseTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  // from `x` to `new Promise((res, rej) => res(x))`
  pred = succ.(PromiseDefinition).getResolveParameter().getACall().getArgument(0)
  or
  // from `x` to `Promise.resolve(x)`
  pred = succ.(ResolvedPromiseDefinition).getValue()
  or
  exists (DataFlow::MethodCallNode thn, DataFlow::FunctionNode cb |
    thn.getMethodName() = "then" and cb = thn.getCallback(0) |
    // from `p` to `x` in `p.then(x => ...)`
    pred = thn.getReceiver() and
    succ = cb.getParameter(0)
    or
    // from `v` to `p.then(x => return v)`
    pred = cb.getFunction().getAReturnedExpr().flow() and
    succ = thn
  )
}

/**
 * An additional taint step that involves promises.
 */
private class PromiseTaintStep extends TaintTracking::AdditionalTaintStep {
  DataFlow::Node source;

  PromiseTaintStep() {
    promiseTaintStep(source, this)
  }

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

    BluebirdPromiseDefinition() {
      this = bluebird().getAnInstantiation()
    }

    override DataFlow::FunctionNode getExecutor()  {
      result = getCallback(0)
    }
  }

  /**
   * A resolved promise created by the bluebird `Promise.resolve` function.
   */
  class ResolvedBluebidPromiseDefinition extends ResolvedPromiseDefinition {

    ResolvedBluebidPromiseDefinition() {
      this = bluebird().getAMemberCall("resolve")
    }

    override DataFlow::Node getValue() {
      result = getArgument(0)
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

    QPromiseDefinition() {
      this = DataFlow::moduleMember("q", "Promise").getACall()
    }

    override DataFlow::FunctionNode getExecutor()  {
      result = getCallback(0)
    }
  }

}

/**
 * A promise that is resolved with the given value.
 */
abstract class ResolvedPromiseDefinition extends DataFlow::CallNode {

  /**
   * Gets the value this promise is resolved with.
   */
  abstract DataFlow::Node getValue();

}

/**
 * A resolved promise created by the standard ECMAScript 2015 `Promise.resolve` function.
 */
class ResolvedES2015PromiseDefinition extends ResolvedPromiseDefinition {

  ResolvedES2015PromiseDefinition() {
    this = DataFlow::globalVarRef("Promise").getAMemberCall("resolve")
  }

  override DataFlow::Node getValue() {
    result = getArgument(0)
  }

}