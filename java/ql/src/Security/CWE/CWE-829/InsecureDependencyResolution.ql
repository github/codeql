/**
 * @name Failure to use HTTPS or SFTP URL in Maven artifact upload/download
 * @description Non-HTTPS connections can be intercepted by third parties.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/maven/non-https-url
 * @tags security
 *       external/cwe/cwe-300
 *       external/cwe/cwe-319
 *       external/cwe/cwe-494
 *       external/cwe/cwe-829
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

  predicate isInsecureRepositoryUsage() {
    getUrl().regexpMatch("(?i)^(http|ftp)://(?!localhost[:/]).*")
  }
}

from DeclaredRepository repository
where repository.isInsecureRepositoryUsage()
select repository,
  "Downloading or uploading artifacts over insecure protocol (eg. http or ftp) to/from repository " +
    repository.getUrl()
