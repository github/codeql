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
