/**
 * @name Android allowBackup attribute enabled
 * @description Android manifests which do not disable the `android:allowBackup` attribute allow backups, which can store sensitive information.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @id java/android/backup-enabled
 * @tags security
 *       external/cwe/cwe-312
 * @precision very-high
 */

import java
import semmle.code.xml.AndroidManifest

from AndroidApplicationXmlElement androidAppElem
where androidAppElem.allowsBackup()
select androidAppElem, "The 'android:allowBackup' attribute is enabled."
