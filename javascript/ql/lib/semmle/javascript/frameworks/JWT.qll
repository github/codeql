/**
 * Provides classes for working with JWT libraries.
 */

import javascript

/**
 * Provides classes and predicates modeling the `jwt-decode` library.
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
 * Provides classes and predicates modeling the `jsonwebtoken` library.
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
   * The secret or PrivateKey for a JWT as a `CredentialsNode`.
   */
  private class JwtKey extends CredentialsNode {
    JwtKey() {
      this =
        API::moduleImport("jsonwebtoken").getMember(["sign", "verify"]).getParameter(1).asSink()
    }

    override string getCredentialsKind() { result = "jwt key" }
  }
}

/**
 * Provides classes and predicates modeling the `jose` library.
 */
private module Jose {
  /**
   * The asymmetric key or symmetric secret for verifying a JWT as a `CredentialsNode`.
   */
  private class JwtVerifyKey extends CredentialsNode {
    JwtVerifyKey() {
      this = API::moduleImport("jose").getMember("jwtVerify").getParameter(1).asSink()
    }

    override string getCredentialsKind() { result = "jwt key" }
  }
}

/**
 * Provides classes and predicates modeling the `jwt-simple` library.
 */
private module JwtSimple {
  /**
   * The asymmetric key or symmetric secret for a JWT as a `CredentialsNode`.
   */
  private class JwtKey extends CredentialsNode {
    JwtKey() { this = API::moduleImport("jwt-simple").getMember("decode").getParameter(1).asSink() }

    override string getCredentialsKind() { result = "jwt key" }
  }
}

/**
 * Provides classes and predicates modeling the `koa-jwt` library.
 */
private module KoaJwt {
  /**
   * The shared secret for a JWT as a `CredentialsNode`.
   */
  private class SharedSecret extends CredentialsNode {
    SharedSecret() {
      this = API::moduleImport("koa-jwt").getParameter(0).getMember("secret").asSink()
    }

    override string getCredentialsKind() { result = "jwt key" }
  }
}

/**
 * Provides classes and predicates modeling the `express-jwt` library.
 */
private module ExpressJwt {
  /**
   * The shared secret for a JWT as a `CredentialsNode`.
   */
  private class SharedSecret extends CredentialsNode {
    SharedSecret() {
      this =
        API::moduleImport("express-jwt")
            .getMember("expressjwt")
            .getParameter(0)
            .getMember("secret")
            .asSink()
    }

    override string getCredentialsKind() { result = "jwt key" }
  }
}

/**
 * Provides classes and predicates modeling the `passport-jwt` library.
 */
private module PassportJwt {
  /**
   * The secret (symmetric) or PEM-encoded public key (asymmetric) for a JWT as a `CredentialsNode`.
   */
  private class JwtKey extends CredentialsNode {
    JwtKey() {
      this =
        API::moduleImport("passport-jwt")
            .getMember("Strategy")
            .getParameter(0)
            .getMember("secretOrKey")
            .asSink()
      or
      this =
        API::moduleImport("passport-jwt")
            .getMember("Strategy")
            .getParameter(0)
            .getMember("secretOrKeyProvider")
            .getParameter(2)
            .getParameter(1)
            .asSink()
    }

    override string getCredentialsKind() { result = "jwt key" }
  }
}
