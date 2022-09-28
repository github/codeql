/**
 * @name Android deep links
 * @description Android deep links
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 0.1
 * @id java/android/deeplinks
 * @tags security
 *       external/cwe/cwe-939
 * @precision high
 */

import java
import semmle.code.xml.AndroidManifest

// simple query for testing and MRVA results
// ! REMOVE this file
from AndroidActivityXmlElement actXmlElement
where
  actXmlElement.hasDeepLink() and
  not actXmlElement.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
select actXmlElement, "A deeplink is used here."
