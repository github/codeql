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

from SpringBootStarterActuatorDependency d, JavaPropertyOption jpOption, SpringBootPom pom
where
  exposesSensitiveEndpoint(d, jpOption) and
  // TODO: remove pom; for debugging versions
  d = pom.getADependency()
select d,
  "Insecure $@ of Spring Boot Actuator exposes sensitive endpoints (" +
    pom.getParentElement().getVersionString() + ").", jpOption, "configuration"
