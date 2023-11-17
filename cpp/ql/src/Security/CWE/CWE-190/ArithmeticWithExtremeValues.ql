/**
 * @name Use of extreme values in arithmetic expression
 * @description If a variable is assigned the maximum or minimum value
 *              for that variable's type and is then used in an
 *              arithmetic expression, this may result in an overflow.
 * @kind problem
 * @id cpp/arithmetic-with-extreme-values
 * @problem.severity warning
 * @security-severity 8.6
 * @precision low
 * @tags security
 *       reliability
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.ir.IR
import semmle.code.cpp.controlflow.IRGuards as IRGuards

predicate isMaxValue(Expr mie) {
  exists(MacroInvocation mi |
    mi.getExpr() = mie and
    mi.getMacroName() = ["CHAR_MAX", "LLONG_MAX", "INT_MAX", "SHRT_MAX", "UINT_MAX"]
  )
}

predicate isMinValue(Expr mie) {
  exists(MacroInvocation mi |
    mi.getExpr() = mie and
    mi.getMacroName() = ["CHAR_MIN", "LLONG_MIN", "INT_MIN", "SHRT_MIN"]
  )
}

predicate isSource(DataFlow::Node source, string cause) {
  exists(Expr expr | expr = source.asExpr() |
    isMaxValue(expr) and cause = "max value"
    or
    isMinValue(expr) and cause = "min value"
  )
}

predicate causeEffectCorrespond(string cause, string effect) {
  cause = "max value" and
  effect = "overflow"
  or
  cause = "min value" and
  effect = "underflow"
}

predicate isSink(DataFlow::Node sink, VariableAccess va, string effect) {
  exists(Operation op |
    sink.asExpr() = va and
    op.getAnOperand() = va
  |
    missingGuardAgainstUnderflow(op, va) and effect = "underflow"
    or
    missingGuardAgainstOverflow(op, va) and effect = "overflow"
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

from DataFlow::Node source, DataFlow::Node sink, VariableAccess va, string cause, string effect
where
  Flow::flow(source, sink) and
  isSource(source, cause) and
  causeEffectCorrespond(cause, effect) and
  isSink(sink, va, effect)
select va,
  "$@ flows to an operand of an arithmetic expression, potentially causing an " + effect + ".",
  source, "Extreme value"
