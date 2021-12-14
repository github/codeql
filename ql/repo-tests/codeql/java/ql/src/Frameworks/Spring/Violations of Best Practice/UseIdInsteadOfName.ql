/**
 * @name Use id instead of name
 * @description Using 'id' instead of 'name' to name a Spring bean enables the XML parser to perform
 *              additional checks.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/bean-id
 * @tags reliability
 *       maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringBean b
where
  not b.hasBeanId() and
  b.hasBeanName()
select b,
  "Use \"id\" instead of \"name\" to take advantage of the IDREF constraint in the XML parser."
