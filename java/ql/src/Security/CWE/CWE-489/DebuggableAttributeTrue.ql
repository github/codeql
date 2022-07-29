/**
 * @name Android debuggable attribute enabled
 * @description An enabled debugger can allow for entry points in the application or reveal sensitive information.
 * @kind problem
 * @problem.severity warning
 * @id java/android/debuggable-attribute-enabled
 * @tags security
 *       external/cwe/cwe-489
 * @precision very-high
 * @security-severity 0.1
 */

import java
import semmle.code.xml.AndroidManifest

from AndroidXmlAttribute androidXmlAttr
where
  androidXmlAttr.getName() = "debuggable" and
  androidXmlAttr.getValue() = "true" and
  not androidXmlAttr.getLocation().toString().matches("%/build/%")
select androidXmlAttr, "The 'debuggable' attribute is enabled."
