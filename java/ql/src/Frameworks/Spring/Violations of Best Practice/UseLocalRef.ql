/**
 * @name Use local refs when referring to beans in the same file
 * @description Using local references when referring to Spring beans in the same file allows
 *              reference errors to be detected during XML parsing.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/non-local-reference
 * @tags reliability
 *       maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringAbstractRef ref, SpringBean refBean, SpringBean referencedBean
where
  refBean = ref.getEnclosingBean() and
  referencedBean = ref.getBean() and
  referencedBean.getSpringBeanFile() = refBean.getSpringBeanFile() and
  not ref.hasBeanLocalName()
select ref,
  "Non-local reference points to bean $@ in the same file. Use a local reference instead.",
  referencedBean, referencedBean.getBeanIdentifier()
