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
  private class JwtDecodeStep extends TaintTracking::SharedTaintStep {
    override predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::moduleImport("jwt-decode").getACall() and
        pred = call.getArgument(0) and
        succ = call
      )
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
  private class VerifyStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::moduleMember("jsonwebtoken", "verify").getACall() and
        pred = call.getArgument(0) and
        succ = call.getABoundCallbackParameter(2, 1)
      )
    }
  }

  /**
   * The private key for a JWT as a `CredentialsExpr`.
   */
  private class JwtKey extends CredentialsExpr {
    JwtKey() {
      this = DataFlow::moduleMember("jsonwebtoken", "sign").getACall().getArgument(1).asExpr()
    }

    override string getCredentialsKind() { result = "key" }
  }
}
