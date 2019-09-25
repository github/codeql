/*
 * @name Missing rate limiting
 * @description An HTTP request handler that performs expensive operations without
 *              restricting the rate at which operations can be carried out is vulnerable
 *              to denial-of-service attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id py/missing-rate-limiting
 * @tags security
 *       external/cwe/cwe-770
 */



import python
import semmle.python.web.RateLimiters

from ExpensiveRouteHandler handler
where not handler instanceof RateLimitedRouteHandler
select handler, "This route handler " + handler.getExplanation() + ", but is not rate-limited."