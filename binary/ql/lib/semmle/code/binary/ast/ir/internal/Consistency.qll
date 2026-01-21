private import semmle.code.binary.ast.ir.internal.Tags
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.InstructionSig

module StagedConsistencyInput<InstructionSig Input> {
  query predicate nonUniqueSuccessor(Input::Function f, Input::Instruction i, SuccessorType t, int k) {
    i.getEnclosingFunction() = f and
    k = strictcount(i.getSuccessor(t)) and
    k > 1
  }

  query predicate nonUniqueResultVariable(Input::Function f, Input::Instruction i, int k) {
    i.getEnclosingFunction() = f and
    strictcount(i.getResultVariable()) = k and
    k > 1
  }

  query predicate nonUniqueOperandVariable(Input::Function f, Input::Operand op, int k) {
    op.getEnclosingFunction() = f and
    strictcount(op.getVariable()) = k and
    k > 1
  }

  query predicate missingSuccessor(Input::Function f, Input::Instruction i) {
    i.getEnclosingFunction() = f and
    not i instanceof Input::RetInstruction and
    not i instanceof Input::RetValueInstruction and
    exists(i.getAPredecessor()) and
    not exists(i.getASuccessor())
  }

  query predicate nonLocalSuccessor(
    Input::Function f1, Input::Function f2, Input::Instruction i, SuccessorType t
  ) {
    i.getEnclosingFunction() = f1 and
    i.getSuccessor(t).getEnclosingFunction() = f2 and
    f1 != f2
  }

  query predicate successorMissingFunction(
    Input::Function f, Input::Instruction i1, Input::Instruction i2, SuccessorType t
  ) {
    i1.getEnclosingFunction() = f and
    i1.getSuccessor(t) = i2 and
    not exists(i2.getEnclosingFunction())
  }
}
