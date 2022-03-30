/**
 * @name Dependency download using unencrypted communication channel
 * @description Using unencrypted protocols to fetch dependencies can leave an application
 *              open to man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id rb/insecure-dependency
 * @tags security
 *       external/cwe/cwe-300
 *       external/cwe/cwe-319
 *       external/cwe/cwe-494
 *       external/cwe/cwe-829
 */

import ruby
import codeql.ruby.security.InsecureDependencyQuery

from Expr url, string msg
where insecureDependencyUrl(url, msg)
select url, msg
