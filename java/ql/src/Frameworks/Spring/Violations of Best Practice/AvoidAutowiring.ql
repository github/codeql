/**
 * @name Avoid autowiring
 * @description Using autowiring in Spring beans may make it difficult to maintain large projects.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/autowiring
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringBean b
where b.getAutowire() != "no"
select b, "Avoid using autowiring."
