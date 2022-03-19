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
 * Holds if `write` writes to a property of a base, and there is only one base object of `write`.
 */
predicate unambiguousPropWrite(DataFlow::PropWrite write) {
  exists(DataFlow::SourceNode base, string name |
    write = base.getAPropertyWrite(name) and
    not exists(DataFlow::SourceNode otherBase |
      otherBase != base and
      write = otherBase.getAPropertyWrite(name)
    )
  )
}

/**
 * Holds if `assign1` and `assign2` both assign property `name` of the same object, and `assign2` post-dominates `assign1`.
 */
predicate postDominatedPropWrite(
  string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2, boolean local
) {
  exists(DataFlow::SourceNode base |
    assign1 = base.getAPropertyWrite(name) and
    assign2 = base.getAPropertyWrite(name)
  ) and
  exists(
    ControlFlowNode write1, ControlFlowNode write2, ReachableBasicBlock block1,
    ReachableBasicBlock block2
  |
    write1 = assign1.getWriteNode() and
    write2 = assign2.getWriteNode() and
    block1 = write1.getBasicBlock() and
    block2 = write2.getBasicBlock() and
    unambiguousPropWrite(assign1) and
    unambiguousPropWrite(assign2) and
    (
      block2.strictlyPostDominates(block1) and local = false
      or
      block1 = block2 and
      local = true and
      getRank(block1, write1, name) < getRank(block2, write2, name)
    )
  )
}

/**
 * Gets the rank for the read/write `ref` of a property `name` inside basicblock `bb`.
 */
int getRank(ReachableBasicBlock bb, ControlFlowNode ref, string name) {
  ref =
    rank[result](ControlFlowNode e |
      isAPropertyWrite(e, name) or
      isAPropertyRead(e, name)
    |
      e order by any(int i | e = bb.getNode(i))
    )
}

/**
 * Holds if `e` is a property read of a property `name`.
 */
predicate isAPropertyRead(Expr e, string name) {
  exists(DataFlow::PropRead read | read.asExpr() = e and read.getPropertyName() = name)
}

/**
 * Holds if `e` is a property write of a property `name`.
 */
predicate isAPropertyWrite(ControlFlowNode e, string name) {
  exists(DataFlow::PropWrite write | write.getWriteNode() = e and write.getPropertyName() = name)
}

/**
 * Holds if `e` may access a property named `name`.
 */
bindingset[name]
predicate maybeAccessesProperty(Expr e, string name) {
  isAPropertyRead(e, name)
  or
  // conservatively reject all side-effects
  e.isImpure()
}

/**
 * Holds if `assign1` and `assign2` both assign property `name`, but `assign1` is dead because of `assign2`.
 */
predicate isDeadAssignment(string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2) {
  (
    noPropAccessBetweenInsideBasicBlock(name, assign1, assign2) or
    noPropAccessBetweenAcrossBasicBlocks(name, assign1, assign2)
  ) and
  not isDomProperty(name)
}

/**
 * Holds if `assign1` and `assign2` are in the same basicblock and both assign property `name`, and the assigned property is not accessed between the two assignments.
 */
predicate noPropAccessBetweenInsideBasicBlock(
  string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2
) {
  assign2.getWriteNode() = getANodeWithNoPropAccessBetweenInsideBlock(name, assign1) and
  postDominatedPropWrite(name, assign1, assign2, true)
}

/**
 * Holds if `assign` assigns a property that may be accessed somewhere else in the same block,
 * `after` indicates if the access happens before or after the node for `assign`.
 *
 * The access can either be a direct property access of the same name,
 * or an impure expression where we assume that the expression can access the property.
 */
predicate maybeAssignsAccessedPropInBlock(DataFlow::PropWrite assign, boolean after) {
  (
    // early pruning - manual magic
    after = true and postDominatedPropWrite(_, assign, _, false)
    or
    after = false and postDominatedPropWrite(_, _, assign, false)
  ) and
  (
    // direct property write before/after assign
    exists(ReachableBasicBlock block, int i, int j, Expr e, string name |
      i = getRank(block, assign.getWriteNode(), name) and
      j = getRank(block, e, name) and
      isAPropertyRead(e, name)
    |
      after = true and i < j
      or
      after = false and j < i
    )
    or
    // impure expression that might access the property before/after assign
    exists(ReachableBasicBlock block | assign.getWriteNode().getBasicBlock() = block |
      after = true and PurityCheck::isBeforeImpure(assign, block)
      or
      after = false and PurityCheck::isAfterImpure(assign, block)
    )
  )
}

/**
 * Predicates to check if a property-write comes after/before an impure expression within the same basicblock.
 */
