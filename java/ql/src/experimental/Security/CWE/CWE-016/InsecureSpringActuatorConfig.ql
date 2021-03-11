/**
 * @name Insecure Spring Boot Actuator Configuration
 * @description Exposed Spring Boot Actuator through configuration files without declarative or procedural security enforcement leads to information leak or even remote code execution.
 * @kind problem
 * @id java/insecure-spring-actuator-config
 * @tags security
 *       external/cwe-016
 */

import java
import semmle.code.configfiles.ConfigFiles
import semmle.code.java.security.SensitiveActions
import semmle.code.xml.MavenPom

/** The parent node of the `org.springframework.boot` group. */
class SpringBootParent extends Parent {
  SpringBootParent() { this.getGroup().getValue() = "org.springframework.boot" }
}

/** Class of Spring Boot dependencies. */
class SpringBootPom extends Pom {
  SpringBootPom() { this.getParentElement() instanceof SpringBootParent }

  /** Holds if the Spring Boot Actuator module `spring-boot-starter-actuator` is used in the project. */
  predicate isSpringBootActuatorUsed() {
    this.getADependency().getArtifact().getValue() = "spring-boot-starter-actuator"
  }

  /** Holds if the Spring Boot Security module is used in the project, which brings in other security related libraries. */
  predicate isSpringBootSecurityUsed() {
    this.getADependency().getArtifact().getValue() = "spring-boot-starter-security"
  }
}

/** The properties file `application.properties`. */
class ApplicationProperties extends ConfigPair {
  ApplicationProperties() { this.getFile().getBaseName() = "application.properties" }
}

/** The configuration property `management.security.enabled`. */
class ManagementSecurityEnabled extends ApplicationProperties {
  ManagementSecurityEnabled() { this.getNameElement().getName() = "management.security.enabled" }

  string getManagementSecurityEnabled() { result = this.getValueElement().getValue() }

  predicate hasSecurityDisabled() { getManagementSecurityEnabled() = "false" }

  predicate hasSecurityEnabled() { getManagementSecurityEnabled() = "true" }
}

/** The configuration property `management.endpoints.web.exposure.include`. */
class ManagementEndPointInclude extends ApplicationProperties {
  ManagementEndPointInclude() {
    this.getNameElement().getName() = "management.endpoints.web.exposure.include"
  }

  string getManagementEndPointInclude() { result = this.getValueElement().getValue().trim() }
}

/** The configuration property `management.endpoints.web.exposure.exclude`. */
class ManagementEndPointExclude extends ApplicationProperties {
  ManagementEndPointExclude() {
    this.getNameElement().getName() = "management.endpoints.web.exposure.exclude"
  }

  string getManagementEndPointExclude() { result = this.getValueElement().getValue().trim() }
}

/** Holds if an application handles sensitive information judging by its variable names. */
predicate isProtectedApp() {
  exists(VarAccess va | va.getVariable().getName().regexpMatch(getCommonSensitiveInfoRegex()))
}

from SpringBootPom pom, ApplicationProperties ap, Dependency d
where
  isProtectedApp() and
  pom.isSpringBootActuatorUsed() and
  not pom.isSpringBootSecurityUsed() and
  ap.getFile()
      .getParentContainer()
      .getAbsolutePath()
      .matches(pom.getFile().getParentContainer().getAbsolutePath() + "%") and // in the same sub-directory
  exists(string s | s = pom.getParentElement().getVersionString() |
    s.regexpMatch("1\\.[0|1|2|3|4].*") and
    not exists(ManagementSecurityEnabled me |
      me.hasSecurityEnabled() and me.getFile() = ap.getFile()
    )
    or
    s.regexpMatch("1\\.5.*") and
    exists(ManagementSecurityEnabled me | me.hasSecurityDisabled() and me.getFile() = ap.getFile())
    or
    s.regexpMatch("2.*") and
    exists(ManagementEndPointInclude mi |
      mi.getFile() = ap.getFile() and
      (
        mi.getManagementEndPointInclude() = "*" // all endpoints are enabled
        or
        mi.getManagementEndPointInclude()
            .matches([
                "%dump%", "%trace%", "%logfile%", "%shutdown%", "%startup%", "%mappings%", "%env%",
                "%beans%", "%sessions%"
              ]) // all endpoints apart from '/health' and '/info' are considered sensitive
      ) and
      not exists(ManagementEndPointExclude mx |
        mx.getFile() = ap.getFile() and
        mx.getManagementEndPointExclude() = mi.getManagementEndPointInclude()
      )
    )
  ) and
  d = pom.getADependency() and
  d.getArtifact().getValue() = "spring-boot-starter-actuator"
select d, "Insecure configuration of Spring Boot Actuator exposes sensitive endpoints."
