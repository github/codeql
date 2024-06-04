/**
 * @name Android WebSettings file access
 * @kind problem
 * @description Enabling access to the file system in a WebView allows attackers to view sensitive information.
 * @id java/android/websettings-file-access
 * @problem.severity warning
 * @security-severity 6.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import semmle.code.java.frameworks.android.WebView

from MethodCall ma
where
  ma.getMethod() instanceof CrossOriginAccessMethod and
  ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true
select ma,
  "WebView setting " + ma.getMethod().getName() +
    " may allow for unauthorized access of sensitive information."
