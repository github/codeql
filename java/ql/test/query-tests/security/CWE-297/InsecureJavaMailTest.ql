import java
import semmle.code.java.security.Mail
import utils.test.InlineExpectationsTest

module InsecureJavaMailTest implements TestSig {
  string getARelevantTag() { result = "hasInsecureJavaMail" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsecureJavaMail" and
    exists(MethodCall ma |
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

import MakeTest<InsecureJavaMailTest>
