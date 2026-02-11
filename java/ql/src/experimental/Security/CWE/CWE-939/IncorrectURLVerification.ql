/**
 * @name Incorrect URL verification
 * @description Apps that rely on URL parsing to verify that a given URL is
 *              pointing to a trusted server are susceptible to wrong ways of
 *              URL parsing and verification.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/incorrect-url-verification
 * @tags security
 *       experimental
 *       external/cwe/cwe-939
 */

import java

/**
 * The Java class `android.R.string` specific to Android applications, which contains references to application specific resources defined in /res/values/strings.xml.
 * For example, `<resources>...<string name="host">example.com</string>...</resources>` in the application com.example.android.web can be referred as R.string.host with the type com.example.android.web.R$string
 */
class AndroidRString extends RefType {
  AndroidRString() { this.hasQualifiedName(_, "R$string") }
}

/**
 * The Java class `android.net.Uri` and `java.net.URL`.
 */
class Uri extends RefType {
  Uri() {
    this.hasQualifiedName("android.net", "Uri") or
    this.hasQualifiedName("java.net", "URL")
  }
}

/**
 * The method `getHost()` declared in `android.net.Uri` and `java.net.URL`.
 */
class UriGetHostMethod extends Method {
  UriGetHostMethod() {
    this.getDeclaringType() instanceof Uri and
    this.hasName("getHost") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method access with incorrect string comparison
 */
class HostVerificationMethodCall extends MethodCall {
  HostVerificationMethodCall() {
    (
      this.getMethod().hasName("endsWith") or
      this.getMethod().hasName("contains") or
      this.getMethod().hasName("indexOf")
    ) and
    this.getMethod().getNumberOfParameters() = 1 and
    (
      this.getArgument(0).(StringLiteral).getValue().charAt(0) != "." //string constant comparison e.g. uri.getHost().endsWith("example.com")
      or
      this.getArgument(0)
          .(AddExpr)
          .getLeftOperand()
          .(VarAccess)
          .getVariable()
          .getAnAssignedValue()
          .(StringLiteral)
          .getValue()
          .charAt(0) != "." //var1+var2, check var1 starts with "." e.g. String domainName = "example"; Uri.parse(url).getHost().endsWith(domainName+".com")
      or
      this.getArgument(0).(AddExpr).getLeftOperand().(StringLiteral).getValue().charAt(0) != "." //"."+var2, check string constant "." e.g. String domainName = "example.com";  Uri.parse(url).getHost().endsWith("www."+domainName)
      or
      exists(MethodCall ma, Method m, Field f |
        this.getArgument(0) = ma and
        ma.getMethod() = m and
        m.hasQualifiedName("android.content.res", "Resources", "getString") and
        ma.getArgument(0).(FieldRead).getField() = f and
        f.getDeclaringType() instanceof AndroidRString
      ) //Check resource properties in /res/values/strings.xml in Android mobile applications using res.getString(R.string.key)
      or
      this.getArgument(0)
          .(VarAccess)
          .getVariable()
          .getAnAssignedValue()
          .(StringLiteral)
          .getValue()
          .charAt(0) != "." //check variable starts with "." e.g. String domainName = "example.com";  Uri.parse(url).getHost().endsWith(domainName)
    )
  }
}

deprecated query predicate problems(
  HostVerificationMethodCall hma, string message1, Expr arg, string message2
) {
  exists(UriGetHostMethod um, MethodCall uma | hma.getQualifier() = uma and uma.getMethod() = um) and
  message1 = "Method has potentially $@." and
  arg = hma.getArgument(0) and
  message2 = "improper URL verification"
}
