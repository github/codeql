/**
 * @name Unsafe certificate trust and improper hostname verification
 * @description Unsafe implementation of the interface X509TrustManager, HostnameVerifier, and SSLSocket/SSLEngine ignores all SSL certificate validation errors when establishing an HTTPS connection, thereby making the app vulnerable to man-in-the-middle attacks.
 * @kind problem
 * @id java/unsafe-cert-trust
 * @tags security
 *       external/cwe-273
 */

import java
import semmle.code.java.security.Encryption

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
        this.getArgument(0).getType() = nc //Scenario of HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {...});
      )
      or
      exists(Variable v |
        this.getArgument(0).(VarAccess).getVariable() = v and
        v.getInitializer().getType() instanceof TrustAllHostnameVerifier //Scenario of HttpsURLConnection.setDefaultHostnameVerifier(verifier);
      )
    )
  }
}

class SSLEngine extends RefType {
  SSLEngine() { this.hasQualifiedName("javax.net.ssl", "SSLEngine") }
}

class Socket extends RefType {
  Socket() { this.hasQualifiedName("java.net", "Socket") }
}

class SocketFactory extends RefType {
  SocketFactory() { this.hasQualifiedName("javax.net", "SocketFactory") }
}

class SSLSocket extends RefType {
  SSLSocket() { this.hasQualifiedName("javax.net.ssl", "SSLSocket") }
}

/**
 * has setEndpointIdentificationAlgorithm set correctly
 */
predicate setEndpointIdentificationAlgorithm(MethodAccess createSSL) {
  exists(
    Variable sslo, MethodAccess ma, Variable sslparams //setSSLParameters with valid setEndpointIdentificationAlgorithm set
  |
    createSSL = sslo.getAnAssignedValue() and
    ma.getQualifier() = sslo.getAnAccess() and
    ma.getMethod().hasName("setSSLParameters") and
    ma.getArgument(0) = sslparams.getAnAccess() and
    exists(MethodAccess setepa |
      setepa.getQualifier() = sslparams.getAnAccess() and
      setepa.getMethod().hasName("setEndpointIdentificationAlgorithm") and
      not setepa.getArgument(0) instanceof NullLiteral
    )
  )
}

/**
 * has setEndpointIdentificationAlgorithm set correctly
 */
predicate hasEndpointIdentificationAlgorithm(Variable ssl) {
  exists(
    MethodAccess ma, Variable sslparams //setSSLParameters with valid setEndpointIdentificationAlgorithm set
  |
    ma.getQualifier() = ssl.getAnAccess() and
    ma.getMethod().hasName("setSSLParameters") and
    ma.getArgument(0) = sslparams.getAnAccess() and
    exists(MethodAccess setepa |
      setepa.getQualifier() = sslparams.getAnAccess() and
      setepa.getMethod().hasName("setEndpointIdentificationAlgorithm") and
      not setepa.getArgument(0) instanceof NullLiteral
    )
  )
}

/**
 * Cast of Socket to SSLSocket
 */
predicate sslCast(MethodAccess createSSL) {
  exists(Variable ssl, CastExpr ce |
    ce.getExpr() = createSSL and
    ce.getControlFlowNode().getASuccessor().(VariableAssign).getDestVar() = ssl and
    ssl.getType() instanceof SSLSocket //With a type cast `SSLSocket socket = (SSLSocket) socketFactory.createSocket("www.example.com", 443)`
  )
}

/**
 * SSL object is created in a separate method call or in the same method
 */
predicate hasFlowPath(MethodAccess createSSL, Variable ssl) {
  (
    createSSL = ssl.getAnAssignedValue()
    or
    exists(CastExpr ce |
      ce.getExpr() = createSSL and
      ce.getControlFlowNode().getASuccessor().(VariableAssign).getDestVar() = ssl //With a type cast like SSLSocket socket = (SSLSocket) socketFactory.createSocket("www.example.com", 443);
    )
  )
  or
  exists(MethodAccess tranm |
    createSSL.getEnclosingCallable() = tranm.getMethod() and
    tranm.getControlFlowNode().getASuccessor().(VariableAssign).getDestVar() = ssl and
    not setEndpointIdentificationAlgorithm(createSSL) //Check the scenario of invocation before used in the current method
  )
}

/**
 * Not have the SSLParameter set
 */
predicate hasNoEndpointIdentificationSet(MethodAccess createSSL, Variable ssl) {
  //No setSSLParameters set
  hasFlowPath(createSSL, ssl) and
  not exists(MethodAccess ma |
    ma.getQualifier() = ssl.getAnAccess() and
    ma.getMethod().hasName("setSSLParameters")
  )
  or
  //No endpointIdentificationAlgorithm set with setSSLParameters
  hasFlowPath(createSSL, ssl) and
  not setEndpointIdentificationAlgorithm(createSSL)
}

/**
 * The setEndpointIdentificationAlgorithm method of SSLParameters with the ssl engine or socket
 */
class SSLEndpointIdentificationNotSet extends MethodAccess {
  SSLEndpointIdentificationNotSet() {
    (
      this.getMethod().hasName("createSSLEngine") and
      this.getMethod().getDeclaringType() instanceof SSLContext //createEngine method of SSLContext
      or
      this.getMethod().hasName("createSocket") and
      this.getMethod().getDeclaringType() instanceof SocketFactory and
      this.getMethod().getReturnType() instanceof Socket and
      sslCast(this) //createSocket method of SocketFactory
    ) and
    exists(Variable ssl |
      hasNoEndpointIdentificationSet(this, ssl) and //Not set in itself
      not exists(VariableAssign ar, Variable newSsl |
        ar.getSource() = this.getCaller().getAReference() and
        ar.getDestVar() = newSsl and
        hasEndpointIdentificationAlgorithm(newSsl) //Not set in its caller either
      )
    ) and
    not exists(MethodAccess ma | ma.getMethod() instanceof HostnameVerifierVerify) //Reduce false positives since this method access set default hostname verifier
  }
}

class RabbitMQConnectionFactory extends RefType {
  RabbitMQConnectionFactory() { this.hasQualifiedName("com.rabbitmq.client", "ConnectionFactory") }
}

/**
 * The com.rabbitmq.client.ConnectionFactory useSslProtocol method access without enableHostnameVerification
 */
class RabbitMQEnableHostnameVerificationNotSet extends MethodAccess {
  RabbitMQEnableHostnameVerificationNotSet() {
    this.getMethod().hasName("useSslProtocol") and
    this.getMethod().getDeclaringType() instanceof RabbitMQConnectionFactory and
    exists(Variable v |
      v.getType() instanceof RabbitMQConnectionFactory and
      this.getQualifier() = v.getAnAccess() and
      not exists(MethodAccess ma |
        ma.getMethod().hasName("enableHostnameVerification") and
        ma.getQualifier() = v.getAnAccess()
      )
    )
  }
}

from MethodAccess aa
where
  aa instanceof TrustAllHostnameVerify or
  aa instanceof X509TrustAllManagerInit or
  aa instanceof SSLEndpointIdentificationNotSet or
  aa instanceof RabbitMQEnableHostnameVerificationNotSet
select aa, "Unsafe configuration of trusted certificates"
