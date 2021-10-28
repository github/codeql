/**
 * @name Failure to use secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity error
 * @id py/insecure-cookie
 * @tags security
 *       external/cwe/cwe-614
 */

// determine precision above
import python
import semmle.python.dataflow.new.DataFlow
import experimental.semmle.python.Concepts
import experimental.semmle.python.CookieHeader
import experimental.semmle.python.security.injection.CookieInjection

from
  CookieInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink,
  string insecure
where
  config.hasFlowPath(source, sink) and
  if exists(sink.getNode().(CookieSink))
  then insecure = "and it's " + sink.getNode().(CookieSink).getFlag() + " flag is not properly set"
  else insecure = ""
select sink.getNode(), "Cookie is constructed from a", source.getNode(), "user-supplied input",
  insecure
