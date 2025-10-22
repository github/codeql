private import semmle.code.binary.ast.instructions as Raw
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.InstructionTag
private import Instruction
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import codeql.util.Either
private import TranslatedInstruction
private import TranslatedOperand
private import Variable
private import codeql.util.Option
private import TranslatedFunction

class Opcode = Opcode::Opcode;

private predicate shouldTranslateInstr(Raw::Instruction instr) { any() }

private predicate shouldTranslateOperand(Raw::Operand operand) { any() }

newtype TTranslatedElement =
  TTranslatedFunction(Raw::Instruction entry) {
    shouldTranslateInstr(entry) and
    (
      entry = any(Raw::Call call).getTarget()
      or
      entry instanceof Raw::ProgramEntryInstruction
      or
      entry instanceof Raw::ExportedEntryInstruction
    )
  } or
  TTranslatedSimpleBinaryInstruction(Raw::Instruction instr) {
    shouldTranslateInstr(instr) and
    isSimpleBinaryInstruction(instr, _, _)
  } or
  TTranslatedImmediateOperand(Raw::ImmediateOperand op) { shouldTranslateOperand(op) } or
  TTranslatedRegisterOperand(Raw::RegisterOperand reg) { shouldTranslateOperand(reg) } or
  TTranslatedMemoryOperand(Raw::MemoryOperand mem) { shouldTranslateOperand(mem) } or
  TTranslatedCall(Raw::Call call) { shouldTranslateInstr(call) } or
  TTranslatedJmp(Raw::Jmp jmp) { shouldTranslateInstr(jmp) and exists(jmp.getTarget()) } or
  TTranslatedMov(Raw::Mov mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovsd(Raw::Movsd mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovq(Raw::Movq mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovss(Raw::Movss mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovzx(Raw::Movzx mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovsxd(Raw::Movsxd mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovsx(Raw::Movsx mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovdqu(Raw::Movdqu mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovdqa(Raw::Movdqa mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovaps(Raw::Movaps mov) { shouldTranslateInstr(mov) } or
  TTranslatedMovups(Raw::Movups mov) { shouldTranslateInstr(mov) } or
  TTranslatedPush(Raw::Push push) { shouldTranslateInstr(push) } or
  TTranslatedTest(Raw::Test test) { shouldTranslateInstr(test) } or
  TTranslatedConditionalJump(Raw::ConditionalJumpInstruction cjmp) { shouldTranslateInstr(cjmp) } or
  TTranslatedCmp(Raw::Cmp cmp) { shouldTranslateInstr(cmp) } or
  TTranslatedLea(Raw::Lea lea) { shouldTranslateInstr(lea) } or
  TTranslatedPop(Raw::Pop pop) { shouldTranslateInstr(pop) } or
  TTranslatedRet(Raw::Ret ret) { shouldTranslateInstr(ret) } or
  TTranslatedDec(Raw::Dec dec) { shouldTranslateInstr(dec) } or
  TTranslatedInc(Raw::Inc inc) { shouldTranslateInstr(inc) } or
  TTranslatedNop(Raw::Nop nop) { shouldTranslateInstr(nop) } or
  TTranslatedBt(Raw::Bt bt) { shouldTranslateInstr(bt) } or
  TTranslatedBtr(Raw::Btr btr) { shouldTranslateInstr(btr) } or
  TTranslatedNeg(Raw::Neg neg) { shouldTranslateInstr(neg) }

TranslatedElement getTranslatedElement(Raw::Element raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

TranslatedInstruction getTranslatedInstruction(Raw::Instruction raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

abstract class TranslatedElement extends TTranslatedElement {
  abstract predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v);

  predicate hasTempVariable(VariableTag tag) { none() }

  predicate hasJumpCondition(InstructionTag tag, Opcode::ConditionKind kind) { none() }

  predicate hasSynthVariable(SynthRegisterTag tag) { none() }

  Variable getVariable(VariableTag tag) { result = TTempVariable(this, tag) }

  final Instruction getInstruction(InstructionTag tag) { result = MkInstruction(this, tag) }

  int getConstantValue(InstructionTag tag) { none() }

  abstract Raw::Element getRawElement();

  abstract Instruction getSuccessor(InstructionTag tag, SuccessorType succType);

  abstract Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType);

  /**
   * Gets the variable that should be given as the operandTag operand of the instruction with the given tag.
   */
  abstract Variable getVariableOperand(InstructionTag tag, OperandTag operandTag);

  abstract predicate producesResult();

  abstract Variable getResultVariable();

  abstract string toString();

  abstract string getDumpId();

  TranslatedFunction getStaticCallTarget(InstructionTag tag) { none() }
}

predicate hasInstruction(TranslatedElement te, InstructionTag tag) { te.hasInstruction(_, tag, _) }

predicate hasTempVariable(TranslatedElement te, VariableTag tag) { te.hasTempVariable(tag) }

predicate hasSynthVariable(SynthRegisterTag tag) { any(TranslatedElement te).hasSynthVariable(tag) }
