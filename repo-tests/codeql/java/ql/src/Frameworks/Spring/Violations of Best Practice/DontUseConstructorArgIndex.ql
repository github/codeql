/**
 * @name Use constructor-arg types instead of index
 * @description Using a type name instead of an index number in a Spring 'constructor-arg' element
 *              improves readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/constructor-arg-index
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringConstructorArg carg
where carg.hasArgIndex()
select carg, "Use constructor-arg types instead of index."
