/**
 * @name Function is never called
 * @description Unused functions may increase object size, decrease readability, and create the possibility of misuse.
 * @kind problem
 * @id cpp/dead-code-function
 * @problem.severity warning
 * @tags maintainability
 *       external/cwe/cwe-561
 */

import cpp

predicate limitedScope(Function f) {
  f.isStatic() and not f instanceof MemberFunction
  or
  f.(MemberFunction).isPrivate()
}

predicate uncalled(Function f) {
  limitedScope(f) and
  not exists(Function g | g = f or g = f.(VirtualFunction).getAnOverriddenFunction+() |
    exists(g.getACallToThisFunction()) or
    exists(FunctionAccess fa | fa.getTarget() = g)
  )
}

from Function f
where
  uncalled(f) and
  forall(Function instance | f.(TemplateFunction).getAnInstantiation() = instance |
    uncalled(instance)
  ) and
  // tweaks for good results:
  exists(f.getBlock()) and
  not (f instanceof Constructor or f instanceof Destructor or f.hasName("operator="))
select f, "Dead Code: this function is never called."
