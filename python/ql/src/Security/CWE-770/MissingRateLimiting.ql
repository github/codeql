/*
 * @name Missing rate limiting
 * @description An HTTP request handler that performs expensive operations without
 *              restricting the rate at which operations can be carried out is vulnerable
 *              to denial-of-service attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id python/missing-rate-limiting
 * @tags security
 *       external/cwe/cwe-770
 */



import python
import semmle.python.web.RateLimiters

class MyExpensiveRouteHandler extends ExpensiveRouteHandler {
    MyExpensiveRouteHandler() {
        this.getName().matches("%expensive_handler%")
    }
    
    override string getExplanation() {
        result = "has expensive in the name"
    }
}

from ExpensiveRouteHandler hdlr
where not hdlr instanceof RateLimitedRouteHandler
select hdlr, "This route handler " + hdlr.getExplanation() + ", but is not rate-limited."
