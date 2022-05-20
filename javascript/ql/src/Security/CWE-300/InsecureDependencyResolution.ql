/**
 * @name Dependency download using unencrypted communication channel
 * @description Using unencrypted protocols to fetch dependencies can leave an application
 *              open to man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id js/insecure-dependency
 * @tags security
 *       external/cwe/cwe-300
 *       external/cwe/cwe-319
 *       external/cwe/cwe-494
 *       external/cwe/cwe-829
 */

import javascript

from PackageJson pack, JsonString val
where
  [pack.getDependencies(), pack.getDevDependencies()].getPropValue(_) = val and
  val.getValue().regexpMatch("(http|ftp)://.*")
select val, "Dependency downloaded using unencrypted communication channel."
