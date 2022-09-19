/**
 * @name Missing read or write permission configuration
 * @description Defining an incomplete set of permissions
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @id java/android/incomplete-provider-permissions
 * @tags security
 *       external/cwe/cwe-276
 * @precision medium
 */

import java
import semmle.code.xml.AndroidManifest

from AndroidProviderXmlElement provider
where
  (
    provider.getAnAttribute().(AndroidPermissionXmlAttribute).isWrite() or
    provider.getAnAttribute().(AndroidPermissionXmlAttribute).isRead()
  ) and
  not provider.requiresPermissions()
select provider, "Incomplete permissions"
