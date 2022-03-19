/**
 * Provides a taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ServerSideRequestForgery::Configuration` is needed, otherwise
 * `ServerSideRequestForgeryCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts

/**
 * Provides a taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
 *
 * This configuration has a sanitizer to limit results to cases where attacker has full control of URL.
 * See `PartialServerSideRequestForgery` for a variant without this requirement.
 *
 * You should use the `partOfFullyControlledRequest` to only select results where all
 * URL parts are fully controlled.
 */
module FullServerSideRequestForgery {
  import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery

  /**
   * A taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "FullServerSideRequestForgery" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      node instanceof Sanitizer
      or
      node instanceof FullUrlControlSanitizer
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}

/**
 * Holds if all URL parts of `request` is fully user controlled.
 */
predicate fullyControlledRequest(HTTP::Client::Request request) {
  exists(FullServerSideRequestForgery::Configuration fullConfig |
    forall(DataFlow::Node urlPart | urlPart = request.getAUrlPart() |
      fullConfig.hasFlow(_, urlPart)
    )
  )
}

/**
 * Provides a taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
 *
 * This configuration has results, even when the attacker does not have full control over the URL.
 * See `FullServerSideRequestForgery` for variant that has this requirement.
 */
module PartialServerSideRequestForgery {
  import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery

  /**
   * A taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "PartialServerSideRequestForgery" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
