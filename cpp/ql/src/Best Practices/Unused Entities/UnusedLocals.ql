/**
 * @name Unused local variable
 * @description A local variable that is never called or accessed may be an
 *              indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/unused-local-variable
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-563
 */

import cpp

/**
 * A type that contains a template parameter type
 * (doesn't count pointers or references).
 *
 * These types may have a constructor / destructor when they are
 * instantiated, that is not visible in their template form.
 *
 * Such types include template parameters, classes with a member variable
 * of template parameter type, and classes that derive from other such
 * classes.
 */
class TemplateDependentType extends Type {
  TemplateDependentType() {
    this instanceof TemplateParameter
    or
    exists(TemplateDependentType t |
      this.refersToDirectly(t) and
      not this instanceof PointerType and
      not this instanceof ReferenceType
    )
  }
}

/**
 * A variable whose declaration has, or may have, side effects.
 */
predicate declarationHasSideEffects(Variable v) {
  exists(Class c | c = v.getUnspecifiedType() |
    c.hasConstructor() or
    c.hasDestructor()
  )
  or
  v.getType() instanceof TemplateDependentType // may have a constructor/destructor
}

from LocalVariable v, Function f
where
  f = v.getFunction() and
  not exists(v.getAnAccess()) and
  not v.isConst() and // workaround for folded constants
  not exists(DeclStmt ds | ds.getADeclaration() = v and ds.isInMacroExpansion()) and // variable declared in a macro expansion
  not declarationHasSideEffects(v) and
  not exists(AsmStmt s | f = s.getEnclosingFunction()) and
  not v.getAnAttribute().getName() = "unused" and
  not any(ErrorExpr e).getEnclosingFunction() = f and // unextracted expr may use `v`
  not exists(
    Literal l // this case can be removed when the `myFunction2( [obj](){} );` test case doesn't depend on this exclusion
  |
    l.getEnclosingFunction() = f and
    not exists(l.getValue())
  ) and
  not any(ConditionDeclExpr cde).getEnclosingFunction() = f // this case can be removed when the `if (a = b; a)` test case doesn't depend on this exclusion
select v, "Variable " + v.getName() + " is not used"
