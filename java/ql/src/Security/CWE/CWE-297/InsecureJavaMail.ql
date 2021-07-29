/**
 * @name Insecure JavaMail SSL Configuration
 * @description Configuring a Java application to use authenticated mail session
 *              over SSL without certificate validation
 *              makes the session susceptible to a man-in-the-middle attack.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/insecure-smtp-ssl
 * @tags security
 *       external/cwe/cwe-297
 */

import java
import semmle.code.java.security.Mail

from MethodAccess ma
where
  ma.getMethod() instanceof MailSessionGetInstanceMethod and
  isInsecureMailPropertyConfig(ma.getArgument(0))
  or
  enablesEmailSsl(ma) and not hasSslCertificateCheck(ma.getQualifier())
select ma, "Java mailing has insecure SSL configuration"
