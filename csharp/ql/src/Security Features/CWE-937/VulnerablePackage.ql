/**
 * @name Using a package with a known vulnerability
 * @description Using a package with a known vulnerability is a security risk.
 *              Upgrade the package to a version that does not contain the vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/use-of-vulnerable-package
 * @tags security
 *       external/cwe/cwe-937
 */

import csharp
import Vulnerabilities

from Vulnerability vuln, VulnerablePackage package
where vuln = package.getVulnerability()
select package,
  "Package '" + package + "' has vulnerability $@, and should be upgraded to version " +
    package.getFixedVersion() + ".", vuln.getUrl(), vuln.toString()
