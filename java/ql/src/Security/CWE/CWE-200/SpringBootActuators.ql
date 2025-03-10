/**
 * @name Exposed Spring Boot actuators
 * @description Exposing Spring Boot actuators may lead to information leak from the internal application,
 *              or even to remote code execution.
 * @kind problem
 * @problem.severity error
 * @security-severity 6.5
 * @precision high
 * @id java/spring-boot-exposed-actuators
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import semmle.code.java.frameworks.spring.SpringSecurity
import semmle.code.java.security.SpringBootActuatorsQuery

from SpringPermitAllCall permitAllCall
where permitsSpringBootActuators(permitAllCall)
select permitAllCall, "Unauthenticated access to Spring Boot actuator is allowed."
