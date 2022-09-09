/**
 * @name Application backup allowed
 * @description Allowing application backups may allow an attacker to extract sensitive data.
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
select androidAppElem, "Backups are allowed in this Android application."
