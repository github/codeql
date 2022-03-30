/**
 * @name Useless assignment to global variable
 * @description An assignment to a global variable that is never used has no effect.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-assignment-to-global
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-563
 * @precision low
 */

import javascript

/** Holds if every access to `v` is a write. */
predicate onlyWritten(Variable v) {
  forall(VarAccess va | va = v.getAnAccess() | exists(Assignment assgn | assgn.getTarget() = va))
}

from Variable v, GlobalVarAccess gva
where
  v = gva.getVariable() and
  onlyWritten(v) and
  // 'v' is not externally declared...
  not exists(ExternalVarDecl d | d.getName() = v.getName() |
    // ...as a member of {Window,Worker,WebWorker}.prototype
    d.(ExternalInstanceMemberDecl).getBaseName().regexpMatch("Window|Worker|WebWorker")
    or
    // ...or as a member of window
    d.(ExternalStaticMemberDecl).getBaseName() = "window"
    or
    // ...or as a global
    d instanceof ExternalGlobalDecl
  ) and
  // it isn't declared using a linter directive
  not exists(Linting::GlobalDeclaration decl | decl.declaresGlobalForAccess(gva)) and
  // ignore accesses under 'with', since they may well refer to properties of the with'ed object
  not exists(WithStmt with | with.mayAffect(gva))
select gva, "This definition of " + v.getName() + " is useless, since its value is never read."
