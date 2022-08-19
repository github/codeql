/**
 * @name Android allowBackup attribute enabled
 * @description
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @id java/android/allowBackup-attribute-enabled
 * @tags security
 *       external/cwe/cwe-312
 * @precision very-high
 */

import java
import semmle.code.xml.AndroidManifest

from AndroidApplicationXmlElement androidAppElem
where
  androidAppElem.allowsBackup() and
  androidAppElem.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
select androidAppElem, "The 'android:allowBackup' attribute is enabled."
