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

private class DeclaredRepository extends PomElement {
  DeclaredRepository() {
    this.getName() = "repository" or
    this.getName() = "snapshotRepository" or
    this.getName() = "pluginRepository"
  }

  string getUrl() { result = getAChild("url").(PomElement).getValue() }

  predicate isBintrayRepositoryUsage() {
    getUrl().matches("%.bintray.com%")
  }
}

from DeclaredRepository repository
where repository.isBintrayRepositoryUsage()
select repository,
  "Downloading or uploading artifacts to deprecated repository " +
    repository.getUrl()
