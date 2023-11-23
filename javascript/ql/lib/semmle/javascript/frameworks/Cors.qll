/**
 * Provides classes for working with Cors connectors.
 */

import javascript

/** Provides classes modeling [cors package](https://npmjs.com/package/cors) */
module Cors {
  /**
   * An expression that creates a new CORS configuration.
   */
  class Cors extends DataFlow::CallNode {
    /** Get an instanceof of `cors` */
    Cors() { this = DataFlow::moduleImport("cors").getAnInvocation() }

    /** Get Cors configuration */
    DataFlow::Node getCorsArgument() { result = this.getArgument(0) }

    /** Holds if cors is using default configuration */
    predicate isDefault() { this.getNumArgument() = 0 }

    /** Gets the value of origin */
    DataFlow::Node getOrigin() {
      result = this.getCorsArgument().getALocalSource().getAPropertyWrite("origin").getRhs()
    }
  }
}
