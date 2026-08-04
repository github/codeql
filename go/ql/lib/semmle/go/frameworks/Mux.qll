/**
 * Provides classes for working with concepts in the Mux HTTP middleware library.
 */
overlay[local?]
module;

import go

/**
 * DEPRECATED
 *
 * Provides classes for working with concepts in the Mux HTTP middleware library.
 */
deprecated module Mux {
  /**
   * DEPRECATED: Use `RemoteFlowSource::Range` instead.
   *
   * An access to a Mux middleware variable.
   */
  deprecated class RequestVars extends DataFlow::RemoteFlowSource::Range, DataFlow::CallNode {
    RequestVars() {
      this.getTarget().hasQualifiedName(package("github.com/gorilla/mux", ""), "Vars")
    }
  }
}
