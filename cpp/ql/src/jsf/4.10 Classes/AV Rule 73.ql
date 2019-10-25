/**
 * @name AV Rule 73
 * @description Unnecessary default constructors shall not be defined.
 * @kind problem
 * @id cpp/jsf/av-rule-73
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 *       external/jsf
 */

import cpp

/*
 * bug finding approach: look for no-argument constructors that set a certain field x,
 * such that every member function reading x also contains a comparison involving x as
 * part of an if statement; the host class should not be used in an array type or as
 * part of an array new, it should not be used in a template instantiation, and it should
 * not be a virtual base class
 */

from Constructor c, MemberVariable f
where
  c.fromSource() and
  c.isDefault() and
  not c.isCompilerGenerated() and
  f = c.getAWrittenVariable() and
  forall(MemberFunction m, VariableAccess va |
    va = f.getAnAccess() and
    m = va.getEnclosingFunction() and
    not m instanceof Constructor and
    not va.getEnclosingStmt() instanceof IfStmt
  |
    exists(VariableAccess va2 | va2 = f.getAnAccess() and m = va2.getEnclosingFunction() |
      va != va2 and
      va2.getEnclosingStmt() instanceof IfStmt
    )
  ) and
  not (
    exists(ArrayType at | at.getBaseType+() = c.getDeclaringType())
    or
    exists(NewArrayExpr nae | nae.getType().(ArrayType).getBaseType+() = c.getDeclaringType())
    or
    exists(ClassDerivation cd |
      cd.hasSpecifier("virtual") and cd.getBaseClass() = c.getDeclaringType()
    )
  )
select c,
  "This default constructor possibly doesn't put the object in a usable state, indicated by the member variable $@.",
  f, f.toString()
