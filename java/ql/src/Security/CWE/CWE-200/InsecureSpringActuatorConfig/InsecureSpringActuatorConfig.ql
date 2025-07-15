/**
 * @name Insecure Spring Boot Actuator Configuration
 * @description Exposed Spring Boot Actuator through configuration files without declarative or procedural
 *              security enforcement leads to information leak or even remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/insecure-spring-actuator-config
 * @tags security
 *       experimental
 *       external/cwe/cwe-016
 */

import java
import semmle.code.xml.MavenPom
import semmle.code.java.security.SpringBootActuatorsConfigQuery

from SpringBootPom pom, ApplicationProperties ap, Dependency d
where
  hasConfidentialEndPointExposed(pom, ap) and
  d = pom.getADependency() and
  d.getArtifact().getValue() = "spring-boot-starter-actuator"
select d, "Insecure configuration of Spring Boot Actuator exposes sensitive endpoints."
