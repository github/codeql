private import csharp

/**
 * INTERNAL: Do not use.
 *
 * Provides modules and predicates for enforcing evaluation of cached predicates
 * in the same stage across different files.
 */
module Stages {
  cached
  module GuardsStage {
    private import semmle.code.csharp.controlflow.Guards

    cached
    predicate forceCachingInSameStage() { any() }

    cached
    private predicate forceCachingInSameStageRev() {
      exists(GuardedExpr ge)
      or
      forceCachingInSameStageRev()
    }
  }

  cached
  module UnificationStage {
    private import semmle.code.csharp.Unification

    cached
    predicate forceCachingInSameStage() { any() }

    cached
    private predicate forceCachingInSameStageRev() {
      exists(Gvn::CompoundTypeKind k)
      or
      exists(any(Gvn::GvnType t).toString())
      or
      exists(Unification::UnconstrainedTypeParameter utp)
      or
      forceCachingInSameStageRev()
    }
  }
}
