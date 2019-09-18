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
 * Holds if `write` writes to property `name` of `base`, and `base` is the only base object of `write`.
 */
predicate unambiguousPropWrite(DataFlow::SourceNode base, string name, DataFlow::PropWrite write) {
  write = base.getAPropertyWrite(name) and
  not exists(DataFlow::SourceNode otherBase |
    otherBase != base and
    write = otherBase.getAPropertyWrite(name)
  )
}

/**
 * Holds if `assign1` and `assign2` both assign property `name` of the same object, and `assign2` post-dominates `assign1`.
 */
predicate postDominatedPropWrite(
  string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2
) {
  exists(
    ControlFlowNode write1, ControlFlowNode write2, DataFlow::SourceNode base,
    ReachableBasicBlock block1, ReachableBasicBlock block2
  |
    write1 = assign1.getWriteNode() and
    write2 = assign2.getWriteNode() and
    block1 = write1.getBasicBlock() and
    block2 = write2.getBasicBlock() and
    unambiguousPropWrite(base, name, assign1) and
    unambiguousPropWrite(base, name, assign2) and
    block2.postDominates(block1) and
    (
      block1 = block2
      implies
      exists(int i1, int i2 |
        write1 = block1.getNode(i1) and
        write2 = block2.getNode(i2) and
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
  e.(PropAccess).getPropertyName() = name and e instanceof RValue
  or
  // conservatively reject all side-effects
  e.isImpure()
}

/**
 * Holds if `assign1` and `assign2` both assign property `name`, but `assign1` is dead because of `assign2`.
 */
predicate isDeadAssignment(string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2) {
  postDominatedPropWrite(name, assign1, assign2) and
  noPropAccessBetween(name, assign1, assign2) and
  not isDOMProperty(name)
}

/**
 * Holds if `assign` assigns a property `name` that may be accessed somewhere else in the same block,
 * `after` indicates if the access happens before or after the node for `assign`.
 */
bindingset[name]
predicate maybeAccessesAssignedPropInBlock(string name, DataFlow::PropWrite assign, boolean after) {
  exists(ReachableBasicBlock block, int i, int j, Expr e |
    assign.getWriteNode() = block.getNode(i) and
    e = block.getNode(j) and
    maybeAccessesProperty(e, name)
  |
    after = true and i < j
    or
    after = false and j < i
  )
}

/**
 * Holds if `assign1` and `assign2` both assign property `name`, and the assigned property is not accessed between the two assignments.
 */
bindingset[name]
predicate noPropAccessBetween(string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2) {
  exists(
    ControlFlowNode write1, ControlFlowNode write2, ReachableBasicBlock block1,
    ReachableBasicBlock block2
  |
    write1 = assign1.getWriteNode() and
    write2 = assign2.getWriteNode() and
    write1.getBasicBlock() = block1 and
    write2.getBasicBlock() = block2 and
    if block1 = block2
    then
      // same block: check for access between
      not exists(int i1, Expr mid, int i2 |
        write1 = block1.getNode(i1) and
        write2 = block2.getNode(i2) and
        mid = block1.getNode([i1 + 1 .. i2 - 1]) and
        maybeAccessesProperty(mid, name)
      )
    else
      // other block:
      not (
        // check for an access after the first write node
        maybeAccessesAssignedPropInBlock(name, assign1, true)
        or
        // check for an access between the two write blocks
        exists(ReachableBasicBlock mid |
          block1.getASuccessor+() = mid and
          mid.getASuccessor+() = block2
        |
          maybeAccessesProperty(mid.getANode(), name)
        )
        or
        // check for an access before the second write node
        maybeAccessesAssignedPropInBlock(name, assign2, false)
      )
  )
}

from string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2
where
  isDeadAssignment(name, assign1, assign2) and
  // whitelist
  not (
    // Google Closure Compiler pattern: `o.p = o['p'] = v`
    exists(PropAccess p1, PropAccess p2 |
      p1 = assign1.getAstNode() and
      p2 = assign2.getAstNode()
    |
      p1 instanceof DotExpr and p2 instanceof IndexExpr
      or
      p2 instanceof DotExpr and p1 instanceof IndexExpr
    )
    or
    // don't flag overwrites for default values
    isDefaultInit(assign1.getRhs().asExpr().getUnderlyingValue())
    or
    // don't flag assignments in externs
    assign1.getAstNode().inExternsFile()
    or
    // exclude result from js/overwritten-property
    assign2.getBase() instanceof DataFlow::ObjectLiteralNode
    or
    // exclude result from accessor declarations
    assign1.getWriteNode() instanceof AccessorMethodDeclaration
  ) and
  // exclude results from non-value definitions from `Object.defineProperty`
  (
    assign1 instanceof CallToObjectDefineProperty
    implies
    assign1.(CallToObjectDefineProperty).hasPropertyAttributeWrite("value", _)
  )
select assign1.getWriteNode(),
  "This write to property '" + name + "' is useless, since $@ always overrides it.",
  assign2.getWriteNode(), "another property write"
