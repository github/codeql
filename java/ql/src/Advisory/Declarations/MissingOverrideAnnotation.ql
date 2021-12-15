/**
 * @name Missing Override annotation
 * @description A method that overrides a method in a superclass but does not have an 'Override'
 *              annotation cannot take advantage of compiler checks, and makes code less readable.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/missing-override-annotation
 * @tags maintainability
 */

import java

class OverridingMethod extends Method {
  OverridingMethod() { exists(Method m | this.overrides(m)) }

  predicate isOverrideAnnotated() { this.getAnAnnotation() instanceof OverrideAnnotation }
}

from OverridingMethod m, Method overridden
where
  m.fromSource() and
  m.overrides(overridden) and
  not m.isOverrideAnnotated() and
  not exists(FunctionalExpr mref | mref.asMethod() = m)
select m, "This method overrides $@; it is advisable to add an Override annotation.", overridden,
  overridden.getDeclaringType() + "." + overridden.getName()
