/**
 * @id java/insecure-smtp-ssl
 * @name Insecure JavaMail SSL Configuration
 * @description Java application configured to use authenticated mail session over SSL does not validate the SSL certificate to properly ensure that it is actually associated with that host.
 * @kind problem
 * @tags security
 *       external/cwe-297
 */

import java

/**
 * The method to set Java properties
 */
class SetPropertyMethod extends Method {
  SetPropertyMethod() {
    this.hasName("setProperty") and
    this.getDeclaringType().hasQualifiedName("java.util", "Properties")
    or
    this.hasName("put") and
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("java.util", "Dictionary")
  }
}

/**
 * The insecure way to set Java properties in mail sessions.
 * 1. Set the mail.smtp.auth property to provide the SMTP Transport with a username and password when connecting to the SMTP server or
 *    set the mail.smtp.ssl.socketFactory/mail.smtp.ssl.socketFactory.class property to create an SMTP SSL socket.
 * 2. No mail.smtp.ssl.checkserveridentity property is enabled.
 */
predicate isInsecureMailPropertyConfig(VarAccess propertiesVarAccess) {
  exists(MethodAccess ma |
    ma.getMethod() instanceof SetPropertyMethod and
    ma.getQualifier() = propertiesVarAccess.getVariable().getAnAccess() and
    (
      getStringValue(ma.getArgument(0)).matches("%.auth%") and //mail.smtp.auth
      getStringValue(ma.getArgument(1)) = "true"
      or
      getStringValue(ma.getArgument(0)).matches("%.socketFactory%") //mail.smtp.socketFactory or mail.smtp.socketFactory.class
    )
  ) and
  not exists(MethodAccess ma |
    ma.getMethod() instanceof SetPropertyMethod and
    ma.getQualifier() = propertiesVarAccess.getVariable().getAnAccess() and
    (
      getStringValue(ma.getArgument(0)).matches("%.ssl.checkserveridentity%") and //mail.smtp.ssl.checkserveridentity
      getStringValue(ma.getArgument(1)) = "true"
    )
  )
}

/**
 * Helper method to get string value of an argument
 */
string getStringValue(Expr expr) {
  result = expr.(CompileTimeConstantExpr).getStringValue()
  or
  result = getStringValue(expr.(AddExpr).getLeftOperand())
  or
  result = getStringValue(expr.(AddExpr).getRightOperand())
}

/**
 * The JavaMail session class `javax.mail.Session`
 */
class MailSession extends RefType {
  MailSession() { this.hasQualifiedName("javax.mail", "Session") }
}

/**
 * The class of Apache SimpleMail
 */
class SimpleMail extends RefType {
  SimpleMail() { this.hasQualifiedName("org.apache.commons.mail", "SimpleEmail") }
}

/**
 * Has TLS/SSL enabled with SimpleMail
 */
predicate enableTLSWithSimpleMail(MethodAccess ma) {
  ma.getMethod().hasName("setSSLOnConnect") and
  ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
}

/**
 * Has no certificate check
 */
predicate hasNoCertCheckWithSimpleMail(VarAccess va) {
  not exists(MethodAccess ma |
    ma.getQualifier() = va.getVariable().getAnAccess() and
    ma.getMethod().hasName("setSSLCheckServerIdentity") and
    ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
  )
}

from MethodAccess ma
where
  ma.getMethod().getDeclaringType() instanceof MailSession and
  ma.getMethod().getName() = "getInstance" and
  isInsecureMailPropertyConfig(ma.getArgument(0))
  or
  enableTLSWithSimpleMail(ma) and hasNoCertCheckWithSimpleMail(ma.getQualifier())
select ma, "Java mailing has insecure SSL configuration"
