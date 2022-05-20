/**
 * @name Beans sharing similar properties
 * @description Beans that share similar properties exhibit unnecessary repetition in the bean
 *              definitions and make the system's architecture more difficult to see.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/missing-parent-bean
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

class MySpringBean extends SpringBean {
  int getNumberOfSimilarPropertiesWith(SpringBean other) {
    result = count(this.getASimilarPropertyWith(other))
  }

  SpringProperty getASimilarPropertyWith(SpringBean other) {
    exists(SpringProperty otherProp |
      otherProp = other.getADeclaredProperty() and
      result.isSimilar(otherProp) and
      result = this.getADeclaredProperty()
    )
  }
}

from MySpringBean bean1, SpringBean bean2, int similarProps
where
  similarProps = bean1.getNumberOfSimilarPropertiesWith(bean2) and
  similarProps >= 3 and
  bean1.getBeanIdentifier() < bean2.getBeanIdentifier() and
  bean1 != bean2
select bean1,
  "Bean $@ has " + similarProps.toString() +
    " properties similar to $@. Consider introducing a common parent bean for these two beans.",
  bean1, bean1.getBeanIdentifier(), bean2, bean2.getBeanIdentifier()
