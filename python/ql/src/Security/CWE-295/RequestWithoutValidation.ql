/**
 * @name Request without certificate validation
 * @description Making a request without certificate validation can allow man-in-the-middle attacks.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @id py/request-without-cert-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Gets a call to a method that makes an outgoing request using the `requests` module,
 * such as `requests.get` or `requests.put`, with the specified HTTP verb `verb`
 */
DataFlow::CallCfgNode outgoingRequestCall(string verb) {
  verb = HTTP::httpVerbLower() and
  result = API::moduleImport("requests").getMember(verb).getACall()
}

/** Gets a reference to a falsey value (excluding None), with origin `origin`. */
private DataFlow::TypeTrackingNode falseyNotNone(DataFlow::TypeTracker t, DataFlow::Node origin) {
  t.start() and
  result.asExpr().(ImmutableLiteral).booleanValue() = false and
  not result.asExpr() instanceof None and
  origin = result
  or
  exists(DataFlow::TypeTracker t2 | result = falseyNotNone(t2, origin).track(t2, t))
}

/** Gets a reference to a falsey value (excluding None), with origin `origin`. */
DataFlow::Node falseyNotNone(DataFlow::Node origin) {
  falseyNotNone(DataFlow::TypeTracker::end(), origin).flowsTo(result)
}

from DataFlow::CallCfgNode call, DataFlow::Node falseyOrigin, string verb
where
  call = outgoingRequestCall(verb) and
  // requests treats `None` as the default and all other "falsey" values as `False`.
  call.getArgByName("verify") = falseyNotNone(falseyOrigin)
select call, "Call to requests." + verb + " with verify=$@", falseyOrigin, "False"
