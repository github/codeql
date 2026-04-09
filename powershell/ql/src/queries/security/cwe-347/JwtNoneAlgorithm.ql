/**
 * @name JWT none algorithm usage
 * @description Using the "none" algorithm for JWT tokens disables signature verification,
 *              allowing token forgery.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id powershell/microsoft/security/jwt-none-algorithm
 * @tags security
 *       external/cwe/cwe-347
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow

// NOTE: PowerShell is a beta language for CodeQL and has no built-in JWT library modeling.
// This query detects common patterns of JWT "none" algorithm usage in PowerShell modules
// such as PSJwt, JWTPS, and direct .NET JWT library calls.
// Coverage may be limited for less common JWT libraries.

/**
 * A string literal containing "none" used in a JWT-related cmdlet call.
 */
class JwtNoneAlgorithmLiteral extends StringConstExpr {
  JwtNoneAlgorithmLiteral() {
    this.getValueString().toLowerCase() = "none" and
    exists(CmdCall call |
      call.matchesName([
          "New-Jwt", "New-JsonWebToken", "ConvertTo-Jwt",
          "New-JWTToken", "ConvertTo-JWTToken"
        ]) and
      this = call.getAnArgument()
    )
  }
}

/**
 * A string literal "none" passed as an algorithm argument to .NET JWT methods.
 */
class JwtNoneInDotNetCall extends StringConstExpr {
  JwtNoneInDotNetCall() {
    this.getValueString().toLowerCase() = "none" and
    exists(InvokeMemberExpr call |
      call.matchesName([
          "CreateToken", "WriteToken", "CreateJwtSecurityToken", "CreateEncodedJwt"
        ]) and
      this = call.getAnArgument()
    )
  }
}

from StringConstExpr noneAlg, string msg
where
  (
    noneAlg instanceof JwtNoneAlgorithmLiteral and
    msg = "JWT token created with 'none' algorithm, disabling signature verification."
  )
  or
  (
    noneAlg instanceof JwtNoneInDotNetCall and
    msg =
      "JWT token created with 'none' algorithm via .NET API, disabling signature verification."
  )
select noneAlg, msg
