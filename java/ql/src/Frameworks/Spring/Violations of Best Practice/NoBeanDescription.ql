/**
 * @name This bean does not have a description element
 * @description Adding 'description' elements to a Spring XML bean definition file is good practice.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/missing-bean-description
 * @tags maintainability
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringBean b
where
  not exists(SpringDescription d |
    d = b.getASpringChild() or d = b.getSpringBeanFile().getBeansElement().getAChild()
  )
select b, "This bean does not have a description."
