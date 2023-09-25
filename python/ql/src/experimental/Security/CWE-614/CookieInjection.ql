/**
 * @name Construction of a cookie using user-supplied input.
 * @description Constructing cookies from user input may allow an attacker to perform a Cookie Poisoning attack.
 * @kind path-problem
 * @problem.severity error
 * @id py/cookie-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-614
 */

// determine precision above
import python
import semmle.python.dataflow.new.DataFlow
import experimental.semmle.python.Concepts
import experimental.semmle.python.CookieHeader
import experimental.semmle.python.security.injection.CookieInjection
import CookieInjectionFlow::PathGraph

from CookieInjectionFlow::PathNode source, CookieInjectionFlow::PathNode sink, string insecure
where
  CookieInjectionFlow::flowPath(source, sink) and
  if exists(sink.getNode().(CookieSink))
  then insecure = ",and its " + sink.getNode().(CookieSink).getFlag() + " flag is not properly set."
  else insecure = "."
select sink.getNode(), source, sink, "Cookie is constructed from a $@" + insecure, source.getNode(),
  "user-supplied input"
