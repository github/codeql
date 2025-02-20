/**
 * @name Exposed Spring Boot actuators
 * @description Exposing Spring Boot actuators may lead to internal application's information leak
 *              or even to remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/spring-boot-exposed-actuators
 * @tags security
 *       experimental
 *       external/cwe/cwe-16
 */

import java
import semmle.code.java.frameworks.spring.SpringSecurity
import semmle.code.java.security.SpringBootActuatorsQuery

from PermitAllCall permitAllCall
where permitsSpringBootActuators(permitAllCall)
select permitAllCall, "Unauthenticated access to Spring Boot actuator is allowed."
