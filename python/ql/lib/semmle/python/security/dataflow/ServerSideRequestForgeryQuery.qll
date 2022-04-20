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
import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery

/**
 * A taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
 *
 * This configuration has a sanitizer to limit results to cases where attacker has full control of URL.
 * See `PartialServerSideRequestForgery` for a variant without this requirement.
 *
 * You should use the `fullyControlledRequest` to only select results where all
 * URL parts are fully controlled.
 */
class FullServerSideRequestForgeryConfiguration extends TaintTracking::Configuration {
  FullServerSideRequestForgeryConfiguration() { this = "FullServerSideRequestForgery" }

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

/**
 * Holds if all URL parts of `request` is fully user controlled.
 */
predicate fullyControlledRequest(HTTP::Client::Request request) {
  exists(FullServerSideRequestForgeryConfiguration fullConfig |
    forall(DataFlow::Node urlPart | urlPart = request.getAUrlPart() |
      fullConfig.hasFlow(_, urlPart)
    )
  )
}

/**
 * A taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
 *
 * This configuration has results, even when the attacker does not have full control over the URL.
 * See `FullServerSideRequestForgeryConfiguration`, and the `fullyControlledRequest` predicate.
 */
class PartialServerSideRequestForgeryConfiguration extends TaintTracking::Configuration {
  PartialServerSideRequestForgeryConfiguration() { this = "PartialServerSideRequestForgery" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
