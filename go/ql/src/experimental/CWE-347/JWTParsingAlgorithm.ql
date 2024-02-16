/**
 * @name JWT Method Check
 * @description Trusting the Method provided by the incoming JWT token may lead to an algorithim confusion
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision medium
 * @id go/jwt-alg-confusion
 * @tags security
 *       external/cwe/cwe-347
 */

import go
import experimental.frameworks.JWT
import DataFlow

/**
 * A parse function that verifies signature and accepts all methods.
 */
class SafeJwtParserFunc extends Function {
  SafeJwtParserFunc() { this.hasQualifiedName(golangJwtModern(), ["Parse", "ParseWithClaims"]) }
}

/**
 * A parse method that verifies signature.
 */
class SafeJwtParserMethod extends Method {
  SafeJwtParserMethod() {
    this.hasQualifiedName(golangJwtModern(), "Parser", ["Parse", "ParseWithClaims"])
  }
}

from CallNode c, Function func
where
  (
    c.getTarget() = func and
    // //Flow from NewParser to Parse (check that this call to Parse does not use a Parser that sets Valid Methods)
    (
      func instanceof SafeJwtParserMethod and
      not exists(CallNode c2, WithValidMethods wvm, NewParser m, int i |
        c2.getTarget() = m and
        (
          c2.getSyntacticArgument(i) = wvm.getACall() and
          DataFlow::localFlow(c2.getResult(0), c.getReceiver())
        )
      )
      or
      //ParserFunc creates a new default Parser on call that accepts all methods
      func instanceof SafeJwtParserFunc
    ) and
    //Check that the Parse(function or method) does not check the Token Method field, which most likely is a check for method type
    not exists(Field f |
      f.hasQualifiedName(golangJwtModern(), "Token", "Method") and
      (
        f.getARead().getRoot() = c.getCall().getArgument(1)
        or
        exists(FunctionName fn |
          c.getCall().getArgument(1) = fn and
          fn.toString() = f.getARead().asExpr().getEnclosingFunction().getName()
        )
      )
    )
  )
select c, "This Parse Call to Verify the JWT token may be vulnerable to algorithim confusion"
