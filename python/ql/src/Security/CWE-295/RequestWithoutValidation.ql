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

from
  HTTP::Client::Request request, DataFlow::Node disablingNode, DataFlow::Node origin, string ending
where
  request.disablesCertificateValidation(disablingNode, origin) and
  // Showing the origin is only useful when it's a different node than the one disabling
  // certificate validation, for example in `requests.get(..., verify=arg)`, `arg` would
  // be the `disablingNode`, and the `origin` would be the place were `arg` got its
  // value from.
  if disablingNode = origin then ending = "." else ending = " by the value from $@."
select request, "This request may run without certificate validation because it is $@" + ending,
  disablingNode, "disabled here", origin, "here"
