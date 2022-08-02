/**
 * @name Implicitly imported Android component
 * @description TODO after more background reading
 * @kind problem (TODO: confirm after more background reading)
 * @problem.severity warning (TODO: confirm after more background reading)
 * @security-severity 0.1 (TODO: run script)
 * @id java/android/implicitly-imported-component
 * @tags security
 *       external/cwe/cwe-926
 * @precision TODO after MRVA
 */

import java
import semmle.code.xml.AndroidManifest

// TODO: change query
from AndroidXmlAttribute androidXmlAttr
where
  androidXmlAttr.getName() = "debuggable" and
  androidXmlAttr.getValue() = "true" and
  not androidXmlAttr.getLocation().getFile().getRelativePath().matches("%build%")
select androidXmlAttr, "The 'android:debuggable' attribute is enabled."
