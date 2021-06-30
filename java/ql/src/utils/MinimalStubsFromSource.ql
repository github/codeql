/**
 * Tool to generate java stubs from a qltest snapshot.
 *
 * It finds all declarations used in the source code,
 * and generates minimal java stubs containing those declarations
 * and their dependencies.
 */

import java
import Stubs

/** Declarations used by source code. */
class UsedInSource extends GeneratedDeclaration {
  UsedInSource() {
    (
      this = any(Variable v | v.fromSource()).getType()
      or
      this = any(Expr e | e.getEnclosingCallable().fromSource()).getType()
      or
      this = any(RefType t | t.fromSource())
      or
      this = any(TypeAccess ta | ta.fromSource())
    )
  }
}

from GeneratedTopLevel t
where not t.fromSource()
select t.getQualifiedName(), t.stubFile()

module Consistency {
  query predicate noGeneratedStubs(string s) {
    exists(GeneratedTopLevel t | s = t.getQualifiedName() |
      not t.fromSource() and
      not exists(t.stubFile())
    )
  }

  query predicate multipleGeneratedStubs(string s) {
    exists(GeneratedTopLevel t | s = t.getQualifiedName() |
      not t.fromSource() and
      strictcount(t.stubFile()) > 1
    )
  }
}

import Consistency
