/**
 * @name Unsafe certificate trust
 * @description SSLSocket/SSLEngine ignores all SSL certificate validation
 *              errors when establishing an HTTPS connection, thereby making
 *              the app vulnerable to man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/unsafe-cert-trust
 * @tags security
 *       external/cwe/cwe-273
 */

import java
import semmle.code.java.security.Encryption

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
  aa instanceof SSLEndpointIdentificationNotSet or
  aa instanceof RabbitMQEnableHostnameVerificationNotSet
select aa, "Unsafe configuration of trusted certificates"
