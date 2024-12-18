/**
 * @name Potential integer arithmetic overflow
 * @description A user-controlled integer arithmetic expression
 *              that is not validated can cause overflows.
 * @kind problem
 * @id cpp/integer-overflow-tainted
 * @problem.severity warning
 * @security-severity 8.1
 * @precision low
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.security.FlowSources as FS
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.ir.IR
import semmle.code.cpp.controlflow.IRGuards as IRGuards

/** Holds if `expr` might overflow. */
predicate outOfBoundsExpr(Expr expr, string kind) {
  if convertedExprMightOverflowPositively(expr)
  then kind = "overflow"
  else
    if convertedExprMightOverflowNegatively(expr)
    then kind = "overflow negatively"
    else none()
}

predicate isSource(FS::FlowSource source, string sourceType) { sourceType = source.getSourceType() }

predicate isSink(DataFlow::Node sink, string kind) {
  exists(Expr use |
    not use.getUnspecifiedType() instanceof PointerType and
    outOfBoundsExpr(use, kind) and
    not inSystemMacroExpansion(use) and
    use = sink.asExpr()
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

  predicate isSink(DataFlow::Node sink) { isSink(sink, _) }

  predicate isBarrier(DataFlow::Node node) {
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

from DataFlow::Node source, DataFlow::Node sink, string kind, string sourceType
where
  Flow::flow(source, sink) and
  isSource(source, sourceType) and
  isSink(sink, kind)
select sink, "$@ flows an expression which might " + kind + ".", source, sourceType
