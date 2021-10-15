/**
 * @name Useless property override
 * @description A bean property that overrides the same property in a parent bean, and has the same
 *              contents, is useless.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/spring/useless-property-override
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringBean bean, SpringProperty prop, SpringProperty overriddenProp, SpringBean ancestorBean
where
  prop = bean.getADeclaredProperty() and
  ancestorBean = bean.getBeanParent+() and
  ancestorBean.getADeclaredProperty() = overriddenProp and
  overriddenProp.getPropertyName() = prop.getPropertyName() and
  prop.isSimilar(overriddenProp)
select prop, "Property overrides $@ in parent, but has the same contents.", overriddenProp,
  overriddenProp.toString()
