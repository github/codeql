/**
 * @name Useless assignment to property
 * @description An assignment to a property whose value is always overwritten has no effect.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-assignment-to-property
 * @tags maintainability
 * @precision high
 */

import javascript
import Expressions.DOMProperties
import DeadStore

/**
 * Holds if `assign` definitely assigns property `name` of `base`.
 */
predicate unambiguousPropWrite(DataFlow::SourceNode base, string name, Assignment assign) {
  exists(DataFlow::PropWrite lhs |
    assign.getLhs().flow() = lhs and
    base.getAPropertyWrite(name) = lhs and
    not exists (DataFlow::SourceNode otherBase |
      not otherBase = base and
      lhs = otherBase.getAPropertyWrite(name)
    )
  )
}

/**
 * Holds if `assign1` and `assign2` both assign property `name` of the same object, and `assign2` post-dominates `assign1`.
 */
predicate postDominatedPropWrite(string name, Assignment assign1, Assignment assign2) {
  exists (DataFlow::SourceNode base, ReachableBasicBlock block1, ReachableBasicBlock block2 |
    block1 = assign1.getBasicBlock() and
    block2 = assign2.getBasicBlock() and
    unambiguousPropWrite(base, name, assign1) and
    unambiguousPropWrite(base, name, assign2) and
    block2.postDominates(block1) and
    (block1 = block2 implies
      exists (int i1, int i2 |
        assign1 = block1.getNode(i1) and
        assign2 = block2.getNode(i2) and
        i1 < i2
      )
    )
  )
}

/**
 * Holds if `e` may access a property named `name`.
 */
bindingset[name]
predicate maybeAccessesProperty(Expr e, string name) {
  (e.(PropAccess).getPropertyName() = name and e instanceof RValue) or
  // conservatively reject all side-effects
  e.isImpure()
}

/**
 * Holds if `assign1` and `assign2` both assign property `name`, but `assign1` is dead because of `assign2`.
 */
predicate isDeadAssignment(string name, Assignment assign1, Assignment assign2) {
  postDominatedPropWrite(name, assign1, assign2) and
  noPropAccessBetween(name, assign1, assign2) and
  not isDOMProperty(name)
}

/**
 * Holds if `assign` assigns a property `name` that may be accessed somewhere else in the same block,
 * `after` indicates if the access happens before or after the node for `assign`.
 */
bindingset[name]
predicate maybeAccessesAssignedPropInBlock(string name, Assignment assign, boolean after) {
  exists (ReachableBasicBlock block, int i, int j, Expr e |
    block = assign.getBasicBlock() and
    assign = block.getNode(i) and
    e = block.getNode(j) and
    maybeAccessesProperty(e, name) |
    after = true and i < j
    or
    after = false and j < i
  )
}

/**
 * Holds if `assign1` and `assign2` both assign property `name`, and the assigned property may be accessed between the two assignments.
 */
bindingset[name]
predicate noPropAccessBetween(string name, Assignment assign1, Assignment assign2) {
  exists (ReachableBasicBlock block1, ReachableBasicBlock block2 |
    assign1.getBasicBlock() = block1 and
    assign2.getBasicBlock() = block2 and
    if block1 = block2 then
      // same block: check for access between
      not exists (int i1, int iMid, Expr mid, int i2 |
        assign1 = block1.getNode(i1) and
        assign2 = block2.getNode(i2) and
        i1 < iMid and iMid < i2 and
        mid = block1.getNode(iMid) and
        maybeAccessesProperty(mid, name)
      )
    else
      // other block:
      not (
        // check for an access after the first write node
        maybeAccessesAssignedPropInBlock(name, assign1, true) or
        // check for an access between the two write blocks
        exists (ReachableBasicBlock mid |
          block1.getASuccessor+() = mid and
          mid.getASuccessor+() = block2 |
          maybeAccessesProperty(mid.getANode(), name)
        ) or
        // check for an access before the second write node
        maybeAccessesAssignedPropInBlock(name, assign2, false)
      )
  )
}

from string name, Assignment assign1, Assignment assign2
where isDeadAssignment(name, assign1, assign2) and
      // whitelist
      not (
        // Google Closure Compiler pattern: `o.p = o['p'] = v`
        exists (PropAccess p1, PropAccess p2 |
          p1 = assign1.getLhs() and
          p2 = assign2.getLhs() |
          p1 instanceof DotExpr and p2 instanceof IndexExpr
          or
          p2 instanceof DotExpr and p1 instanceof IndexExpr
        )
        or
        // don't flag overwrites for default values
        isDefaultInit(assign1.getRhs().getUnderlyingValue())
        or
        // don't flag assignments in externs
        assign1.inExternsFile()
      )
select assign1, "This write to property '" + name + "' is useless, since $@ always overrides it.", assign2, "another property write"
