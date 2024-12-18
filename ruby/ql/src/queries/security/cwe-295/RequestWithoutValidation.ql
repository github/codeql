/**
 * @name Request without certificate validation
 * @description Making a request without certificate validation can allow
 *              man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id rb/request-without-cert-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import codeql.ruby.AST
import codeql.ruby.Concepts
import codeql.ruby.DataFlow

from
  Http::Client::Request request, DataFlow::Node disablingNode, DataFlow::Node origin, string ending
where
  request.disablesCertificateValidation(disablingNode, origin) and
  // Showing the origin is only useful when it's a different node than the one disabling
  // certificate validation, for example in `requests.get(..., verify=arg)`, `arg` would
  // be the `disablingNode`, and the `origin` would be the place were `arg` got its
  // value from.
  //
  // NOTE: We compare the locations instead of DataFlow::Nodes directly, since for
  // snippet `Excon.defaults[:ssl_verify_peer] = false`, `disablingNode = argumentNode`
  // does NOT hold.
  if disablingNode.getLocation() = origin.getLocation() then ending = "." else ending = " by $@."
select request, "This request may run without certificate validation because $@" + ending,
  disablingNode, "validation is disabled", origin, "this value"
