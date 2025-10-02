private import semmle.code.binary.ast.instructions as RawInstruction
private import semmle.code.binary.ast.operand as RawOperand
private import codeql.controlflow.SuccessorType
private import Opcode as Opcode
private import InstructionTag
private import Instruction
private import Operand
private import codeql.util.Either
private import TranslatedInstruction
private import TranslatedOperand
private import Variable
private import codeql.util.Option

class Opcode = Opcode::Opcode;

private predicate shouldTranslateInstr(RawInstruction::Instruction instr) { any() }

private predicate shouldTranslateOperand(RawOperand::Operand operand) { any() }

newtype TTranslatedElement =
  TTranslatedFunction(RawInstruction::Instruction entry) {
    shouldTranslateInstr(entry) and
    (
      entry = any(RawInstruction::Call call).getTarget()
      or
      entry instanceof RawInstruction::ProgramEntryInstruction
    )
  } or
  TTranslatedSimpleBinaryInstruction(RawInstruction::Instruction instr) {
    shouldTranslateInstr(instr) and
    isSimpleBinaryInstruction(instr, _, _)
  } or
  TTranslatedImmediateOperand(RawOperand::ImmediateOperand op) { shouldTranslateOperand(op) } or
  TTranslatedRegisterOperand(RawOperand::RegisterOperand reg) { shouldTranslateOperand(reg) } or
  TTranslatedMemoryOperand(RawOperand::MemoryOperand mem) { shouldTranslateOperand(mem) } or
  TTranslatedCall(RawInstruction::Call call) { shouldTranslateInstr(call) } or
  TTranslatedJmp(RawInstruction::Jmp jmp) { shouldTranslateInstr(jmp) and exists(jmp.getTarget()) } or
  TTranslatedMov(RawInstruction::Mov mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovsd(RawInstruction::Movsd mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovzx(RawInstruction::Movzx mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovsxd(RawInstruction::Movsxd mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovsx(RawInstruction::Movsx mov) { shouldTranslateInstr(mov) } or
  TTranslatedPush(RawInstruction::Push push) { shouldTranslateInstr(push) } or
  TTranslatedTest(RawInstruction::Test test) { shouldTranslateInstr(test) } or
  TTranslatedConditionalJump(RawInstruction::ConditionalJumpInstruction cjmp) {
    shouldTranslateInstr(cjmp)
  } or
  TTranslatedCmp(RawInstruction::Cmp cmp) { shouldTranslateInstr(cmp) } or
  TTranslatedLea(RawInstruction::Lea lea) { shouldTranslateInstr(lea) } or
  TTranslatedPop(RawInstruction::Pop pop) { shouldTranslateInstr(pop) } or
  TTranslatedRet(RawInstruction::Ret ret) { shouldTranslateInstr(ret) } or
  TTranslatedDec(RawInstruction::Dec dec) { shouldTranslateInstr(dec) } or
  TTranslatedInc(RawInstruction::Inc inc) { shouldTranslateInstr(inc) } or
  TTranslatedNop(RawInstruction::Nop nop) { shouldTranslateInstr(nop) } or
  TTranslatedBt(RawInstruction::Bt bt) { shouldTranslateInstr(bt) } or
  TTranslatedBtr(RawInstruction::Btr btr) { shouldTranslateInstr(btr) }

TranslatedElement getTranslatedElement(RawInstruction::Element raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

TranslatedInstruction getTranslatedInstruction(RawInstruction::Instruction raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

abstract class TranslatedElement extends TTranslatedElement {
  abstract predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v);

  predicate hasTempVariable(VariableTag tag) { none() }

  predicate hasJumpCondition(InstructionTag tag, Opcode::Condition kind) { none() }

  predicate hasSynthVariable(SynthRegisterTag tag) { none() }

  Variable getVariable(VariableTag tag) { result = TTempVariable(this, tag) }

  final Instruction getInstruction(InstructionTag tag) { result = MkInstruction(this, tag) }

  int getConstantValue(InstructionTag tag) { none() }

  abstract RawInstruction::Element getRawElement();

  abstract Instruction getSuccessor(InstructionTag tag, SuccessorType succType);

  abstract Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType);

  /**
   * Gets the variable that should be given as the operandTag operand of the instruction with the given tag.
   */
  abstract Variable getVariableOperand(InstructionTag tag, OperandTag operandTag);

  abstract predicate producesResult();

  abstract Variable getResultVariable();

  abstract predicate hasIndex(InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2);

  abstract string toString();

  abstract string getDumpId();
}

predicate hasInstruction(TranslatedElement te, InstructionTag tag) { te.hasInstruction(_, tag, _) }

predicate hasTempVariable(TranslatedElement te, VariableTag tag) { te.hasTempVariable(tag) }

predicate hasSynthVariable(SynthRegisterTag tag) { any(TranslatedElement te).hasSynthVariable(tag) }
