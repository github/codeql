/** Provides classes and predicates to reason about Spring Boot actuators exposed in configuration files. */
overlay[local?]
module;

import java
private import semmle.code.configfiles.ConfigFiles
private import semmle.code.xml.MavenPom

/** The parent node of the `org.springframework.boot` group. */
private class SpringBootParent extends Parent {
  SpringBootParent() { this.getGroup().getValue() = "org.springframework.boot" }
}

/** A `Pom` with a Spring Boot parent node. */
private class SpringBootPom extends Pom {
  SpringBootPom() { this.getParentElement() instanceof SpringBootParent }

  /** Holds if the Spring Boot Security module is used in the project. */
  predicate isSpringBootSecurityUsed() {
    this.getADependency().getArtifact().getValue() = "spring-boot-starter-security"
  }
}

/** A dependency with artifactId `spring-boot-starter-actuator`. */
class SpringBootStarterActuatorDependency extends Dependency {
  SpringBootStarterActuatorDependency() {
    this.getArtifact().getValue() = "spring-boot-starter-actuator"
  }
}

/** The Spring Boot configuration property `management.security.enabled`. */
private class ManagementSecurityEnabledProperty extends JavaProperty {
  ManagementSecurityEnabledProperty() {
    this.getNameElement().getName() = "management.security.enabled"
  }

  /** Gets the whitespace-trimmed value of this property. */
  string getValue() { result = this.getValueElement().getValue().trim() }

  /** Holds if `management.security.enabled` is set to `false`. */
  predicate hasSecurityDisabled() { this.getValue() = "false" }
}

/**
 * The Spring Boot configuration property `management.endpoints.web.exposure.include`
 * or `management.endpoints.web.expose`.
 */
private class ManagementEndpointsExposeProperty extends JavaProperty {
  ManagementEndpointsExposeProperty() {
    this.getNameElement().getName() = "management.endpoints.web." + ["exposure.include", "expose"]
  }

  /** Gets the whitespace-trimmed value of this property. */
  string getValue() { result = this.getValueElement().getValue().trim() }
}

private newtype TOption =
  TNone() or
  TSome(JavaProperty jp)

/**
 * An option type that is either a singleton `None` or a `Some` wrapping
 * the `JavaProperty` type.
 */
class JavaPropertyOption extends TOption {
  /** Gets a textual representation of this element. */
  string toString() {
    this = TNone() and result = "(none)"
    or
    result = this.asSome().toString()
  }

  /** Gets the location of this element. */
  Location getLocation() { result = this.asSome().getLocation() }

  /** Gets the wrapped element, if any. */
  JavaProperty asSome() { this = TSome(result) }

  /** Holds if this option is the singleton `None`. */
  predicate isNone() { this = TNone() }
}

/**
 * Holds if `JavaPropertyOption` jpOption of a repository using `SpringBootStarterActuatorDependency`
 * d exposes sensitive Spring Boot Actuator endpoints.
 */
predicate exposesSensitiveEndpoint(
  SpringBootStarterActuatorDependency d, JavaPropertyOption jpOption
) {
  exists(PropertiesFile propFile, SpringBootPom pom |
    d = pom.getADependency() and
    not pom.isSpringBootSecurityUsed() and
    propFile
        .getParentContainer()
        .getAbsolutePath()
        .matches(pom.getFile().getParentContainer().getAbsolutePath() + "%") and // in the same sub-directory
    exists(string springBootVersion |
      springBootVersion = pom.getParentElement().getVersionString()
    |
      springBootVersion.regexpMatch("1\\.[0-4].*") and // version 1.0, 1.1, ..., 1.4
      not exists(ManagementSecurityEnabledProperty ep | ep.getFile() = propFile) and
      jpOption.isNone()
      or
      springBootVersion.regexpMatch("1\\.[0-5].*") and // version 1.0, 1.1, ..., 1.5
      exists(ManagementSecurityEnabledProperty ep |
        ep.hasSecurityDisabled() and ep.getFile() = propFile and ep = jpOption.asSome()
      )
      or
      springBootVersion.matches(["2.%", "3.%"]) and //version 2.x and 3.x
      exists(ManagementEndpointsExposeProperty ep |
        ep.getFile() = propFile and
        ep = jpOption.asSome() and
        (
          // all endpoints are exposed
          ep.getValue() = "*"
          or
          // version 2.x: exposes health and info only by default
          springBootVersion.matches("2.%") and
          not ep.getValue() = ["health", "info"]
          or
          // version 3.x: exposes health only by default
          springBootVersion.matches("3.%") and
          not ep.getValue() = "health"
        )
      )
    )
  )
}
