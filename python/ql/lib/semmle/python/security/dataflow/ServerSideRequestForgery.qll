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
import ServerSideRequestForgeryQuery as ServerSideRequestForgeryQuery // ignore-query-import

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

  class Configuration = ServerSideRequestForgeryQuery::FullServerSideRequestForgeryConfiguration;
}

/**
 * Holds if all URL parts of `request` is fully user controlled.
 */
predicate fullyControlledRequest = ServerSideRequestForgeryQuery::fullyControlledRequest/1;

/**
 * Provides a taint-tracking configuration for detecting "Server-side request forgery" vulnerabilities.
 *
 * This configuration has results, even when the attacker does not have full control over the URL.
 * See `FullServerSideRequestForgery` for variant that has this requirement.
 */
module PartialServerSideRequestForgery {
  import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery

  class Configuration = ServerSideRequestForgeryQuery::PartialServerSideRequestForgeryConfiguration;
}
