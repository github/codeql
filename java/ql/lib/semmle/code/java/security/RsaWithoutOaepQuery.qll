/** Definitions for the RSE without OAEP query */

import java
import semmle.code.java.dataflow.DataFlow

/** Holds if `ma` is a call to `Cipher.getInstance` which initialises an RSA cipher without using OAEP padding. */
predicate rsaWithoutOaepCall(MethodAccess ma) {
  ma.getMethod().hasQualifiedName("javax.crypto", "Cipher", "getInstance") and
  exists(CompileTimeConstantExpr specExpr, string spec |
    specExpr.getStringValue() = spec and
    DataFlow::localExprFlow(specExpr, ma.getArgument(0)) and
    spec.matches("RSA/%") and
    not spec.matches("%OAEP%")
  )
}
