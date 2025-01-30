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

private module PamAuthorizationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
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

/** Global taint-tracking for detecting "PAM Authorization" vulnerabilities. */
module PamAuthorizationFlow = TaintTracking::Global<PamAuthorizationConfig>;
