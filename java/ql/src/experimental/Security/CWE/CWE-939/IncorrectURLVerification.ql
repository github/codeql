/**
 * @id java/incorrect-url-verification
 * @name Incorrect URL verification
 * @description Apps that rely on URL parsing to verify that a given URL is pointing to a trusted server are susceptible to wrong ways of URL parsing and verification.
 * @kind problem
 * @tags security
 *       external/cwe-939
 */

import java

/**
 * The Java class `android.R.string` specific to Android applications, which contains references to application specific resources defined in /res/values/strings.xml.
 * For example, <resources>...<string name="host">example.com</string>...</resources> in the application com.example.android.web can be referred as R.string.host with the type com.example.android.web.R$string
 */
class AndroidRString extends RefType {
  AndroidRString() { this.hasQualifiedName(_, "R$string") }
}

/**
 * The Java class `android.net.Uri` and `java.net.URL`.
 */
class Uri extends RefType {
  Uri() {
    hasQualifiedName("android.net", "Uri") or
    hasQualifiedName("java.net", "URL")
  }
}

/**
 * The method `getHost()` declared in `android.net.Uri` and `java.net.URL`.
 */
class UriGetHostMethod extends Method {
  UriGetHostMethod() {
    getDeclaringType() instanceof Uri and
    hasName("getHost") and
    getNumberOfParameters() = 0
  }
}

/**
 * The method access with incorrect string comparision
 */
class HostVerificationMethodAccess extends MethodAccess {
  HostVerificationMethodAccess() {
    (
      this.getMethod().hasName("endsWith") or
      this.getMethod().hasName("contains") or
      this.getMethod().hasName("indexOf")
    ) and
    this.getMethod().getNumberOfParameters() = 1 and
    (
      this.getArgument(0).(StringLiteral).getRepresentedString().charAt(0) != "." //string constant comparison e.g. uri.getHost().endsWith("example.com")
      or
      this
          .getArgument(0)
          .(AddExpr)
          .getLeftOperand()
          .(VarAccess)
          .getVariable()
          .getAnAssignedValue()
          .(StringLiteral)
          .getRepresentedString()
          .charAt(0) != "." //var1+var2, check var1 starts with "." e.g. String domainName = "example"; Uri.parse(url).getHost().endsWith(domainName+".com")
      or
      this
          .getArgument(0)
          .(AddExpr)
          .getLeftOperand()
          .(StringLiteral)
          .getRepresentedString()
          .charAt(0) != "." //"."+var2, check string constant "." e.g. String domainName = "example.com";  Uri.parse(url).getHost().endsWith("www."+domainName)
      or
      exists(MethodAccess ma, Method m, Field f |
        this.getArgument(0) = ma and
        ma.getMethod() = m and
        m.hasName("getString") and
        m.getDeclaringType().getQualifiedName() = "android.content.res.Resources" and
        ma.getArgument(0).(FieldRead).getField() = f and
        f.getDeclaringType() instanceof AndroidRString
      ) //Check resource properties in /res/values/strings.xml in Android mobile applications using res.getString(R.string.key)
      or
      this
          .getArgument(0)
          .(VarAccess)
          .getVariable()
          .getAnAssignedValue()
          .(StringLiteral)
          .getRepresentedString()
          .charAt(0) != "." //check variable starts with "." e.g. String domainName = "example.com";  Uri.parse(url).getHost().endsWith(domainName)
    )
  }
}

from UriGetHostMethod um, MethodAccess uma, HostVerificationMethodAccess hma
where hma.getQualifier() = uma and uma.getMethod() = um
select hma, "Method has potentially $@ ", hma.getArgument(0), "improper URL verification"
