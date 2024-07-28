/**
 * Provides classes for working with Cors connectors.
 */

import javascript

/** Provides classes modeling the [cors](https://npmjs.com/package/cors) library. */
module Cors {
  /**
   * An expression that creates a new CORS configuration.
   */
  class Cors extends DataFlow::CallNode {
    Cors() { this = DataFlow::moduleImport("cors").getAnInvocation() }

    /** Get the options used to configure Cors */
    DataFlow::Node getOptionsArgument() { result = this.getArgument(0) }

    /** Holds if cors is using default configuration */
    predicate isDefault() { this.getNumArgument() = 0 }

    /** Gets the value of the `origin` option used to configure this Cors instance. */
    DataFlow::Node getOrigin() { result = this.getOptionArgument(0, "origin") }
  }
}
