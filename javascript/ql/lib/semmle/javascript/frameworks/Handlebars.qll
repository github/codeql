/**
 * Provides classes for working with Handlebars code.
 */

import javascript

module Handlebars {
  /**
   * A reference to the Handlebars library.
   */
  class Handlebars extends DataFlow::SourceNode {
    Handlebars() {
      this.accessesGlobal("handlebars")
      or
      this.accessesGlobal("Handlebars")
      or
      this = DataFlow::moduleImport("handlebars")
      or
      this.hasUnderlyingType("Handlebars")
    }
  }

  /**
   * A new instantiation of a Handlebars.SafeString.
   */
  class SafeString extends DataFlow::NewNode {
    SafeString() { this = any(Handlebars h).getAConstructorInvocation("SafeString") }
  }
}
