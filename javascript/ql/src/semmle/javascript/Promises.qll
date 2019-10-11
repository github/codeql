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
  class DeferredClass extends DataFlow::SourceNode {
    DeferredClass() {
      exists(Variable var |
        var.getName() = "Deferred" and
        (
          var.getADeclaration() instanceof LocalNamespaceDecl or
          var.getScope() instanceof GlobalScope
        ) and
        this = DataFlow::valueNode(var.getADefinition())
      )
      or
      this.(DataFlow::ParameterNode).getName() = "Deferred"
      or
      exists(Function f |
        f.getName() = "Deferred" and
        this = DataFlow::valueNode(f)
      )
      or
      exists(ClassDefinition c |
        c.getName() = "Deferred" and
        this = DataFlow::valueNode(c)
      )
    }
  }

  class DeferredInstance extends DataFlow::NewNode {
    DeferredClass deferredClass;

    DeferredInstance() { this = deferredClass.getAnInstantiation() }

    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and
      result = this
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
    }

    DeferredClass getDeferredClass() { result = deferredClass }

    DataFlow::CallNode getPromiseMemberCall(string methodName) {
      result = ref(DataFlow::TypeTracker::end()).getAMemberCall(methodName)
    }
  }

  /**
   * A promise object created by a Deferred constructor
   */
  private class DeferredPromiseDefinition extends PromiseDefinition, DeferredInstance {
    DeferredPromiseDefinition() { 
      this = any(DeferredClass c |
        exists(any(DeferredInstance i | i.getDeferredClass() = c).getPromiseMemberCall("resolve")) and
        exists(any(DeferredInstance i | i.getDeferredClass() = c).getPromiseMemberCall("reject"))
      ).getAnInstantiation() 
    }

    override DataFlow::FunctionNode getExecutor() { result = getCallback(0) }
  }

  /**
   * A resolved promise created by a `new Deferred().resolve()` call.
   */
  class ResolvedDeferredPromiseDefinition extends ResolvedPromiseDefinition {
    ResolvedDeferredPromiseDefinition() {
      this = any(DeferredPromiseDefinition def).getPromiseMemberCall("resolve")
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
