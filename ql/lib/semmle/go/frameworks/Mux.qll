/**
 * Provides classes for working with concepts in the Mux HTTP middleware library.
 */

import go

/**
 * Provides classes for working with concepts in the Mux HTTP middleware library.
 */
module Mux {
  /** An access to a Mux middleware variable. */
  class RequestVars extends DataFlow::UntrustedFlowSource::Range, DataFlow::CallNode {
    RequestVars() {
      this.getTarget().hasQualifiedName(package("github.com/gorilla/mux", ""), "Vars")
    }
  }
}
