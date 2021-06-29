import java
import DataFlow
import experimental.semmle.code.java.Logging
import semmle.code.java.dataflow.FlowSources

/**
 * A String replacement method. This is either `String.replace` or `String.replaceAll`.
 */
class ReplaceMethod extends Method {
  ReplaceMethod() {
    this.getName() in ["replace", "replaceAll"] and
    this.getDeclaringType() instanceof TypeString and
    this.getNumberOfParameters() = 2
  }
}

/** The method `org.apache.commons.mail.Email.setSubject`. */
class EmailSetSubjectMethod extends Method {
  EmailSetSubjectMethod() {
    this.getDeclaringType().hasQualifiedName("org.apache.commons.mail", "Email") and
    this.hasName("setSubject")
  }
}

/** The method `javax.mail.internet.MimeMessage.setSubject`. */
class MimeMessageSetSubjectMethod extends Method {
  MimeMessageSetSubjectMethod() {
    this.getDeclaringType().hasQualifiedName("javax.mail.internet", "MimeMessage") and
    this.hasName("setSubject")
  }
}

/** A sink for crlf injection vulnerabilities. */
class CrlfInjectionSink extends DataFlow::ExprNode {
  CrlfInjectionSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() and ma.getAnArgument() = this.getExpr() |
      m instanceof MimeMessageSetSubjectMethod or
      m instanceof EmailSetSubjectMethod
    )
    or
    exists(LoggingCall c | c.getALogArgument() = this.asExpr())
  }
}
