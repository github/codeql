/**
 * @name Exposed Spring Boot actuators in configuration file
 * @description Exposing Spring Boot actuators through configuration files may lead to information leak from
 *              the internal application, or even to remote code execution.
 * @kind problem
 * @problem.severity error
 * @security-severity 6.5
 * @precision high
 * @id java/spring-boot-exposed-actuators-config
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import semmle.code.xml.MavenPom
import semmle.code.java.security.SpringBootActuatorsConfigQuery

from SpringBootStarterActuatorDependency d, JavaPropertyOption jpOption
where exposesSensitiveEndpoint(d, jpOption)
select d, "Insecure Spring Boot actuator $@ exposes sensitive endpoints.", jpOption, "configuration"
