/**
 * @name Android sensitive keyboard cache
 * @description Allowing the keyboard to cache sensitive information may result in information leaks to other applications.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @id java/android/sensitive-keyboard-cache
 * @tags security
 *       external/cwe/cwe-524
 * @precision medium
 */

import java
import semmle.code.java.security.SensitiveKeyboardCacheQuery

from AndroidEditableXmlElement el
where el = getASensitiveCachedInput()
select el, "This input field may contain sensitive information that is saved to the keyboard cache."
