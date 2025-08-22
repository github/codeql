/**
 * @name Android WebView JavaScript settings
 * @description Enabling JavaScript execution in a WebView can result in cross-site scripting attacks.
 * @kind problem
 * @id java/android/websettings-javascript-enabled
 * @problem.severity warning
 * @security-severity 6.1
 * @precision medium
 * @tags security
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.frameworks.android.WebView

from MethodCall ma
where
  ma.getMethod() instanceof AllowJavaScriptMethod and
  ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true
select ma, "JavaScript execution enabled in WebView."
