/**
 * @name CVE-2018-1260: Remote Code Execution with spring-security-oauth2
 * @description A malicious user or attacker can craft an authorization request to the authorization endpoint that can lead to a remote code execution when the resource owner is forwarded to the approval endpoint.
 * @kind Remote Code Execution
 */
import java
import semmle.code.xml.MavenPom

private class PomVersionChecker extends Dependency {
  PomVersionChecker() { this.getShortCoordinate().toString() = "org.springframework.security.oauth:spring-security-oauth2" }

  string getShortCoordinateData() { result = this.getShortCoordinate().toString() }

  float first2digit() {
    result = this.getVersionString().replaceAll(".", "").substring(0, 2).toFloat()
  }

  float getversiondata() { result = this.getVersionString().replaceAll(".RELEASE", "").replaceAll(".", "").toFloat() }

  predicate getLibraryData() { getShortCoordinateData().toString() = "org.springframework.security.oauth:spring-security-oauth2" }

  predicate isVersionNumberVulnerable() {
    (this.first2digit() = 23 and getversiondata() >= 23 and getversiondata() < 233)
    or
    (this.first2digit() = 22 and this.getversiondata() >= 22 and getversiondata() < 222)
    or
    (this.first2digit() = 21 and this.getversiondata() >= 21 and getversiondata() < 211)
    or
    (this.first2digit() = 20 and this.getversiondata() >= 20 and getversiondata() < 2014)
  }
}

from Annotation ann, MethodAccess call, StringLiteral arg, PomVersionChecker config
where
  ann
      .getType()
      .hasQualifiedName("org.springframework.security.oauth2.config.annotation.web.configuration",
        "EnableAuthorizationServer") and
  call.getMethod().hasName("setUserApprovalPage") and
  call.getArgument(0) = arg and
  arg.getValue() = "forward:/oauth2/confirm_access" and
  config.getLibraryData() and  config.isVersionNumberVulnerable()
select ann, config,  "Remote code execution attacks can be occured with OAuth template injection."

