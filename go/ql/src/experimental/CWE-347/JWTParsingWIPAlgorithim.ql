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

//Method is checked in second argument 
// from Field f, CallExpr c, SafeJWTParserFunc jpf, UnafeJWTParserMethod upm
// where (f.hasQualifiedName(packagePathModern(), "Token", "Method")
// and f.getARead().getRoot() = c.getArgument(1)
// and c.getTarget() = jpf)
// or 
// c.getTarget() = upm
// select f.getARead(), c.getTarget()
// //Flow from NewParser to Parse
// from CallExpr c, CallExpr c2, NewParser m, WithValidMethods wvm, SafeJWTParserMethod spm
// where c.getAnArgument() = wvm.getACall().asExpr()
// and c.getTarget() = m and c2.getTarget() = spm and
// DataFlow::localFlow(m.getACall().getAResult(), spm.getACall().getReceiver())
// select spm.getACall().getReceiver(), m.getACall().getAResult()

//lestrrat uses WithKeys or Keysets
// from LestrratParse lp, LestrratSafeOptions lwk, CallExpr c
// where c.getTarget() = lp and c.getAnArgument() = lwk.getACall().asExpr() and
// not(c.getArgument(0) = lwk.getACall().asExpr())
// select lp
//other Library

//Method is checked in second argument 
// from Field f, CallExpr c, SafeJWTParserFunc jpf
// where (f.hasQualifiedName(packagePathModern(), "Token", "Method")
// and f.getARead().getRoot() = c.getArgument(1)
// and c.getTarget() = jpf)
// select c.getTarget()


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

select c

//lestrrat uses WithKeys or Keysets
// from LestrratParse lp, LestrratSafeOptions lwk, CallExpr c
// where c.getTarget() = lp and c.getAnArgument() = lwk.getACall().asExpr() and
// not(c.getArgument(0) = lwk.getACall().asExpr())
// select lp