/**
 * @name Unsafe certificate trust
 * @description Unsafe implementation of a `X509TrustManager`, thereby making the app vulnerable to man-in-the-middle attacks.
 * @kind problem
 * @id java/unsafe-cert-trust
 * @tags security
 *       external/cwe-295
 */

import java
import semmle.code.java.security.Encryption

/**
 * A `X509TrustManager` class that blindly trusts all certificates in server SSL authentication.
 */
class X509TrustAllManager extends RefType {
  X509TrustAllManager() {
    this.getASupertype*() instanceof X509TrustManager and
    exists(Method m1 |
      m1.getDeclaringType() = this and
      m1.hasName("checkServerTrusted") and
      m1.getBody().getNumStmt() = 0
    ) and
    exists(Method m2, ReturnStmt rt2 |
      m2.getDeclaringType() = this and
      m2.hasName("getAcceptedIssuers") and
      rt2.getEnclosingCallable() = m2 and
      rt2.getResult() instanceof NullLiteral
    )
  }
}

/**
 * The init method of SSLContext with the trust all manager, which is sslContext.init(..., serverTMs, ...)
 */
class X509TrustAllManagerInit extends MethodAccess {
  X509TrustAllManagerInit() {
    this.getMethod().hasName("init") and
    this.getMethod().getDeclaringType() instanceof SSLContext and //init method of SSLContext
    (
      exists(ArrayInit ai |
        this.getArgument(1).(ArrayCreationExpr).getInit() = ai and
        ai.getInit(0).(VarAccess).getVariable().getInitializer().getType().(Class).getASupertype*()
          instanceof X509TrustAllManager //Scenario of context.init(null, new TrustManager[] { TRUST_ALL_CERTIFICATES }, null);
      )
      or
      exists(Variable v, ArrayInit ai |
        this.getArgument(1).(VarAccess).getVariable() = v and
        ai.getParent() = v.getAnAssignedValue() and
        ai.getInit(0).getType().(Class).getASupertype*() instanceof X509TrustAllManager //Scenario of context.init(null, serverTMs, null);
      )
    )
  }
}

from MethodAccess ma
where ma instanceof X509TrustAllManagerInit
select ma, "Unsafe configuration of trusted certificates"
