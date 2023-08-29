/**
 * @name JWT Method Check
 * @description Trusting the Method provided by the incoming JWT token may lead to an algorithim confusion
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision medium
 * @id go/jwt-pitfalls
 * @tags security
 *       external/cwe/cwe-347
 */
import go
import JWT
import DataFlow

from CallNode c, NewParser m, WithValidMethods wvm, Function func
where 
(c.getTarget() = func and
// //Flow from NewParser to Parse (check that this call to Parse does not use a Parser that sets Valid Methods)
((func instanceof SafeJWTParserMethod and not exists( CallNode c2 | c2.getTarget() = m 
and ( c2.getCall().getAnArgument() = wvm.getACall().asExpr()
and DataFlow::localFlow(c2.getAResult(), c.getReceiver()))
))
//ParserFunc creates a new default Parser on call that accepts all methods
or func instanceof SafeJWTParserFunc
)
//Check that the Parse(function or method) does not check the Token Method field, which most likely is a check for method type
and not exists(Field f |
    f.hasQualifiedName(packagePathModern(), "Token", "Method")
 and f.getARead().getRoot() = c.getCall().getAnArgument()
 ))

select c, "This Parse Call to Verify the JWT token is vulnerable to algorithim confusion"
