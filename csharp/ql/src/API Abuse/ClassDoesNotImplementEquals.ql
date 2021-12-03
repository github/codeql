/**
 * @name Class does not implement Equals(object)
 * @description The class does not implement the 'Equals(object)' method, which can cause
 *              unexpected behavior. The default 'Equals(object)' method performs reference
 *              comparison, which may not be what was intended.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/class-missing-equals
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

from Class c, Element item, string message, string itemText
where
  c.isSourceDeclaration() and
  not implementsEquals(c) and
  not c.isAbstract() and
  (
    exists(MethodCall callToEquals |
      callToEquals.getTarget() instanceof EqualsMethod and
      callToEquals.getQualifier().getType() = c and
      message = "but it is called $@" and
      item = callToEquals and
      itemText = "here"
    )
    or
    item = c.getAnOperator().(EQOperator) and
    message = "but it implements $@" and
    itemText = "operator =="
    or
    exists(IEquatableEqualsMethod eq |
      item = eq and
      eq = c.getAMethod() and
      message = "but it implements $@" and
      itemText = "IEquatable<" + eq.getParameter(0).getType() + ">.Equals"
    )
  )
select c, "Class '" + c.getName() + "' does not implement Equals(object), " + message + ".", item,
  itemText
