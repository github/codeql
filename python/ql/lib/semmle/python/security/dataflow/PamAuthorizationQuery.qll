/**
 * Provides a taint-tracking configuration for detecting "PAM Authorization" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `PamAuthorization::Configuration` is needed, otherwise
 * `PamAuthorizationCustomizations` should be imported instead.
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import PamAuthorizationCustomizations::PamAuthorizationCustomizations

/**
 * A taint-tracking configuration for detecting "PAM Authorization" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PamAuthorization" }

  override predicate isSource(DataFlow::Node node) { node instanceof Source }

  override predicate isSink(DataFlow::Node node) { node instanceof Sink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Models flow from a remotely supplied username field to a PAM `handle`.
    // `retval = pam_start(service, username, byref(conv), byref(handle))`
    exists(API::CallNode pamStart, DataFlow::Node handle, API::CallNode pointer |
      pointer = API::moduleImport("ctypes").getMember(["pointer", "byref"]).getACall() and
      pamStart = libPam().getMember("pam_start").getACall() and
      pointer = pamStart.getArg(3) and
      handle = pointer.getArg(0) and
      pamStart.getArg(1) = node1 and
      handle = node2
    )
    or
    // Flow from handle to the authenticate call in the final step
    exists(VulnPamAuthCall c | c.getArg(0) = node1 | node2 = c)
  }
}
