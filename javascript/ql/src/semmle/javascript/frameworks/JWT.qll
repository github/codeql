/**
 * Provides classes for working with JWT libraries.
 */

import javascript

/**
 * Provides classes and predicates modeling the `jwt-decode` libary.
 */
private module JwtDecode {
  /**
   * A taint-step for `succ = require("jwt-decode")(pred)`.
   */
  private class JwtDecodeStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    JwtDecodeStep() { this = DataFlow::moduleImport("jwt-decode").getACall() }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = this.getArgument(0) and
      succ = this
    }
  }
}

/**
 * Provides classes and predicates modeling the `jsonwebtoken` libary.
 */
private module JsonWebToken {
  /**
   * A taint-step for `require("jsonwebtoken").verify(pred, "key", (err succ) => {...})`.
   */
  private class VerifyStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    VerifyStep() { this = DataFlow::moduleMember("jsonwebtoken", "verify").getACall() }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = this.getArgument(0) and
      succ = this.getABoundCallbackParameter(2, 1)
    }
  }

  /**
   * The private key for a JWT as a `CredentialsExpr`.
   */
  private class JWTKey extends CredentialsExpr {
    JWTKey() {
      this = DataFlow::moduleMember("jsonwebtoken", "sign").getACall().getArgument(1).asExpr()
    }

    override string getCredentialsKind() { result = "key" }
  }
}
