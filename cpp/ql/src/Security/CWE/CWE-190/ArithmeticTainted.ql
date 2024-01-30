/**
 * @name User-controlled data in arithmetic expression
 * @description Arithmetic operations on user-controlled data that is
 *              not validated can cause overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.6
 * @precision low
 * @id cpp/tainted-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.controlflow.IRGuards as IRGuards
import semmle.code.cpp.security.FlowSources as FS
import Bounded
import Flow::PathGraph

bindingset[op]
predicate missingGuard(Operation op, Expr e, string effect) {
  missingGuardAgainstUnderflow(op, e) and effect = "underflow"
  or
  missingGuardAgainstOverflow(op, e) and effect = "overflow"
  or
  not e instanceof VariableAccess and effect = "overflow"
}

predicate isSource(FS::FlowSource source, string sourceType) { sourceType = source.getSourceType() }

predicate isSink(DataFlow::Node sink, Operation op, Expr e) {
  e = sink.asExpr() and
  missingGuard(op, e, _) and
  op.getAnOperand() = e and
  (
    op instanceof UnaryArithmeticOperation or
    op instanceof BinaryArithmeticOperation or
    op instanceof AssignArithmeticOperation
  )
}

predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getAnOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getAnOperand().getValue() = "0"
  )
}

predicate constantInstruction(Instruction instr) {
  instr instanceof ConstantInstruction or
  constantInstruction(instr.(UnaryInstruction).getUnary())
}

predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getAstVariable() = var
}

predicate nodeIsBarrierEqualityCandidate(DataFlow::Node node, Operand access, Variable checkedVar) {
  exists(Instruction instr | instr = node.asInstruction() |
    readsVariable(instr, checkedVar) and
    any(IRGuards::IRGuardCondition guard).ensuresEq(access, _, _, instr.getBlock(), true)
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSource(source, _) }

  predicate isSink(DataFlow::Node sink) { isSink(sink, _, _) }

  predicate isBarrier(DataFlow::Node node) {
    exists(StoreInstruction store | store = node.asInstruction() |
      // Block flow to "likely small expressions"
      bounded(store.getSourceValue().getUnconvertedResultExpression())
      or
      // Block flow to "small types"
      store.getResultType().getUnspecifiedType().(IntegralType).getSize() <= 1
    )
    or
    // Block flow if there's an upper bound check of the variable anywhere in the program
    exists(Variable checkedVar, Instruction instr | instr = node.asInstruction() |
      readsVariable(instr, checkedVar) and
      hasUpperBoundsCheck(checkedVar)
    )
    or
    // Block flow if the node is guarded by an equality check
    exists(Variable checkedVar, Operand access |
      nodeIsBarrierEqualityCandidate(node, access, checkedVar) and
      readsVariable(access.getDef(), checkedVar)
    )
    or
    // Block flow to any binary instruction whose operands are both non-constants.
    exists(BinaryInstruction iTo |
      iTo = node.asInstruction() and
      not constantInstruction(iTo.getLeft()) and
      not constantInstruction(iTo.getRight()) and
      // propagate taint from either the pointer or the offset, regardless of constantness
      not iTo instanceof PointerArithmeticInstruction
    )
  }
}

module Flow = TaintTracking::Global<Config>;

from
  Expr e, string effect, Flow::PathNode source, Flow::PathNode sink, Operation op, string sourceType
where
  Flow::flowPath(source, sink) and
  isSource(source.getNode(), sourceType) and
  isSink(sink.getNode(), op, e) and
  missingGuard(op, e, effect)
select e, source, sink,
  "$@ flows to an operand of an arithmetic expression, potentially causing an " + effect + ".",
  source, sourceType
