/** Provides classes and predicates to reason about Spring Boot actuators exposed in configuration files. */
overlay[local?]
module;

import java
private import semmle.code.configfiles.ConfigFiles
private import semmle.code.xml.MavenPom

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

  /**
   * Holds if the Spring Boot Security module is used in the project, which brings in other security
   * related libraries.
   */
  predicate isSpringBootSecurityUsed() {
    this.getADependency().getArtifact().getValue() = "spring-boot-starter-security"
  }
}

/** The properties file `application.properties`. */
class ApplicationPropertiesFile extends File {
  ApplicationPropertiesFile() { this.getBaseName() = "application.properties" }
}

/** A name-value pair stored in an `application.properties` file. */
class ApplicationPropertiesConfigPair extends ConfigPair {
  ApplicationPropertiesConfigPair() { this.getFile() instanceof ApplicationPropertiesFile }
}

/** The configuration property `management.security.enabled`. */
class ManagementSecurityConfig extends ApplicationPropertiesConfigPair {
  ManagementSecurityConfig() { this.getNameElement().getName() = "management.security.enabled" }

  /** Gets the whitespace-trimmed value of this property. */
  string getValue() { result = this.getValueElement().getValue().trim() }

  /** Holds if `management.security.enabled` is set to `false`. */
  predicate hasSecurityDisabled() { this.getValue() = "false" }

  /** Holds if `management.security.enabled` is set to `true`. */
  predicate hasSecurityEnabled() { this.getValue() = "true" }
}

/** The configuration property `management.endpoints.web.exposure.include`. */
class ManagementEndPointInclude extends ApplicationPropertiesConfigPair {
  ManagementEndPointInclude() {
    this.getNameElement().getName() = "management.endpoints.web.exposure.include"
  }

  /** Gets the whitespace-trimmed value of this property. */
  string getValue() { result = this.getValueElement().getValue().trim() }
}

/**
 * Holds if `ApplicationProperties` ap of a repository managed by `SpringBootPom` pom
 * has a vulnerable configuration of Spring Boot Actuator management endpoints.
 */
predicate hasConfidentialEndPointExposed(SpringBootPom pom) {
  pom.isSpringBootActuatorUsed() and
  not pom.isSpringBootSecurityUsed() and
  exists(ApplicationPropertiesFile apFile |
    apFile
        .getParentContainer()
        .getAbsolutePath()
        .matches(pom.getFile().getParentContainer().getAbsolutePath() + "%") and // in the same sub-directory
    exists(string springBootVersion |
      springBootVersion = pom.getParentElement().getVersionString()
    |
      springBootVersion.regexpMatch("1\\.[0-4].*") and // version 1.0, 1.1, ..., 1.4
      not exists(ManagementSecurityConfig me | me.hasSecurityEnabled() and me.getFile() = apFile)
      or
      springBootVersion.matches("1.5%") and // version 1.5
      exists(ManagementSecurityConfig me | me.hasSecurityDisabled() and me.getFile() = apFile)
      or
      springBootVersion.matches("2.%") and //version 2.x
      exists(ManagementEndPointInclude mi |
        mi.getFile() = apFile and
        (
          mi.getValue() = "*" // all endpoints are enabled
          or
          mi.getValue()
              .matches([
                  "%dump%", "%trace%", "%logfile%", "%shutdown%", "%startup%", "%mappings%",
                  "%env%", "%beans%", "%sessions%"
                ]) // confidential endpoints to check although all endpoints apart from '/health' and '/info' are considered sensitive by Spring
        )
      )
    )
  )
}
