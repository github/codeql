// TODO: Fix up metadata
/**
 * @name Debuggable set to true
 * @description The 'debuggable' attribute in the application section of the AndroidManifest.xml file should never be enabled in production builds // TODO: edit to be in-line wth guidelines
 * @kind problem
 * @problem.severity warning
 * @id java/android/debuggable-true // TODO: consider editing
 * @tags security                   // TODO: look into CWEs some more
 *       external/cwe/cwe-489
 *       external/cwe/cwe-710
 * @precision high                  // TODO: adjust once review query results and FP ratio
 * @security-severity 0.1           // TODO: auto-calculated: https://github.blog/changelog/2021-07-19-codeql-code-scanning-new-severity-levels-for-security-alerts/
 */

import java
import semmle.code.xml.AndroidManifest

from AndroidXmlAttribute androidXmlAttr
where
  androidXmlAttr.getName() = "debuggable" and
  androidXmlAttr.getValue() = "true"
select androidXmlAttr, "Warning: 'android:debuggable=true' set"
