/**
 * @name Missing setters for property dependency injection
 * @description Not declaring a setter for a property that is defined in a Spring XML file causes a
 *              compilation error.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/spring/missing-setter
 * @tags reliability
 *       maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringProperty p
where
  not p.getEnclosingBean().isAbstract() and
  not exists(p.getSetterMethod())
select p, "This property is missing a setter method on $@.", p.getEnclosingBean().getClass() as c,
  c.getName()
