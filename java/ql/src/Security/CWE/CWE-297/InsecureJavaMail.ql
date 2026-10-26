/**
 * @name Insecure JavaMail SSL Configuration
 * @description Configuring a Java application to use authenticated mail session
 *              over SSL without certificate validation
 *              makes the session susceptible to a man-in-the-middle attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.9
 * @precision medium
 * @id java/insecure-smtp-ssl
 * @tags security
 *       external/cwe/cwe-297
 */

import java
import semmle.code.java.security.Mail

from MethodCall ma
where
  ma.getMethod() instanceof MailSessionGetInstanceMethod and
  isInsecureMailPropertyConfig(ma.getArgument(0).(VarAccess).getVariable())
  or
  enablesEmailSsl(ma) and not hasSslCertificateCheck(ma.getQualifier().(VarAccess).getVariable())
select ma, "Java mailing has insecure SSL configuration."
