/**
 * @id java/unsafe-cert-trust
 * @name Unsafe implementation of trusting any certificate in SSL configuration
 * @description Unsafe implementation of the interface X509TrustManager and HostnameVerifier ignores all SSL certificate validation errors when establishing an HTTPS connection, thereby making the app vulnerable to man-in-the-middle attacks.
 * @kind problem
 * @tags security
 *       external/cwe-273
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow
import DataFlow

/**
 * X509TrustManager class that blindly trusts all certificates in server SSL authentication
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
        ai.getInit(0).(VarAccess).getVariable().getInitializer().getType().(Class).getASupertype*()
          instanceof X509TrustAllManager //Scenario of context.init(null, new TrustManager[] { TRUST_ALL_CERTIFICATES }, null);
      )
      or
      exists(Variable v, ArrayInit ai |
        this.getArgument(1).(VarAccess).getVariable() = v and
        ai.getParent() = v.getAnAccess().getVariable().getAnAssignedValue() and
        ai.getInit(0).getType().(Class).getASupertype*() instanceof X509TrustAllManager //Scenario of context.init(null, serverTMs, null);
      )
    )
  }
}

/**
 * HostnameVerifier class that allows a certificate whose CN (Common Name) does not match the host name in the URL
 */
class TrustAllHostnameVerifier extends RefType {
  TrustAllHostnameVerifier() {
    this.getASupertype*() instanceof HostnameVerifier and
    exists(Method m, ReturnStmt rt |
      m.getDeclaringType() = this and
      m.hasName("verify") and
      rt.getEnclosingCallable() = m and
      rt.getResult().(BooleanLiteral).getBooleanValue() = true
    )
  }
}

/**
 * The setDefaultHostnameVerifier method of HttpsURLConnection with the trust all configuration
 */
class TrustAllHostnameVerify extends MethodAccess {
  TrustAllHostnameVerify() {
    this.getMethod().hasName("setDefaultHostnameVerifier") and
    this.getMethod().getDeclaringType() instanceof HttpsURLConnection and //httpsURLConnection.setDefaultHostnameVerifier method
    (
      exists(NestedClass nc |
        nc.getASupertype*() instanceof TrustAllHostnameVerifier and
        this.getArgument(0).getType() = nc  //Scenario of HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {...});
      )
      or
      exists(Variable v |
        this.getArgument(0).(VarAccess).getVariable() = v.getAnAccess().getVariable() and
        v.getInitializer().getType() instanceof TrustAllHostnameVerifier //Scenario of HttpsURLConnection.setDefaultHostnameVerifier(verifier);
      )
    )
  }
}

from MethodAccess aa
where aa instanceof TrustAllHostnameVerify or aa instanceof X509TrustAllManagerInit
select aa, "Unsafe configuration of trusted certificates"