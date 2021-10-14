/**
 * @name Exposed Spring Boot actuators
 * @description Exposing Spring Boot actuators may lead to internal application's information leak
 *              or even to remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/spring-boot-exposed-actuators
 * @tags security
 *       external/cwe/cwe-16
 */

import java
import SpringBootActuators

from PermitAllCall permitAllCall
where permitAllCall.permitsSpringBootActuators()
select permitAllCall, "Unauthenticated access to Spring Boot actuator is allowed."
