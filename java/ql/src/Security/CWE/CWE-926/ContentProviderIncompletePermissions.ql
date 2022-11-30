/**
 * @name Missing read or write permission in a content provider
 * @description Android content providers which do not configure both read and write permissions can allow permission bypass.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.2
 * @id java/android/incomplete-provider-permissions
 * @tags security
 *       external/cwe/cwe-926
 * @precision medium
 */

import java
import semmle.code.xml.AndroidManifest

from AndroidProviderXmlElement provider
where
  not provider.getFile().(AndroidManifestXmlFile).isInBuildDirectory() and
  provider.isExported() and
  provider.hasIncompletePermissions()
select provider, "Exported provider has incomplete permissions."
