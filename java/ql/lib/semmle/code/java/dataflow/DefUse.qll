/**
 * Provides classes and predicates for def-use and use-use pairs. Built on top of the SSA library for
 * maximal precision.
 */

import java
private import SSA

/**
 * Holds if `use1` and `use2` form a use-use-pair of the same SSA variable,
 * that is, the value read in `use1` can reach `use2` without passing through
 * any SSA definition of the variable.
 *
 * This is the transitive closure of `adjacentUseUseSameVar`.
 */
predicate useUsePairSameVar(RValue use1, RValue use2) { adjacentUseUseSameVar+(use1, use2) }

/**
 * Holds if `use1` and `use2` form a use-use-pair of the same
 * `SsaSourceVariable`, that is, the value read in `use1` can reach `use2`
 * without passing through any SSA definition of the variable except for phi
 * nodes and uncertain implicit updates.
 *
 * This is the transitive closure of `adjacentUseUse`.
 */
predicate useUsePair(RValue use1, RValue use2) { adjacentUseUse+(use1, use2) }

/**
 * Holds if there exists a path from `def` to `use` without passing through another
 * `VariableUpdate` of the `LocalScopeVariable` that they both refer to.
 *
 * Other paths may also exist, so the SSA variables in `def` and `use` can be different.
 */
predicate defUsePair(VariableUpdate def, RValue use) {
  exists(SsaVariable v |
    v.getAUse() = use and v.getAnUltimateDefinition().(SsaExplicitUpdate).getDefiningExpr() = def
  )
}

/**
 * Holds if there exists a path from the entry-point of the callable to `use` without
 * passing through a `VariableUpdate` of the parameter `p` that `use` refers to.
 *
 * Other paths may also exist, so the SSA variables can be different.
 */
predicate parameterDefUsePair(Parameter p, RValue use) {
  exists(SsaVariable v |
    v.getAUse() = use and v.getAnUltimateDefinition().(SsaImplicitInit).isParameterDefinition(p)
  )
}
