/**
 * @name Depending upon JCenter/Bintray as an artifact repository
 * @description JCenter & Bintray are deprecated
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/maven/dependency-upon-bintray
 * @tags security
 *       external/cwe/cwe-1104
 */

import java
import semmle.code.xml.MavenPom

predicate isBintrayRepositoryUsage(DeclaredRepository repository) {
  repository.getUrl().matches("%.bintray.com%")
}

from DeclaredRepository repository
where isBintrayRepositoryUsage(repository)
select repository,
  "Downloading or uploading artifacts to deprecated repository " + repository.getUrl()
