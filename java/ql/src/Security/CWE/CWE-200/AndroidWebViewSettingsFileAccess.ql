/**
 * @name Android WebSettings file access
 * @kind problem
 * @id java/android-websettings-file-access
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import semmle.code.java.frameworks.android.WebView

from MethodAccess ma
where ma.getMethod() instanceof CrossOriginAccessMethod
select ma, "WebView setting $@ may allow for unauthorized access of sensitive information.", ma,
  ma.getMethod().getName()
