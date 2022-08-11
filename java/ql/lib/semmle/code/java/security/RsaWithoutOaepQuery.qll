/** Definitions for the RSA without OAEP query */

import java
import Encryption
import semmle.code.java.dataflow.DataFlow

/** Holds if `c` is a call which initialises an RSA cipher without using OAEP padding. */
predicate rsaWithoutOaepCall(CryptoAlgoSpec c) {
  exists(CompileTimeConstantExpr specExpr, string spec |
    specExpr.getStringValue() = spec and
    DataFlow::localExprFlow(specExpr, c.getAlgoSpec()) and
    spec.matches("RSA/%") and
    not spec.matches("%OAEP%")
  )
}
