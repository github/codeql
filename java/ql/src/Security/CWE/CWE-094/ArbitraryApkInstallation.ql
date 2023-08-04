/**
 * @id java/android/arbitrary-apk-installation
 * @name Android APK installation
 * @description Creating an intent with a URI pointing to a untrusted file can lead to the installation of an untrusted application.
 * @kind path-problem
 * @security-severity 9.3
 * @problem.severity error
 * @precision medium
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.security.ArbitraryApkInstallationQuery
import ApkInstallationFlow::PathGraph

from ApkInstallationFlow::PathNode source, ApkInstallationFlow::PathNode sink
where ApkInstallationFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Arbitrary Android APK installation."
