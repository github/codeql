/**
 * Provides classes for modelling promise libraries.
 */

import javascript

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
}

/**
 * Provides classes for working with various Deferred implementations
 */
module Deferred {
  class DeferredInstance extends DataFlow::NewNode {
  	// Describes both `new Deferred()`, `new $.Deferred` and other variants. 
    DeferredInstance() { this.getCalleeName() = "Deferred" }

    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and
      result = this
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
    }
    
    DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }
  }

  /**
   * A promise object created by a Deferred constructor
   */
  private class DeferredPromiseDefinition extends PromiseDefinition, DeferredInstance {
    DeferredPromiseDefinition() {
      // hardening of the "Deferred" heuristic: a method call to `resolve`. 
      exists(ref().getAMethodCall("resolve"))
    }

    override DataFlow::FunctionNode getExecutor() { result = getCallback(0) }
  }

  /**
   * A resolved promise created by a `new Deferred().resolve()` call.
   */
  class ResolvedDeferredPromiseDefinition extends ResolvedPromiseDefinition {
    ResolvedDeferredPromiseDefinition() {
      this = any(DeferredPromiseDefinition def).ref().getAMethodCall("resolve")
    }

    override DataFlow::Node getValue() { result = getArgument(0) }
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
