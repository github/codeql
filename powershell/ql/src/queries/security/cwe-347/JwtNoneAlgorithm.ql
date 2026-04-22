/**
 * @name JWT none algorithm usage
 * @description Using the "none" algorithm for JWT tokens disables signature verification,
 *              allowing token forgery.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id powershell/jwt-none-algorithm
 * @tags security
 *       external/cwe/cwe-347
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow

/**
 * A string literal "none" passed as an algorithm argument to .NET JWT methods
 * on a JwtSecurityTokenHandler instance.
 */
class JwtNoneInDotNetCall extends StringConstExpr {
  JwtNoneInDotNetCall() {
    this.getValueString().toLowerCase() = "none" and
    exists(DataFlow::CallNode cn, DataFlow::ObjectCreationNode ocn |
      cn.getQualifier().getALocalSource() = ocn and
      ocn.getConstructedTypeNode().asExpr().getExpr().(TypeNameExpr).hasQualifiedName("system.identitymodel.tokens.jwt", "jwtsecuritytokenhandler") and
      cn.getLowerCaseName() in [
          "createtoken", "writetoken", "createjwtsecuritytoken", "createencodedjwt"
        ] and
      cn.getAnArgument().asExpr().getExpr() = this
    )
  }
}

from JwtNoneInDotNetCall noneAlg
select noneAlg,
  "JWT token created with 'none' algorithm via .NET API, disabling signature verification."
