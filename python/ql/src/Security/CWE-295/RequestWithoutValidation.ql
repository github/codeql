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

/** Gets the "verfiy" argument to a outgoingRequestCall. */
DataFlow::Node verifyArg(DataFlow::CallCfgNode call) {
  call = outgoingRequestCall(_) and
  result = call.getArgByName("verify")
}

/** Gets a back-reference to the verify argument `arg`. */
private DataFlow::TypeTrackingNode verifyArgBacktracker(
  DataFlow::TypeBackTracker t, DataFlow::Node arg
) {
  t.start() and
  arg = verifyArg(_) and
  result = arg.getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 | result = verifyArgBacktracker(t2, arg).backtrack(t2, t))
}

/** Gets a back-reference to the verify argument `arg`. */
DataFlow::LocalSourceNode verifyArgBacktracker(DataFlow::Node arg) {
  result = verifyArgBacktracker(DataFlow::TypeBackTracker::end(), arg)
}

from DataFlow::CallCfgNode call, DataFlow::Node falseyOrigin, string verb
where
  call = outgoingRequestCall(verb) and
  falseyOrigin = verifyArgBacktracker(verifyArg(call)) and
  // requests treats `None` as the default and all other "falsey" values as `False`.
  falseyOrigin.asExpr().(ImmutableLiteral).booleanValue() = false and
  not falseyOrigin.asExpr() instanceof None
select call, "Call to requests." + verb + " with verify=$@", falseyOrigin, "False"
