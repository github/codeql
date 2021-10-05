/** Provides classes and predicates to reason about email vulnerabilities. */

import java
import semmle.code.java.frameworks.Mail
private import semmle.code.java.frameworks.Properties

/**
 * The insecure way to set Java properties in mail sessions.
 * 1. Set the `mail.smtp.auth` property to provide the SMTP Transport with a username and password when connecting to the SMTP server or
 *    set the `mail.smtp.ssl.socketFactory`/`mail.smtp.ssl.socketFactory.class` property to create an SMTP SSL socket.
 * 2. No `mail.smtp.ssl.checkserveridentity` property is enabled.
 */
predicate isInsecureMailPropertyConfig(Variable properties) {
  exists(MethodAccess ma |
    ma.getMethod() instanceof SetPropertyMethod and
    ma.getQualifier() = properties.getAnAccess()
  |
    getStringValue(ma.getArgument(0)).matches("%.auth%") and //mail.smtp.auth
    getStringValue(ma.getArgument(1)) = "true"
    or
    getStringValue(ma.getArgument(0)).matches("%.socketFactory%") //mail.smtp.socketFactory or mail.smtp.socketFactory.class
  ) and
  not exists(MethodAccess ma |
    ma.getMethod() instanceof SetPropertyMethod and
    ma.getQualifier() = properties.getAnAccess()
  |
    getStringValue(ma.getArgument(0)).matches("%.ssl.checkserveridentity%") and //mail.smtp.ssl.checkserveridentity
    getStringValue(ma.getArgument(1)) = "true"
  )
}

/**
 * Holds if `ma` enables TLS/SSL with Apache Email.
 */
predicate enablesEmailSsl(MethodAccess ma) {
  ma.getMethod().hasName(["setSSLOnConnect", "setStartTLSRequired"]) and
  ma.getMethod().getDeclaringType() instanceof ApacheEmail and
  ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
}

/**
 * Holds if a SSL certificate check is enabled on an access of `apacheEmail` with Apache Email.
 */
predicate hasSslCertificateCheck(Variable apacheEmail) {
  exists(MethodAccess ma |
    ma.getQualifier() = apacheEmail.getAnAccess() and
    ma.getMethod().hasName("setSSLCheckServerIdentity") and
    ma.getMethod().getDeclaringType() instanceof ApacheEmail and
    ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
  )
}

/**
 * Returns the string value of `expr` if it is a `CompileTimeConstantExpr`,
 * or the string value of its operands if it is an `AddExpr`.
 */
private string getStringValue(Expr expr) {
  result = expr.(CompileTimeConstantExpr).getStringValue()
  or
  result = getStringValue(expr.(AddExpr).getAnOperand())
}

/**
 * A method to set Java properties, either using the `Properties` class
 * or the `Dictionary` class.
 */
private class SetPropertyMethod extends Method {
  SetPropertyMethod() {
    this instanceof PropertiesSetPropertyMethod
    or
    this.hasName("put") and
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("java.util", "Dictionary")
  }
}
