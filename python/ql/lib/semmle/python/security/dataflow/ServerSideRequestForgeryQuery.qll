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
 * This configuration has a sanitizer to limit results to cases where attacker has full control of URL.
 * See `PartialServerSideRequestForgery` for a variant without this requirement.
 *
 * You should use the `fullyControlledRequest` to only select results where all
 * URL parts are fully controlled.
 */
private module FullServerSideRequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer
    or
    node instanceof FullUrlControlSanitizer
  }
}

/**
 * Global taint-tracking for detecting "Full server-side request forgery" vulnerabilities.
 *
 * You should use the `fullyControlledRequest` to only select results where all
 * URL parts are fully controlled.
 */
module FullServerSideRequestForgeryFlow = TaintTracking::Global<FullServerSideRequestForgeryConfig>;

/**
 * Holds if all URL parts of `request` is fully user controlled.
 */
predicate fullyControlledRequest(Http::Client::Request request) {
  forall(DataFlow::Node urlPart | urlPart = request.getAUrlPart() |
    FullServerSideRequestForgeryFlow::flow(_, urlPart)
  )
}

/**
 * This configuration has results, even when the attacker does not have full control over the URL.
 * See `FullServerSideRequestForgeryConfiguration`, and the `fullyControlledRequest` predicate.
 */
private module PartialServerSideRequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Global taint-tracking for detecting "partial server-side request forgery" vulnerabilities.
 */
module PartialServerSideRequestForgeryFlow =
  TaintTracking::Global<PartialServerSideRequestForgeryConfig>;
