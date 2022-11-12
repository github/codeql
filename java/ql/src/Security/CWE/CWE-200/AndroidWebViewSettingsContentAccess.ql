/**
 * @name Android WebSettings content access
 * @description Access to content providers in a WebView can enable JavaScript to access protected information.
 * @kind problem
 * @id java/android-websettings-content-access
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import semmle.code.java.frameworks.android.WebView

from MethodAccess ma
where
  ma.getMethod() instanceof AllowContentAccessMethod and
  ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true
select ma,
  "Sensitive information may be exposed via a malicious link due to access of content:// links being permitted."
