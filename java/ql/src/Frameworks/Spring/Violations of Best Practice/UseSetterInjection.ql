/**
 * @name Use setter injection instead of constructor injection
 * @description When using the Spring Framework, using setter injection instead of constructor
 *              injection is more flexible, especially when several properties are optional.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/constructor-injection
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringBean b
where b.getASpringChild() instanceof SpringConstructorArg
select b, "Use setter injection instead of constructor injection."
