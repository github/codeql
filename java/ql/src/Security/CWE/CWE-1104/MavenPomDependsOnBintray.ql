/**
 * @name Depending upon JCenter/Bintray as an artifact repository
 * @description Using a deprecated artifact repository may eventually give attackers access for a supply chain attack.
 * @kind problem
 * @problem.severity error
 * @security-severity 6.5
 * @precision very-high
 * @id java/maven/dependency-upon-bintray
 * @tags security
 *       external/cwe/cwe-1104
 */

import java
import semmle.code.xml.MavenPom

predicate isBintrayRepositoryUsage(DeclaredRepository repository) {
  repository.getRepositoryUrl().matches("%.bintray.com%")
}

from DeclaredRepository repository
where isBintrayRepositoryUsage(repository)
select repository,
  "Downloading or uploading artifacts to deprecated repository " + repository.getRepositoryUrl()
