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

private predicate shouldTranslateX86Instr(Raw::X86Instruction instr) { any() }

private predicate shouldTranslateX86Operand(Raw::X86Operand operand) {
  // If it has a target we will synthesize an instruction reference instruction
  // instead of translating the operand directly.
  not exists(operand.getUse().(Raw::X86Jmp).getTarget())
}

newtype TTranslatedElement =
  TTranslatedX86Function(Raw::X86Instruction entry) {
    shouldTranslateX86Instr(entry) and
    (
      entry = any(Raw::X86Call call).getTarget()
      or
      entry instanceof Raw::ProgramEntryInstruction
      or
      entry instanceof Raw::ExportedEntryInstruction
    )
  } or
  TTranslatedX86SimpleBinaryInstruction(Raw::X86Instruction instr) {
    shouldTranslateX86Instr(instr) and
    isSimpleBinaryInstruction(instr, _, _)
  } or
  TTranslatedX86ImmediateOperand(Raw::X86ImmediateOperand op) { shouldTranslateX86Operand(op) } or
  TTranslatedX86RegisterOperand(Raw::X86RegisterOperand reg) { shouldTranslateX86Operand(reg) } or
  TTranslatedX86MemoryOperand(Raw::X86MemoryOperand mem) { shouldTranslateX86Operand(mem) } or
  TTranslatedX86Call(Raw::X86Call call) { shouldTranslateX86Instr(call) } or
  TTranslatedX86Jmp(Raw::X86Jmp jmp) { shouldTranslateX86Instr(jmp) and exists(jmp.getTarget()) } or
  TTranslatedX86Mov(Raw::X86Mov mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movsd(Raw::X86Movsd mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movq(Raw::X86Movq mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movss(Raw::X86Movss mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movzx(Raw::X86Movzx mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movsxd(Raw::X86Movsxd mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movsx(Raw::X86Movsx mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movdqu(Raw::X86Movdqu mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movdqa(Raw::X86Movdqa mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movaps(Raw::X86Movaps mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movups(Raw::X86Movups mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Push(Raw::X86Push push) { shouldTranslateX86Instr(push) } or
  TTranslatedX86Test(Raw::X86Test test) { shouldTranslateX86Instr(test) } or
  TTranslatedX86ConditionalJump(Raw::X86ConditionalJumpInstruction cjmp) {
    shouldTranslateX86Instr(cjmp)
  } or
  TTranslatedX86Cmp(Raw::X86Cmp cmp) { shouldTranslateX86Instr(cmp) } or
  TTranslatedX86Lea(Raw::X86Lea lea) { shouldTranslateX86Instr(lea) } or
  TTranslatedX86Pop(Raw::X86Pop pop) { shouldTranslateX86Instr(pop) } or
  TTranslatedX86Ret(Raw::X86Ret ret) { shouldTranslateX86Instr(ret) } or
  TTranslatedX86Dec(Raw::X86Dec dec) { shouldTranslateX86Instr(dec) } or
  TTranslatedX86Inc(Raw::X86Inc inc) { shouldTranslateX86Instr(inc) } or
  TTranslatedX86Nop(Raw::X86Nop nop) { shouldTranslateX86Instr(nop) } or
  TTranslatedX86Bt(Raw::X86Bt bt) { shouldTranslateX86Instr(bt) } or
  TTranslatedX86Btr(Raw::X86Btr btr) { shouldTranslateX86Instr(btr) } or
  TTranslatedX86Neg(Raw::X86Neg neg) { shouldTranslateX86Instr(neg) }

TranslatedElement getTranslatedElement(Raw::Element raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

TranslatedInstruction getTranslatedInstruction(Raw::Element raw) {
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

  Instruction getReferencedInstruction(InstructionTag tag) { none() }

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
