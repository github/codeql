/** Provides classes and predicates to work with email */

import java

/**
 * The class `javax.mail.Session` or `jakarta.mail.Session`.
 */
class MailSession extends Class {
  MailSession() { this.hasQualifiedName(["javax.mail", "jakarta.mail"], "Session") }
}

/**
 * The method `getInstance` of the classes `javax.mail.Session` or `jakarta.mail.Session`.
 */
class MailSessionGetInstanceMethod extends Method {
  MailSessionGetInstanceMethod() {
    this.getDeclaringType() instanceof MailSession and
    this.getName() = "getInstance"
  }
}

/**
 * A subtype of the class `org.apache.commons.mail.Email`.
 */
class ApacheEmail extends Class {
  ApacheEmail() { this.getAnAncestor().hasQualifiedName("org.apache.commons.mail", "Email") }
}
