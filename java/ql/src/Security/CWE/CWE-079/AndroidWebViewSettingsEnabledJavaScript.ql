/**
 * @name Android WebView JavaScript settings
 * @description Enabling JavaScript execution in a WebView can result in man-in-the-middle attacks.
 * @kind problem
 * @id java/android-websettings-javascript-enabled
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @tags security
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.frameworks.android.WebView

from MethodAccess ma
where
  ma.getMethod() instanceof AllowJavaScriptMethod and
  ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true
select ma, "JavaScript execution enabled in WebView."
