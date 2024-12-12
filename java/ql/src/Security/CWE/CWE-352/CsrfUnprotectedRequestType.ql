/**
 * @name HTTP request type unprotected from CSRF
 * @description Using an HTTP request type that is not default-protected from CSRF for a
 *              state-changing action makes the application vulnerable to a Cross-Site
 *              Request Forgery (CSRF) attack.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision low
 * @id java/csrf-unprotected-request-type
 * @tags security
 *       external/cwe/cwe-352
 */

import java
import semmle.code.java.security.CsrfUnprotectedRequestTypeQuery

query predicate edges(CallPathNode pred, CallPathNode succ) { CallGraph::edges(pred, succ) }

from CallPathNode source, CallPathNode reachable, CallPathNode callsReachable
where unprotectedStateChange(source, reachable, callsReachable)
select source.asMethod(), source, callsReachable,
  "Potential CSRF vulnerability due to using an HTTP request type which is not default-protected from CSRF for an apparent $@.",
  callsReachable, "state-changing action"
