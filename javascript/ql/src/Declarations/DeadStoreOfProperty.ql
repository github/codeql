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
      exists(DataFlow::PropWrite write |
        write.getPropertyName() = name and
        e = write.getWriteNode() and
        unambiguousPropWrite(write)
      )
      or
      e.(PropAccess).getPropertyName() = name and e instanceof RValue
    |
      e order by any(int i | e = bb.getNode(i))
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
  (
    noPropAccessBetweenLocal(name, assign1, assign2)
    or
    noPropAccessBetweenGlobal(name, assign1, assign2)
  ) and
  not isDOMProperty(name)
}

/**
 * Holds if `assign` assigns a property that may be accessed somewhere else in the same block,
 * `after` indicates if the access happens before or after the node for `assign`.
 */
predicate maybeAssignsAccessedPropInBlock(DataFlow::PropWrite assign, boolean after) {
  (
    // early pruning - manual magic
    after = true and postDominatedPropWrite(_, assign, _, false)
    or
    after = false and postDominatedPropWrite(_, _, assign, false)
  ) and
  exists(ReachableBasicBlock block, int i, int j, Expr e, string name |
    i = getRank(block, assign.getWriteNode(), name) and
    j = getRank(block, e, name) and
    e instanceof PropAccess and
    e instanceof RValue
  |
    after = true and i < j
    or
    after = false and j < i
  )
  or
  exists(ReachableBasicBlock block | assign.getWriteNode().getBasicBlock() = block |
    after = true and isBeforeImpure(assign, block)
    or
    after = false and isAfterImpure(assign, block)
  )
}

/**
 * Holds if a ControlFlowNode `c` is before an impure expression inside `bb`.
 */
predicate isBeforeImpure(DataFlow::PropWrite write, ReachableBasicBlock bb) {
  getANodeAfterWrite(write, bb).(Expr).isImpure()
}

/**
 * Gets a ControlFlowNode that comes after `write` inside `bb`.
 * Stops after finding the first impure expression
 */
ControlFlowNode getANodeAfterWrite(DataFlow::PropWrite write, ReachableBasicBlock bb) {
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
 */
ControlFlowNode getANodeBeforeWrite(DataFlow::PropWrite write, ReachableBasicBlock bb) {
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

/**
 * Gets a successor inside `bb` in the control-flow graph that does not pass through an impure expression (except for writes to the same property).
 * Stops after the first write to same property that happens after `node`.
 * 
 * `node` always corresponds to the CFG node of a `DataFlow::PropWrite` with a known name.
 */
ControlFlowNode getAPureSuccessor(ControlFlowNode node) {
  // stop at reads of `name` and at impure expressions (except writes to `name`)
  not (
    maybeAccessesProperty(result, getPropertyWriteName(node)) and
    not result =
      any(DataFlow::PropWrite write | write.getPropertyName() = getPropertyWriteName(node))
          .getWriteNode()
  ) and
  (
    // base case.
    exists(DataFlow::PropWrite write |
      node = write.getWriteNode() and
      result = node.getASuccessor() and
      // cheap check that there might exist a result we are interrested in,
      postDominatedPropWrite(_, write, _, true)
    )
    or
    // recursive case
    result = getAPureSuccessor(node).getASuccessor() and
    // stop at basic-block boundaries
    not result instanceof BasicBlock and
    // make sure we stop after the first write to the same property that comes after `node`.
    (
      not result.getAPredecessor() =
        any(DataFlow::PropWrite write | write.getPropertyName() = getPropertyWriteName(node))
            .getWriteNode()
      or
      result.getAPredecessor() = node
    )
  )
}

/**
 * Gets the property name that is written to by the control-flow-node `writeNode`.
 */
private string getPropertyWriteName(ControlFlowNode writeNode) {
  exists(DataFlow::PropWrite write |
    write.getWriteNode() = writeNode and result = write.getPropertyName()
  )
}

/**
 * Holds if `assign1` and `assign2` are inside the same basicblock and both assign property `name`, and the assigned property is not accessed between the two assignments.
 */
predicate noPropAccessBetweenLocal(
  string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2
) {
  exists(ControlFlowNode write1, ControlFlowNode write2 |
    postDominatedPropWrite(name, assign1, assign2, true) and
    write1 = assign1.getWriteNode() and
    write2 = assign2.getWriteNode() and
    getRank(_, write1, name) < getRank(_, write2, name) and
    write2 = getAPureSuccessor(write1)
  )
}

/**
 * Holds if `assign1` and `assign2` are in different basicblocks and both assign property `name`, and the assigned property is not accessed between the two assignments.
 *
 * Much of this predicate is copy-pasted from `noPropAccessBetweenLocal`, but the predicates are separate to avoid join-order issues.
 */
pragma[nomagic]
predicate noPropAccessBetweenGlobal(
  string name, DataFlow::PropWrite assign1, DataFlow::PropWrite assign2
) {
  exists(
    ControlFlowNode write1, ControlFlowNode write2, ReachableBasicBlock block1,
    ReachableBasicBlock block2
  |
    postDominatedPropWrite(name, assign1, assign2, false) and // early pruning
    write1 = assign1.getWriteNode() and
    not maybeAssignsAccessedPropInBlock(assign1, true) and
    write2 = assign2.getWriteNode() and
    not maybeAssignsAccessedPropInBlock(assign2, false) and
    write1.getBasicBlock() = block1 and
    write2.getBasicBlock() = block2 and
    not block1 = block2 and
    // other block:
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
  )
select assign1.getWriteNode(),
  "This write to property '" + name + "' is useless, since $@ always overrides it.",
  assign2.getWriteNode(), "another property write"