private module PurityCheck {
  /**
   * Holds if a ControlFlowNode `c` is before an impure expression inside `bb`.
   */
  predicate isBeforeImpure(DataFlow::PropWrite write, ReachableBasicBlock bb) {
    getANodeAfterWrite(write, bb).(Expr).isImpure()
  }

  /**
   * Gets a ControlFlowNode that comes after `write` inside `bb`.
   * Stops after finding the first impure expression.
   *
   * This predicate is used as a helper to check if one of the successors to `write` inside `bb` is impure (see `isBeforeImpure`).
   */
  private ControlFlowNode getANodeAfterWrite(DataFlow::PropWrite write, ReachableBasicBlock bb) {
    // base case
    result.getBasicBlock() = bb and
    postDominatedPropWrite(_, write, _, false) and // early pruning - manual magic
    result = write.getWriteNode().getASuccessor()
    or
    // recursive case
    exists(ControlFlowNode prev | prev = getANodeAfterWrite(write, bb) |
      not result instanceof BasicBlock and
      not prev.(Expr).isImpure() and
      result = prev.getASuccessor()
    )
  }

  /**
   * Holds if a ControlFlowNode `c` is after an impure expression inside `bb`.
   */
  predicate isAfterImpure(DataFlow::PropWrite write, ReachableBasicBlock bb) {
    getANodeBeforeWrite(write, bb).(Expr).isImpure()
  }

  /**
   * Gets a ControlFlowNode that comes before `write` inside `bb`.
   * Stops after finding the first impure expression.
   *
   * This predicate is used as a helper to check if one of the predecessors to `write` inside `bb` is impure (see `isAfterImpure`).
   */
  private ControlFlowNode getANodeBeforeWrite(DataFlow::PropWrite write, ReachableBasicBlock bb) {
    // base case
    result.getBasicBlock() = bb and
    postDominatedPropWrite(_, _, write, false) and // early pruning - manual magic
    result = write.getWriteNode().getAPredecessor()
    or
    // recursive case
    exists(ControlFlowNode prev | prev = getANodeBeforeWrite(write, bb) |
      not prev instanceof BasicBlock and
      not prev.(Expr).isImpure() and
      result = prev.getAPredecessor()
    )
  }
}

/**
 * Holds if `write` and `result` are inside the same basicblock, and `write` assigns property `name`, and `result` is a (transitive) successor of `write`, and `name` is not accessed between `write` and `result`.
 *
 * The predicate is computed recursively by computing transitive successors of `write` while removing the successors that could access `name`.
 * Stops at the first write to `name` that occours after `write`.
 */
ControlFlowNode getANodeWithNoPropAccessBetweenInsideBlock(string name, DataFlow::PropWrite write) {
  (
    // base case.
    result = write.getWriteNode().getASuccessor() and
    postDominatedPropWrite(name, write, _, true) // manual magic - cheap check that there might exist a result we are interrested in,
    or
    // recursive case
    result = getANodeWithNoPropAccessBetweenInsideBlock(name, write).getASuccessor()
  ) and
  // stop at basic-block boundaries
  not result instanceof BasicBlock and
  // stop at reads of `name` and at impure expressions (except writes to `name`)
  not (
    maybeAccessesProperty(result, name) and
    not isAPropertyWrite(result, name)
  ) and
  // stop at the first write to `name` that comes after `write`.
  (
    not isAPropertyWrite(result.getAPredecessor(), name)
    or
    result.getAPredecessor() = write.getWriteNode()
  )
}

/**
 * Holds if `assign1` and `assign2` are in different basicblocks and both assign property `name`, and the assigned property is not accessed between the two assignments.
 */
pragma[nomagic]
predicate noPropAccessBetweenAcrossBasicBlocks(
  string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2
) {
  exists(
    ControlFlowNode write1, ControlFlowNode write2, ReachableBasicBlock block1,
    ReachableBasicBlock block2
  |
    postDominatedPropWrite(name, assign1, assign2, false) and // manual magic - early pruning
    write1 = assign1.getWriteNode() and
    not maybeAssignsAccessedPropInBlock(assign1, true) and
    write2 = assign2.getWriteNode() and
    not maybeAssignsAccessedPropInBlock(assign2, false) and
    write1.getBasicBlock() = block1 and
    write2.getBasicBlock() = block2 and
    not block1 = block2 and
    // check for an access between the two write blocks
    not exists(ReachableBasicBlock mid |
      block1.getASuccessor+() = mid and
      mid.getASuccessor+() = block2
    |
      maybeAccessesProperty(mid.getANode(), name)
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
  ) and
  // ignore Angular templates
  not assign1.getTopLevel() instanceof Angular2::TemplateTopLevel
select assign1.getWriteNode(),
  "This write to property '" + name + "' is useless, since $@ always overrides it.",
  assign2.getWriteNode(), "another property write"
