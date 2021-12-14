/**
 * @name Non-abstract parent beans should not use an abstract class
 * @description A non-abstract Spring bean that is a parent of other beans and specifies an
 *              abstract class causes an error during bean instantiation.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/spring/parent-bean-abstract-class
 * @tags reliability
 *       maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

class ParentBean extends SpringBean {
  ParentBean() { exists(SpringBean b | b.getBeanParent() = this) }

  RefType getDeclaredClass() {
    result = this.getClass() and
    this.hasAttribute("class") and
    not this.getAttribute("abstract").getValue() = "true"
  }
}

from ParentBean parent
where parent.getDeclaredClass().isAbstract()
select parent, "Parent bean $@ should not have an abstract class.", parent,
  parent.getBeanIdentifier()
