/**
 * @name Off-by-one comparison against length
 * @description An array index is compared with the length of the array,
 *              and then used in an indexing operation that could be out of bounds.
 * @kind problem
 * @problem.severity error
 * @id go/index-out-of-bounds
 * @tags reliability
 *       correctness
 *       logic
 *       external/cwe/cwe-193
 * @precision high
 */

import go

newtype TIndex =
  VariableIndex(DataFlow::SsaNode v) { v.getAUse() = any(DataFlow::ElementReadNode e).getIndex() } or
  ConstantIndex(int v) { v = any(DataFlow::ElementReadNode e).getIndex().getIntValue() + [-1 .. 1] }

class Index extends TIndex {
  string toString() {
    exists(DataFlow::SsaNode v | this = VariableIndex(v) | result = v.getSourceVariable().getName())
    or
    exists(int v | this = ConstantIndex(v) | result = v.toString())
  }
}

DataFlow::Node getAUse(Index i) {
  i = VariableIndex(any(DataFlow::SsaNode v | result = v.getAUse()))
  or
  i = ConstantIndex(result.getIntValue())
}

/**
 * Gets a call to `len(array)`.
 */
DataFlow::CallNode arrayLen(DataFlow::SsaNode array) {
  result = Builtin::len().getACall() and
  result.getArgument(0) = array.getAUse()
}

/**
 * Gets a condition that checks that `index` is less than or equal to `array.length`.
 */
ControlFlow::ConditionGuardNode getLengthLEGuard(Index index, DataFlow::SsaNode array) {
  result.ensuresLeq(getAUse(index), arrayLen(array), 0)
  or
  exists(int i, int bias | index = ConstantIndex(i) |
    result.ensuresLeq(getAUse(ConstantIndex(i + bias)), arrayLen(array), bias)
  )
}

/**
 * Gets a condition that checks that `index` is not equal to `array.length`.
 */
ControlFlow::ConditionGuardNode getLengthNEGuard(Index index, DataFlow::SsaNode array) {
  result.ensuresNeq(getAUse(index), arrayLen(array))
}

/**
 * Holds if `ea` is a read from `array[index]` in basic block `bb`.
 */
predicate elementRead(
  DataFlow::ElementReadNode ea, DataFlow::SsaNode array, Index index, BasicBlock bb
) {
  ea.reads(array.getAUse(), getAUse(index)) and
  not array.getType().getUnderlyingType() instanceof MapType and
  bb = ea.getBasicBlock()
}

predicate isRegexpMethodCall(DataFlow::MethodCallNode c) {
  exists(NamedType regexp, Type recvtp |
    regexp.getName() = "Regexp" and recvtp = c.getReceiver().getType()
  |
    recvtp = regexp or recvtp.(PointerType).getBaseType() = regexp
  )
}

from
  ControlFlow::ConditionGuardNode cond, DataFlow::SsaNode array, Index index,
  DataFlow::ElementReadNode ea, BasicBlock bb
where
  // there is a comparison `index <= len(array)`
  cond = getLengthLEGuard(index, array) and
  // there is a read from `array[index]`
  elementRead(ea, array, index, bb) and
  // and the read is guarded by the comparison
  cond.dominates(bb) and
  // but the read is not guarded by another check that `index != len(array)`
  not getLengthNEGuard(index, array).dominates(bb) and
  // and it is not additionally guarded by a stronger index check
  not exists(Index index2, int i, int i2 |
    index = ConstantIndex(i) and index2 = ConstantIndex(i2) and i < i2
  |
    getLengthLEGuard(index2, array).dominates(bb)
  ) and
  not isRegexpMethodCall(array.getInit())
select cond.getCondition(),
  "Off-by-one index comparison against length may lead to out-of-bounds $@.", ea, "read"
