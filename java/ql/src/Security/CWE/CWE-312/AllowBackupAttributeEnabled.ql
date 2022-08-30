/**
 * @name Android allowBackup attribute enabled
 * @description
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @id java/android/allowbackup-enabled
 * @tags security
 *       external/cwe/cwe-312
 * @precision very-high
 */

import java
import semmle.code.xml.AndroidManifest

from AndroidApplicationXmlElement androidAppElem
where
  not androidAppElem.getFile().(AndroidManifestXmlFile).isInBuildDirectory() and
  (
    androidAppElem.allowsBackupExplicitly()
    or
    androidAppElem.providesMainIntent() and
    androidAppElem.allowsBackup()
  )
select androidAppElem, "The 'android:allowBackup' attribute is enabled."
