import java
import semmle.code.java.security.Mail
import TestUtilities.InlineExpectationsTest

class InsecureJavaMailTest extends InlineExpectationsTest {
  InsecureJavaMailTest() { this = "HasInsecureJavaMailTest" }

  override string getARelevantTag() { result = "hasInsecureJavaMail" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsecureJavaMail" and
    exists(MethodAccess ma |
      ma.getLocation() = location and
      element = ma.toString() and
      value = ""
    |
      ma.getMethod() instanceof MailSessionGetInstanceMethod and
      isInsecureMailPropertyConfig(ma.getArgument(0).(VarAccess).getVariable())
      or
      enablesEmailSsl(ma) and
      not hasSslCertificateCheck(ma.getQualifier().(VarAccess).getVariable())
    )
  }
}
