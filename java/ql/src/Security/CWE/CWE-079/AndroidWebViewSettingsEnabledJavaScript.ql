/**
 * @name Android WebView JavaScript settings
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
  (
    ma.getMethod() instanceof AllowJavaScriptMethod and
    ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true
  )
select ma, "JavaScript execution enabled in WebView."
