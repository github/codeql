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

from API::CallNode call, DataFlow::Node falseyOrigin, string verb
where
  verb = HTTP::httpVerbLower() and
  call = API::moduleImport("requests").getMember(verb).getACall() and
  falseyOrigin = call.getKeywordParameter("verify").getAValueReachingRhs() and
  // requests treats `None` as the default and all other "falsey" values as `False`.
  falseyOrigin.asExpr().(ImmutableLiteral).booleanValue() = false and
  not falseyOrigin.asExpr() instanceof None
select call, "Call to requests." + verb + " with verify=$@", falseyOrigin, "False"
