private import semmle.code.binary.ast.Location
private import semmle.code.binary.ast.instructions as Raw
private import TranslatedElement
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import semmle.code.binary.ast.ir.internal.Tags
private import InstructionTag
private import Instruction
private import Variable
private import TranslatedFunction
private import codeql.util.Option
private import TranslatedOperand
private import TempVariableTag
private import codeql.controlflow.SuccessorType
private import codeql.util.Either

abstract class TranslatedInstruction extends TranslatedElement {
  abstract Instruction getEntry();
}

abstract class TranslatedX86Instruction extends TranslatedInstruction {
  Raw::X86Instruction instr;

  predicate isOperandLoaded(Raw::X86MemoryOperand op) { op = instr.getAnOperand() }

  final override Raw::Element getRawElement() { result = instr }

  override string toString() { result = "Translation of " + instr.toString() }

  final override string getDumpId() { result = "i" + instr.getIndex().toString() }

  final override TranslatedFunction getEnclosingFunction() {
    result.getRawElement() = instr
    or
    result = getTranslatedInstruction(instr.getAPredecessor()).getEnclosingFunction()
  }

  final StackPointer getStackPointer() {
    result = this.getLocalVariable(X86RegisterTag(any(Raw::RspRegister sp)))
  }

  final override Location getLocation() { result = instr.getLocation() }
}

abstract class TranslatedCilInstruction extends TranslatedInstruction {
  Raw::CilInstruction instr;

  final override Raw::Element getRawElement() { result = instr }

  override string toString() { result = "Translation of " + instr.toString() }

  final override string getDumpId() { result = "i" + instr.getOffset().toString() }

  /**
   * Gets the i-th stack element (from the top) after this instruction has executed.
   */
  abstract Variable getStackElement(int i);

  final override TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(instr.getEnclosingMethod())
  }

  final Variable getCilLocalVariable(int index) {
    result = this.getLocalVariable(StlocVarTag(index))
  }

  final override Location getLocation() { result = instr.getLocation() }
}

/**
 * An instruction that writes to a destination operand, which may require
 * generating a Store instruction.
 */
abstract class WritingInstruction extends TranslatedX86Instruction {
  abstract Raw::X86Operand getDestinationOperand();

  abstract Instruction getResultInstruction();

  abstract Either<InstructionTag, TranslatedElement>::Either getLast();

  final override predicate producesResult() { any() }

  private predicate shouldGenerateStore() {
    this.getDestinationOperand() instanceof Raw::X86MemoryOperand
  }

  private TranslatedX86MemoryOperand getTranslatedDestinationOperand() {
    result = getTranslatedOperand(this.getDestinationOperand())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    tag = WriteTag() and
    this.shouldGenerateStore() and
    opcode instanceof Opcode::Store and
    v.isNone()
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = WriteTag() and
    this.shouldGenerateStore() and
    (
      operandTag instanceof StoreValueTag and
      result = this.getResultInstruction().getResultVariable()
      or
      operandTag instanceof StoreAddressTag and
      result = this.getTranslatedDestinationOperand().getAddressVariable()
    )
  }

  final override Variable getResultVariable() {
    if this.shouldGenerateStore()
    then none()
    else result = this.getResultInstruction().getResultVariable()
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = this.getLast().asLeft() and
    succType instanceof DirectSuccessor and
    if this.shouldGenerateStore()
    then result = this.getInstruction(WriteTag())
    else result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
    or
    this.shouldGenerateStore() and
    tag = WriteTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getLast().asRight() and
    succType instanceof DirectSuccessor and
    if this.shouldGenerateStore()
    then result = this.getInstruction(WriteTag())
    else result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }
}

predicate isSimpleBinaryInstruction(Raw::X86Instruction instr, Opcode opcode, Raw::X86Operand r) {
  instr instanceof Raw::X86Sub and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Sbb and opcode instanceof Opcode::Sub and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::X86Subpd and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Subsd and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Subss and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Psubb and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Psubw and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Psubd and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Psubq and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Add and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Paddb and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Paddw and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Paddd and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Paddq and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Addpd and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Addsd and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Addss and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Adc and opcode instanceof Opcode::Add and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::X86Adox and opcode instanceof Opcode::Add and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::X86Imul and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Imulzu and opcode instanceof Opcode::Mul and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::X86Mulpd and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Mulps and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Mulsd and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Mulss and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Pmullw and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Pmulld and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Pmulhw and opcode instanceof Opcode::Mul and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::X86Pmulhuw and opcode instanceof Opcode::Mul and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::X86Pmuludq and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Pmuldq and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Divpd and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Divps and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Divsd and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Divss and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86And and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Pand and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Andpd and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Andps and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Or and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Por and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Orpd and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Orps and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Xor and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Pxor and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Xorpd and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Xorps and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Shl and opcode instanceof Opcode::Shl and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Shr and opcode instanceof Opcode::Shr and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Sar and opcode instanceof Opcode::Sar and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Rol and opcode instanceof Opcode::Rol and r = instr.getOperand(0)
  or
  instr instanceof Raw::X86Ror and opcode instanceof Opcode::Ror and r = instr.getOperand(0)
}

class TranslatedX86SimpleBinaryInstruction extends WritingInstruction,
  TTranslatedX86SimpleBinaryInstruction
{
  Opcode opcode;
  Raw::X86Operand dest;

  TranslatedX86SimpleBinaryInstruction() {
    this = TTranslatedX86SimpleBinaryInstruction(instr) and
    isSimpleBinaryInstruction(instr, opcode, dest)
  }

  final override Either<InstructionTag, TranslatedElement>::Either getLast() {
    result.asLeft() = SingleTag()
  }

  override Instruction getResultInstruction() { result = this.getInstruction(SingleTag()) }

  final override Raw::X86Operand getDestinationOperand() { result = dest }

  final override predicate hasInstruction(
    Opcode opcode_, InstructionTag tag, Option<Variable>::Option v
  ) {
    super.hasInstruction(opcode_, tag, v)
    or
    tag = SingleTag() and
    opcode_ = opcode and
    v.asSome() = getTranslatedOperand(dest).getResultVariable()
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    result = super.getVariableOperand(tag, operandTag)
    or
    tag = SingleTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getRightOperand().getResultVariable()
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    result = super.getChildSuccessor(child, succType)
    or
    child = this.getLeftOperand() and
    succType instanceof DirectSuccessor and
    result = this.getRightOperand().getEntry().asSome()
    or
    child = this.getRightOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(SingleTag())
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option left | left = this.getLeftOperand().getEntry() |
      result = left.asSome()
      or
      left.isNone() and
      exists(Option<Instruction>::Option right | right = this.getRightOperand().getEntry() |
        result = right.asSome()
        or
        right.isNone() and
        result = this.getInstruction(SingleTag())
      )
    )
  }

  private TranslatedOperand getLeftOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  private TranslatedOperand getRightOperand() { result = getTranslatedOperand(instr.getOperand(1)) }
}

class TranslatedX86Call extends TranslatedX86Instruction, TTranslatedX86Call {
  override Raw::X86Call instr;

  TranslatedX86Call() { this = TTranslatedX86Call(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Call and
    v.isNone() // We dont know this yet
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    not exists(instr.getTarget()) and
    tag = SingleTag() and
    operandTag instanceof CallTargetTag and
    result = this.getTranslatedOperand().getResultVariable()
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    not exists(instr.getTarget()) and
    child = this.getTranslatedOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(SingleTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    if exists(instr.getTarget())
    then result = this.getInstruction(SingleTag())
    else
      exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
        result = op.asSome()
        or
        op.isNone() and
        result = this.getInstruction(SingleTag())
      )
  }

  override Variable getResultVariable() { none() } // TODO: We don't know where this is yet. Probably rax for x86

  override TranslatedX86Function getStaticCallTarget(InstructionTag tag) {
    tag = SingleTag() and
    result = TTranslatedX86Function(instr.getTarget())
  }
}

class TranslatedX86Jmp extends TranslatedX86Instruction, TTranslatedX86Jmp {
  override Raw::X86Jmp instr;

  TranslatedX86Jmp() { this = TTranslatedX86Jmp(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Jump and
    v.isNone() // A jump has no result
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag instanceof JumpTargetTag and
    not exists(instr.getTarget()) and
    result = this.getTranslatedOperand().getResultVariable()
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    not exists(instr.getTarget()) and
    child = this.getTranslatedOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(SingleTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getTarget()).getEntry()
  }

  override Instruction getEntry() {
    if exists(instr.getTarget())
    then result = this.getInstruction(SingleTag())
    else
      exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
        result = op.asSome()
        or
        op.isNone() and
        result = this.getInstruction(SingleTag())
      )
  }

  override Variable getResultVariable() { none() }
}

abstract class TranslatedCopy extends TranslatedX86Instruction {
  private predicate shouldGenerateStore() { instr.getOperand(0) instanceof Raw::X86MemoryOperand }

  override predicate isOperandLoaded(Raw::X86MemoryOperand op) { op = instr.getOperand(1) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    if this.shouldGenerateStore()
    then
      opcode instanceof Opcode::Store and
      v.isNone()
    else (
      opcode instanceof Opcode::Copy and
      v.asSome() = this.getTranslatedDestOperand().getResultVariable()
    )
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    if this.shouldGenerateStore()
    then (
      operandTag instanceof StoreValueTag and
      result = this.getTranslatedSourceOperand().getResultVariable()
      or
      operandTag instanceof StoreAddressTag and
      result = this.getTranslatedDestOperand().getResultVariable()
    ) else (
      operandTag instanceof UnaryTag and
      result = this.getTranslatedSourceOperand().getResultVariable()
    )
  }

  TranslatedOperand getTranslatedSourceOperand() {
    result = getTranslatedOperand(instr.getOperand(1))
  }

  TranslatedOperand getTranslatedDestOperand() {
    result = getTranslatedOperand(instr.getOperand(0))
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getTranslatedSourceOperand() and
    succType instanceof DirectSuccessor and
    exists(Option<Instruction>::Option dest | dest = this.getTranslatedDestOperand().getEntry() |
      result = dest.asSome()
      or
      dest.isNone() and
      result = this.getInstruction(SingleTag())
    )
    or
    child = this.getTranslatedDestOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(SingleTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option src | src = this.getTranslatedSourceOperand().getEntry() |
      result = src.asSome()
      or
      src.isNone() and
      exists(Option<Instruction>::Option dest | dest = this.getTranslatedDestOperand().getEntry() |
        result = dest.asSome()
        or
        dest.isNone() and
        result = this.getInstruction(SingleTag())
      )
    )
  }

  override Variable getResultVariable() {
    result = this.getTranslatedDestOperand().getResultVariable()
  }
}

class TranslatedX86Mov extends TranslatedCopy, TTranslatedX86Mov {
  override Raw::X86Mov instr;

  TranslatedX86Mov() { this = TTranslatedX86Mov(instr) }
}

class TranslatedX86Movsd extends TranslatedCopy, TTranslatedX86Movsd {
  override Raw::X86Movsd instr;

  TranslatedX86Movsd() { this = TTranslatedX86Movsd(instr) }
}

class TranslatedX86Movq extends TranslatedCopy, TTranslatedX86Movq {
  override Raw::X86Movq instr;

  TranslatedX86Movq() { this = TTranslatedX86Movq(instr) }
}

class TranslatedX86Movss extends TranslatedCopy, TTranslatedX86Movss {
  override Raw::X86Movss instr;

  TranslatedX86Movss() { this = TTranslatedX86Movss(instr) }
}

class TranslatedX86Movzx extends TranslatedCopy, TTranslatedX86Movzx {
  // TODO: This should also perform a zero-extension
  override Raw::X86Movzx instr;

  TranslatedX86Movzx() { this = TTranslatedX86Movzx(instr) }
}

class TranslatedX86Movsxd extends TranslatedCopy, TTranslatedX86Movsxd {
  // TODO: What does this one do?
  override Raw::X86Movsxd instr;

  TranslatedX86Movsxd() { this = TTranslatedX86Movsxd(instr) }
}

class TranslatedX86Movsx extends TranslatedCopy, TTranslatedX86Movsx {
  // TODO: What does this one do?
  override Raw::X86Movsx instr;

  TranslatedX86Movsx() { this = TTranslatedX86Movsx(instr) }
}

class TranslatedX86Movaps extends TranslatedCopy, TTranslatedX86Movaps {
  override Raw::X86Movaps instr;

  TranslatedX86Movaps() { this = TTranslatedX86Movaps(instr) }
}

class TranslatedX86Movups extends TranslatedCopy, TTranslatedX86Movups {
  override Raw::X86Movups instr;

  TranslatedX86Movups() { this = TTranslatedX86Movups(instr) }
}

class TranslatedX86Movdqu extends TranslatedCopy, TTranslatedX86Movdqu {
  override Raw::X86Movdqu instr;

  TranslatedX86Movdqu() { this = TTranslatedX86Movdqu(instr) }
}

class TranslatedX86Movdqa extends TranslatedCopy, TTranslatedX86Movdqa {
  override Raw::X86Movdqa instr;

  TranslatedX86Movdqa() { this = TTranslatedX86Movdqa(instr) }
}

class TranslatedX86Push extends TranslatedX86Instruction, TTranslatedX86Push {
  override Raw::X86Push instr;

  TranslatedX86Push() { this = TTranslatedX86Push(instr) }

  override predicate hasTempVariable(TempVariableTag tag) { tag = PushConstVarTag() }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    // x = 8
    tag = PushSubConstTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getTempVariable(PushConstVarTag())
    or
    // esp = esp - x
    tag = PushSubTag() and
    opcode instanceof Opcode::Sub and
    v.asSome() = this.getStackPointer()
    or
    // store [esp], y
    tag = PushStoreTag() and
    opcode instanceof Opcode::Store and
    v.isNone()
  }

  override int getConstantValue(InstructionTag tag) {
    tag = PushSubConstTag() and
    result = 8 // TODO: Make this depend on architecture
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = PushSubTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getStackPointer()
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(PushSubConstTag()).getResultVariable()
    )
    or
    tag = PushStoreTag() and
    (
      operandTag instanceof StoreValueTag and
      result = this.getTranslatedOperand().getResultVariable()
      or
      operandTag instanceof StoreAddressTag and
      result = this.getStackPointer()
    )
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getTranslatedOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(PushSubTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = PushSubConstTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(PushSubTag())
    or
    tag = PushSubTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(PushStoreTag())
    or
    tag = PushStoreTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      result = this.getInstruction(PushSubConstTag())
    )
  }

  override Variable getResultVariable() {
    none() // TODO: We don't know where this is yet. Will need to be fixed by a later analysis
  }
}

class TranslatedX86Test extends TranslatedX86Instruction, TTranslatedX86Test {
  override Raw::X86Test instr;

  TranslatedX86Test() { this = TTranslatedX86Test(instr) }

  override predicate hasLocalVariable(LocalVariableTag tag) { tag = CmpRegisterTag() }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = TestVarTag()
    or
    tag = ZeroVarTag()
  }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = TestAndTag() and
    opcode instanceof Opcode::And and
    v.asSome() = this.getTempVariable(TestVarTag())
    or
    tag = TestZeroTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getTempVariable(ZeroVarTag())
    or
    tag = TestCmpTag() and
    opcode instanceof Opcode::Sub and
    v.asSome() = this.getLocalVariable(CmpRegisterTag())
  }

  override int getConstantValue(InstructionTag tag) {
    tag = TestZeroTag() and
    result = 0
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = TestAndTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getRightOperand().getResultVariable()
    )
    or
    tag = TestCmpTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getTempVariable(TestVarTag())
      or
      operandTag instanceof RightTag and
      result = this.getTempVariable(ZeroVarTag())
    )
  }

  private TranslatedOperand getLeftOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  private TranslatedOperand getRightOperand() { result = getTranslatedOperand(instr.getOperand(1)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getLeftOperand() and
    succType instanceof DirectSuccessor and
    exists(Option<Instruction>::Option right | right = this.getRightOperand().getEntry() |
      result = right.asSome()
      or
      right.isNone() and
      result = this.getInstruction(TestAndTag())
    )
    or
    child = this.getRightOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(TestAndTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = TestAndTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(TestZeroTag())
    or
    tag = TestZeroTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(TestCmpTag())
    or
    tag = TestCmpTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option left | left = this.getLeftOperand().getEntry() |
      result = left.asSome()
      or
      left.isNone() and
      exists(Option<Instruction>::Option right | right = this.getRightOperand().getEntry() |
        result = right.asSome()
        or
        right.isNone() and
        result = this.getInstruction(TestAndTag())
      )
    )
  }

  override Variable getResultVariable() { result = this.getLocalVariable(CmpRegisterTag()) }
}

class TranslatedX86ConditionalJump extends TranslatedX86Instruction, TTranslatedX86ConditionalJump {
  override Raw::X86ConditionalJumpInstruction instr;

  TranslatedX86ConditionalJump() { this = TTranslatedX86ConditionalJump(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::CJump and
    tag = SingleTag() and
    v.isNone() // A jump has no result
  }

  override predicate hasJumpCondition(InstructionTag tag, Opcode::ConditionKind kind) {
    tag = SingleTag() and
    (
      instr instanceof Raw::X86Jb and kind = Opcode::LT()
      or
      instr instanceof Raw::X86Jbe and kind = Opcode::LE()
      or
      instr instanceof Raw::X86Jz and kind = Opcode::EQ()
      or
      instr instanceof Raw::X86Jnz and kind = Opcode::NE()
      or
      instr instanceof Raw::X86Jnb and kind = Opcode::GE()
      or
      instr instanceof Raw::X86Jnbe and kind = Opcode::GT()
      or
      instr instanceof Raw::X86Jnl and kind = Opcode::GE()
      or
      instr instanceof Raw::X86Jnle and kind = Opcode::GT()
      or
      instr instanceof Raw::X86Jl and kind = Opcode::LT()
      or
      instr instanceof Raw::X86Jle and kind = Opcode::LE()
      or
      instr instanceof Raw::X86Js and kind = Opcode::LT() // TODO: Not semantically correct
      or
      instr instanceof Raw::X86Jns and kind = Opcode::GE() // TODO: Not semantically correct
    )
  }

  override predicate hasLocalVariable(LocalVariableTag tag) { tag = CmpRegisterTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    (
      operandTag instanceof CondJumpTargetTag and
      not exists(instr.getTarget()) and
      result = this.getTranslatedOperand().getResultVariable()
      or
      operandTag instanceof CondTag and
      result = this.getLocalVariable(CmpRegisterTag())
    )
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    not exists(instr.getTarget()) and
    child = this.getTranslatedOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(SingleTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    (
      succType.(BooleanSuccessor).getValue() = true and
      result = getTranslatedInstruction(instr.getTarget()).getEntry()
      or
      succType.(BooleanSuccessor).getValue() = false and
      result = getTranslatedInstruction(instr.getFallThrough()).getEntry()
    )
  }

  override Instruction getEntry() {
    if exists(instr.getTarget())
    then result = this.getInstruction(SingleTag())
    else
      exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
        result = op.asSome()
        or
        op.isNone() and
        result = this.getInstruction(SingleTag())
      )
  }

  override Variable getResultVariable() { none() }
}

class TranslatedX86Cmp extends TranslatedX86Instruction, TTranslatedX86Cmp {
  override Raw::X86Cmp instr;

  TranslatedX86Cmp() { this = TTranslatedX86Cmp(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Sub and
    tag = SingleTag() and
    v.asSome() = this.getLocalVariable(CmpRegisterTag())
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getRightOperand().getResultVariable()
    )
  }

  TranslatedOperand getLeftOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  TranslatedOperand getRightOperand() { result = getTranslatedOperand(instr.getOperand(1)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getLeftOperand() and
    succType instanceof DirectSuccessor and
    exists(Option<Instruction>::Option right | right = this.getRightOperand().getEntry() |
      result = right.asSome()
      or
      right.isNone() and
      result = this.getInstruction(SingleTag())
    )
    or
    child = this.getRightOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(SingleTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option left | left = this.getLeftOperand().getEntry() |
      result = left.asSome()
      or
      left.isNone() and
      exists(Option<Instruction>::Option right | right = this.getRightOperand().getEntry() |
        result = right.asSome()
        or
        right.isNone() and
        result = this.getInstruction(SingleTag())
      )
    )
  }

  override Variable getResultVariable() { result = this.getLocalVariable(CmpRegisterTag()) }
}

class TranslatedX86Lea extends TranslatedX86Instruction, TTranslatedX86Lea {
  override Raw::X86Lea instr;

  TranslatedX86Lea() { this = TTranslatedX86Lea(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Copy and
    v.asSome() = this.getTranslatedDestOperand().getResultVariable()
  }

  override predicate producesResult() { any() }

  override predicate isOperandLoaded(Raw::X86MemoryOperand op) { none() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag instanceof UnaryTag and
    result = this.getTranslatedSourceOperand().getResultVariable()
  }

  TranslatedOperand getTranslatedSourceOperand() {
    result = getTranslatedOperand(instr.getOperand(1))
  }

  TranslatedOperand getTranslatedDestOperand() {
    result = getTranslatedOperand(instr.getOperand(0))
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getTranslatedSourceOperand() and
    succType instanceof DirectSuccessor and
    exists(Option<Instruction>::Option dest | dest = this.getTranslatedDestOperand().getEntry() |
      result = dest.asSome()
      or
      dest.isNone() and
      result = this.getInstruction(SingleTag())
    )
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option op | op = this.getTranslatedSourceOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      exists(Option<Instruction>::Option dest | dest = this.getTranslatedDestOperand().getEntry() |
        result = dest.asSome()
        or
        dest.isNone() and
        result = this.getInstruction(SingleTag())
      )
    )
  }

  override Variable getResultVariable() {
    result = this.getTranslatedDestOperand().getResultVariable()
  }
}

class TranslatedX86Pop extends TranslatedX86Instruction, TTranslatedX86Pop {
  override Raw::X86Pop instr;

  TranslatedX86Pop() { this = TTranslatedX86Pop(instr) }

  override predicate hasTempVariable(TempVariableTag tag) { tag = PopConstVarTag() }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = PopLoadTag() and
    opcode instanceof Opcode::Load and
    v.asSome() = this.getTranslatedOperand().getResultVariable()
    or
    // x = 8
    tag = PopAddConstTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getTempVariable(PopConstVarTag())
    or
    // esp = esp + x
    tag = PopAddTag() and
    opcode instanceof Opcode::Add and
    v.asSome() = this.getStackPointer()
  }

  override int getConstantValue(InstructionTag tag) {
    tag = PopAddConstTag() and
    result = 8 // TODO: Make this depend on architecture
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = PopLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getStackPointer()
    or
    tag = PopAddTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getStackPointer()
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(PopAddConstTag()).getResultVariable()
    )
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getTranslatedOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(PopLoadTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = PopLoadTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(PopAddConstTag())
    or
    tag = PopAddConstTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(PopAddTag())
    or
    tag = PopAddTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      result = this.getInstruction(PopLoadTag())
    )
  }

  override Variable getResultVariable() { result = this.getTranslatedOperand().getResultVariable() }
}

class TranslatedX86Ret extends TranslatedX86Instruction, TTranslatedX86Ret {
  override Raw::X86Ret instr;

  TranslatedX86Ret() { this = TTranslatedX86Ret(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Ret and
    tag = SingleTag() and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { none() }
}

abstract class TranslatedX86DecOrInc extends WritingInstruction {
  abstract Opcode getOpcode();

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    super.hasInstruction(opcode, tag, v)
    or
    tag = DecOrIncConstTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getTempVariable(DecOrIncConstVarTag())
    or
    tag = DecOrIncOpTag() and
    opcode = this.getOpcode() and
    v.asSome() = this.getTranslatedOperand().getResultVariable()
  }

  override int getConstantValue(InstructionTag tag) {
    tag = DecOrIncConstTag() and
    result = 1
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = DecOrIncConstVarTag() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    result = super.getVariableOperand(tag, operandTag)
    or
    tag = DecOrIncOpTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getTranslatedOperand().getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(DecOrIncConstTag()).getResultVariable()
    )
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    result = super.getChildSuccessor(child, succType)
    or
    child = this.getTranslatedOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(DecOrIncConstTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    result = super.getSuccessor(tag, succType)
    or
    tag = DecOrIncConstTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(DecOrIncOpTag())
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      result = this.getInstruction(DecOrIncConstTag())
    )
  }

  final override Instruction getResultInstruction() {
    result = this.getInstruction(DecOrIncOpTag())
  }

  final override Either<InstructionTag, TranslatedElement>::Either getLast() {
    result.asLeft() = DecOrIncOpTag()
  }

  final override Raw::X86Operand getDestinationOperand() { result = instr.getOperand(0) }
}

class TranslatedX86Dec extends TranslatedX86DecOrInc, TTranslatedX86Dec {
  override Raw::X86Dec instr;

  TranslatedX86Dec() { this = TTranslatedX86Dec(instr) }

  override Opcode getOpcode() { result instanceof Opcode::Sub }
}

class TranslatedX86Inc extends TranslatedX86DecOrInc, TTranslatedX86Inc {
  override Raw::X86Inc instr;

  TranslatedX86Inc() { this = TTranslatedX86Inc(instr) }

  override Opcode getOpcode() { result instanceof Opcode::Add }
}

class TranslatedX86Nop extends TranslatedX86Instruction, TTranslatedX86Nop {
  override Raw::X86Nop instr;

  TranslatedX86Nop() { this = TTranslatedX86Nop(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Nop and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { none() }
}

abstract class TranslatedX86BtBase extends TranslatedX86Instruction {
  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    opcode instanceof Opcode::Shl and
    tag = BtShiftTag() and
    v.asSome() = this.getTempVariable(BtVarTag())
    or
    opcode instanceof Opcode::And and
    tag = BtAndTag() and
    v.asSome() = this.getTempVariable(BtVarTag())
    or
    opcode instanceof Opcode::Const and
    tag = BtOneTag() and
    v.asSome() = this.getTempVariable(BtOneVarTag())
    or
    opcode instanceof Opcode::Sub and
    tag = BtCmpTag() and
    v.asSome() = this.getLocalVariable(CmpRegisterTag())
    or
    opcode instanceof Opcode::Const and
    tag = BtZeroTag() and
    v.asSome() = this.getTempVariable(BtZeroVarTag())
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = BtShiftTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getRightOperand().getResultVariable()
    )
    or
    tag = BtAndTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getTempVariable(BtVarTag())
      or
      operandTag instanceof RightTag and
      result = this.getTempVariable(BtOneVarTag())
    )
    or
    tag = BtCmpTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getTempVariable(BtVarTag())
      or
      operandTag instanceof RightTag and
      result = this.getTempVariable(BtZeroVarTag())
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getLeftOperand() and
    succType instanceof DirectSuccessor and
    exists(Option<Instruction>::Option right | right = this.getRightOperand().getEntry() |
      result = right.asSome()
      or
      right.isNone() and
      result = this.getInstruction(BtShiftTag())
    )
    or
    child = this.getRightOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtShiftTag())
  }

  override int getConstantValue(InstructionTag tag) {
    tag = BtOneTag() and
    result = 1
    or
    tag = BtZeroTag() and
    result = 0
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = BtVarTag()
    or
    tag = BtOneVarTag()
    or
    tag = BtZeroVarTag()
  }

  abstract TranslatedOperand getLeftOperand();

  abstract TranslatedOperand getRightOperand();

  abstract Instruction getSuccessorAfterCmp();

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = BtShiftTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtOneTag())
    or
    tag = BtOneTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtAndTag())
    or
    tag = BtAndTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtZeroTag())
    or
    tag = BtZeroTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtCmpTag())
    or
    tag = BtCmpTag() and
    succType instanceof DirectSuccessor and
    result = this.getSuccessorAfterCmp()
  }

  final override Instruction getEntry() {
    exists(Option<Instruction>::Option left | left = this.getLeftOperand().getEntry() |
      result = left.asSome()
      or
      left.isNone() and
      exists(Option<Instruction>::Option right | right = this.getRightOperand().getEntry() |
        result = right.asSome()
        or
        right.isNone() and
        result = this.getInstruction(BtShiftTag())
      )
    )
  }

  final override Variable getResultVariable() { result = this.getLocalVariable(CmpRegisterTag()) }
}

class TranslatedX86Bt extends TranslatedX86BtBase, TTranslatedX86Bt {
  override Raw::X86Bt instr;

  TranslatedX86Bt() { this = TTranslatedX86Bt(instr) }

  override TranslatedOperand getLeftOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override TranslatedOperand getRightOperand() {
    result = getTranslatedOperand(instr.getOperand(1))
  }

  override Instruction getSuccessorAfterCmp() {
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }
}

class TranslatedX86Btr extends TranslatedX86BtBase, TTranslatedX86Btr {
  override Raw::X86Btr instr;

  TranslatedX86Btr() { this = TTranslatedX86Btr(instr) }

  override TranslatedOperand getLeftOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override TranslatedOperand getRightOperand() {
    result = getTranslatedOperand(instr.getOperand(1))
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    super.hasTempVariable(tag)
    or
    tag = BtrVarTag()
    or
    tag = BtrOneVarTag()
  }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    super.hasInstruction(opcode, tag, v)
    or
    tag = BtrOneTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getTempVariable(BtrOneVarTag())
    or
    tag = BtrShiftTag() and
    opcode instanceof Opcode::Shl and
    v.asSome() = this.getTempVariable(BtrVarTag())
    or
    tag = BtrNotTag() and
    opcode instanceof Opcode::Not and
    v.asSome() = this.getTempVariable(BtrVarTag())
    or
    tag = BtrAndTag() and
    opcode instanceof Opcode::And and
    v.asSome() = this.getTempVariable(BtrVarTag())
  }

  override int getConstantValue(InstructionTag tag) {
    result = super.getConstantValue(tag)
    or
    tag = BtrOneTag() and
    result = 1
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    result = super.getVariableOperand(tag, operandTag)
    or
    tag = BtrShiftTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getTempVariable(BtrOneVarTag())
      or
      operandTag instanceof RightTag and
      result = this.getRightOperand().getResultVariable()
    )
    or
    tag = BtrNotTag() and
    operandTag instanceof UnaryTag and
    result = this.getTempVariable(BtrVarTag())
    or
    tag = BtrAndTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getTempVariable(BtrVarTag())
    )
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    result = super.getSuccessor(tag, succType)
    or
    tag = BtrOneTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtrShiftTag())
    or
    tag = BtrShiftTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtrNotTag())
    or
    tag = BtrNotTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(BtrAndTag())
    or
    tag = BtrAndTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getSuccessorAfterCmp() { result = this.getInstruction(BtrOneTag()) }
}

class TranslatedX86Neg extends WritingInstruction, TTranslatedX86Neg {
  override Raw::X86Neg instr;

  TranslatedX86Neg() { this = TTranslatedX86Neg(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Const and
    tag = NegConstZeroTag() and
    v.asSome() = this.getTempVariable(NegConstZeroVarTag())
    or
    opcode instanceof Opcode::Sub and
    tag = NegSubTag() and
    v.asSome() = this.getTranslatedOperand().getResultVariable()
  }

  override int getConstantValue(InstructionTag tag) {
    tag = NegConstZeroTag() and
    result = 0
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = NegConstZeroVarTag() }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = NegSubTag() and
    (
      operandTag instanceof LeftTag and
      result = this.getInstruction(NegConstZeroTag()).getResultVariable()
      or
      operandTag instanceof RightTag and
      result = this.getTranslatedOperand().getResultVariable()
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    child = this.getTranslatedOperand() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(NegConstZeroTag())
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = NegConstZeroTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(NegSubTag())
  }

  override Instruction getEntry() {
    exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      result = this.getInstruction(NegConstZeroTag())
    )
  }

  override Instruction getResultInstruction() { result = this.getInstruction(NegSubTag()) }

  final override Either<InstructionTag, TranslatedElement>::Either getLast() {
    result.asLeft() = NegSubTag()
  }

  final override Raw::X86Operand getDestinationOperand() { result = instr.getOperand(0) }
}

class TranslatedCilNop extends TranslatedCilInstruction, TTranslatedCilNop {
  override Raw::CilNop instr;

  TranslatedCilNop() { this = TTranslatedCilNop(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Nop and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i)
  }
}

class TranslatedCilLdc extends TranslatedCilInstruction, TTranslatedCilLdc {
  override Raw::CilLoadConstant instr;

  TranslatedCilLdc() { this = TTranslatedCilLdc(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getTempVariable(CilLdcConstVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilLdcConstVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override int getConstantValue(InstructionTag tag) {
    tag = SingleTag() and
    result = instr.getValue().toInt() // TODO: Also handle floats
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilLdcConstVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(SingleTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

class TranslatedCilStloc extends TranslatedCilInstruction, TTranslatedCilStloc {
  override Raw::CilStoreLocal instr;

  TranslatedCilStloc() { this = TTranslatedCilStloc(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Copy and
    tag = SingleTag() and
    v.asSome() = this.getCilLocalVariable(instr.getLocalVariableIndex())
  }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = StlocVarTag(instr.getLocalVariableIndex())
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag instanceof UnaryTag and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() {
    result = this.getCilLocalVariable(instr.getLocalVariableIndex())
  }

  final override Variable getStackElement(int i) {
    exists(Raw::CilInstruction pred | pred = instr.getABackwardPredecessor() |
      i = 0 and
      result = getTranslatedCilInstruction(pred).getStackElement(1)
      or
      i > 0 and
      result = getTranslatedCilInstruction(pred).getStackElement(i - 1)
    )
  }
}

class TranslatedCilLdloc extends TranslatedCilInstruction, TTranslatedCilLdloc {
  override Raw::CilLoadLocal instr;

  TranslatedCilLdloc() { this = TTranslatedCilLdloc(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Copy and
    tag = SingleTag() and
    v.asSome() = this.getTempVariable(CilLdLocVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilLdLocVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag instanceof UnaryTag and
    result = this.getCilLocalVariable(instr.getLocalVariableIndex())
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilLdLocVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(SingleTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

class TranslatedCilUnconditionalBranch extends TranslatedCilInstruction,
  TTranslatedCilUnconditionalBranch
{
  override Raw::CilUnconditionalBranchInstruction instr;

  TranslatedCilUnconditionalBranch() { this = TTranslatedCilUnconditionalBranch(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Jump and
    tag = SingleTag() and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag instanceof JumpTargetTag and
    result = getTranslatedInstruction(instr.getABranchTarget()).getResultVariable()
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getABranchTarget()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

abstract class TranslatedCilArithmeticInstruction extends TranslatedCilInstruction,
  TTranslatedCilArithmeticInstruction
{
  override Raw::CilArithmeticInstruction instr;

  abstract Opcode getOpcode();

  TranslatedCilArithmeticInstruction() { this = TTranslatedCilArithmeticInstruction(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode = this.getOpcode() and
    tag = SingleTag() and
    v.asSome() = this.getTempVariable(CilBinaryVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilBinaryVarTag() }

  override predicate producesResult() { any() }

  final override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    exists(Raw::CilInstruction pred | pred = instr.getABackwardPredecessor() |
      operandTag instanceof LeftTag and
      result = getTranslatedCilInstruction(pred).getStackElement(1)
      or
      operandTag instanceof RightTag and
      result = getTranslatedCilInstruction(pred).getStackElement(0)
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    none()
  }

  final override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  final override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  final override Variable getResultVariable() { result = this.getTempVariable(CilBinaryVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(SingleTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

class TranslatedAddInstruction extends TranslatedCilArithmeticInstruction {
  override Raw::CilAddInstruction instr;

  override Opcode getOpcode() { result instanceof Opcode::Add }
}

class TranslatedSubInstruction extends TranslatedCilArithmeticInstruction {
  override Raw::CilSubInstruction instr;

  override Opcode getOpcode() { result instanceof Opcode::Sub }
}

class TranslatedCilMulInstruction extends TranslatedCilArithmeticInstruction {
  override Raw::CilMulInstruction instr;

  override Opcode getOpcode() { result instanceof Opcode::Mul }
}

class TranslatedCilDivInstruction extends TranslatedCilArithmeticInstruction {
  override Raw::CilDivInstruction instr;

  override Opcode getOpcode() { result instanceof Opcode::Div }
}

/**
 * clt ->
 * ```
 * x = sub a b
 * cjump[lt] less_than_label not_less_than_label
 * less_than_label:
 *  result = const 1
 * not_less_than_label:
 *  result = const 0
 * ```
 */
abstract class TranslatedRelationalInstruction extends TranslatedCilInstruction,
  TTranslatedCilRelationalInstruction
{
  override Raw::CilRelationalInstruction instr;

  abstract Opcode::ConditionKind getConditionKind();

  TranslatedRelationalInstruction() { this = TTranslatedCilRelationalInstruction(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Sub and
    tag = CilRelSubTag() and
    v.asSome() = this.getTempVariable(CilRelSubVarTag())
    or
    opcode instanceof Opcode::CJump and
    tag = CilRelCJumpTag() and
    v.isNone()
    or
    opcode instanceof Opcode::Const and
    tag = CilRelConstTag(_) and
    v.asSome() = this.getTempVariable(CilRelVarTag())
  }

  override predicate producesResult() { any() }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = CilRelSubVarTag()
    or
    tag = CilRelVarTag()
  }

  final override predicate hasJumpCondition(InstructionTag tag, Opcode::ConditionKind kind) {
    tag = CilRelCJumpTag() and
    kind = this.getConditionKind()
  }

  final override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilRelSubTag() and
    exists(Raw::CilInstruction pred | pred = instr.getABackwardPredecessor() |
      operandTag instanceof LeftTag and
      result = getTranslatedCilInstruction(pred).getStackElement(1)
      or
      operandTag instanceof RightTag and
      result = getTranslatedCilInstruction(pred).getStackElement(0)
    )
    or
    tag = CilRelCJumpTag() and
    (
      operandTag instanceof CondTag and
      result = this.getInstruction(CilRelSubTag()).getResultVariable()
      or
      operandTag instanceof CondJumpTargetTag and
      result = this.getInstruction(CilRelConstTag(true)).getResultVariable()
    )
  }

  final override int getConstantValue(InstructionTag tag) {
    tag = CilRelConstTag(true) and
    result = 1
    or
    tag = CilRelConstTag(false) and
    result = 0
  }

  final override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    none()
  }

  final override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = CilRelSubTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(CilRelCJumpTag())
    or
    tag = CilRelCJumpTag() and
    result = this.getInstruction(CilRelConstTag(succType.(BooleanSuccessor).getValue()))
    or
    exists(boolean b |
      tag = CilRelConstTag(b) and
      succType instanceof DirectSuccessor and
      result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
    )
  }

  final override Instruction getEntry() { result = this.getInstruction(CilRelSubTag()) }

  final override Variable getResultVariable() { result = this.getTempVariable(CilRelVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getTempVariable(CilRelVarTag())
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

class TranslatedCilClt extends TranslatedRelationalInstruction {
  override Raw::CilClt instr;

  override Opcode::ConditionKind getConditionKind() { result = Opcode::LT() }
}

class TranslatedCilCgt extends TranslatedRelationalInstruction {
  override Raw::CilCgt instr;

  override Opcode::ConditionKind getConditionKind() { result = Opcode::GT() }
}

class TranslatedCilCeq extends TranslatedRelationalInstruction {
  override Raw::CilCeq instr;

  override Opcode::ConditionKind getConditionKind() { result = Opcode::EQ() }
}

/**
 * brtrue target ->
 * ```
 * x = sub a 1
 * cjump[eq] target fallthrough
 * ```
 *
 * brfalse target ->
 * ```
 * x = sub a 0
 * cjump[eq] target fallthrough
 * ```
 */
abstract class TranslatedCilBooleanBranchInstruction extends TranslatedCilInstruction,
  TTranslatedCilBooleanBranchInstruction
{
  override Raw::CilBooleanBranchInstruction instr;

  TranslatedCilBooleanBranchInstruction() { this = TTranslatedCilBooleanBranchInstruction(instr) }

  abstract int getConstantValue();

  final override int getConstantValue(InstructionTag tag) {
    tag = CilBoolBranchConstTag() and
    result = this.getConstantValue()
  }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Const and
    tag = CilBoolBranchConstTag() and
    v.asSome() = this.getTempVariable(CilBoolBranchConstVarTag())
    or
    opcode instanceof Opcode::Sub and
    tag = CilBoolBranchSubTag() and
    v.asSome() = this.getTempVariable(CilBoolBranchSubVarTag())
    or
    opcode instanceof Opcode::CJump and
    tag = CilBoolBranchCJumpTag() and
    v.isNone()
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = CilBoolBranchConstVarTag()
    or
    tag = CilBoolBranchSubVarTag()
  }

  override predicate hasJumpCondition(InstructionTag tag, Opcode::ConditionKind kind) {
    tag = CilBoolBranchCJumpTag() and
    kind = Opcode::EQ()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilBoolBranchCJumpTag() and
    (
      operandTag instanceof CondTag and
      result = this.getInstruction(CilBoolBranchSubTag()).getResultVariable()
      or
      operandTag instanceof CondJumpTargetTag and
      result = getTranslatedCilInstruction(instr.getABranchTarget()).getResultVariable()
    )
    or
    tag = CilBoolBranchSubTag() and
    (
      operandTag instanceof LeftTag and
      result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(0)
      or
      operandTag instanceof RightTag and
      result = this.getInstruction(CilBoolBranchConstTag()).getResultVariable()
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = CilBoolBranchConstTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(CilBoolBranchSubTag())
    or
    tag = CilBoolBranchSubTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(CilBoolBranchCJumpTag())
    or
    tag = CilBoolBranchCJumpTag() and
    (
      succType.(BooleanSuccessor).getValue() = true and
      result = getTranslatedInstruction(instr.getABranchTarget()).getEntry()
      or
      succType.(BooleanSuccessor).getValue() = false and
      result = getTranslatedInstruction(instr.getFallThrough()).getEntry()
    )
  }

  override Instruction getEntry() { result = this.getInstruction(CilBoolBranchConstTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

class TranslatedCilBooleanBranchTrue extends TranslatedCilBooleanBranchInstruction {
  override Raw::CilBooleanBranchTrue instr;

  final override int getConstantValue() { result = 1 }
}

class TranslatedCilBooleanBranchFalse extends TranslatedCilBooleanBranchInstruction {
  override Raw::CilBooleanBranchFalse instr;

  final override int getConstantValue() { result = 0 }
}

class TranslatedCilRet extends TranslatedCilInstruction, TTranslatedCilRet {
  Raw::CilMethod m;
  override Raw::CilIl_ret instr;

  TranslatedCilRet() {
    this = TTranslatedCilRet(instr) and
    m = instr.getEnclosingMethod()
  }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    v.isNone() and
    if m.isVoid() then opcode instanceof Opcode::Ret else opcode instanceof Opcode::RetValue
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    not m.isVoid() and
    tag = SingleTag() and
    operandTag instanceof UnaryTag and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    exists(Raw::CilInstruction pred | pred = instr.getABackwardPredecessor() |
      i = 0 and
      result = getTranslatedCilInstruction(pred).getStackElement(1)
      or
      i > 0 and
      result = getTranslatedCilInstruction(pred).getStackElement(i - 1)
    )
  }
}

class TranslatedCilCall extends TranslatedCilInstruction, TTranslatedCilCall {
  override Raw::CilCall instr;

  TranslatedCilCall() { this = TTranslatedCilCall(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Call and
    tag = CilCallTag() and
    if instr.hasReturnValue()
    then v.asSome() = this.getTempVariable(CallReturnValueTag())
    else v.isNone()
    or
    not exists(instr.getTarget()) and
    opcode instanceof Opcode::ExternalRef and
    tag = CilCallTargetTag() and
    v.asSome() = this.getTempVariable(CilCallTargetVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    instr.hasReturnValue() and
    tag = CallReturnValueTag()
    or
    not exists(instr.getTarget()) and
    tag = CilCallTargetVarTag()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilCallTag() and
    (
      exists(int index |
        operandTag.(CilOperandTag).getIndex() = index and
        getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(index) = result
      )
      or
      not exists(instr.getTarget()) and
      operandTag instanceof CallTargetTag and
      result = this.getInstruction(CilCallTargetTag()).getResultVariable()
    )
  }

  override string getExternalName(InstructionTag tag) {
    // TODO: Only when external
    not exists(instr.getTarget()) and
    tag = CilCallTargetTag() and
    result = instr.getExternalName()
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    not exists(instr.getTarget()) and
    tag = CilCallTargetTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(CilCallTag())
    or
    tag = CilCallTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() {
    not exists(instr.getTarget()) and
    result = this.getInstruction(CilCallTargetTag())
  }

  override Variable getResultVariable() {
    instr.hasReturnValue() and
    result = this.getTempVariable(CallReturnValueTag())
  }

  override TranslatedFunction getStaticCallTarget(InstructionTag tag) {
    tag = CilCallTag() and
    result = getTranslatedFunction(instr.getTarget())
  }

  final override Variable getStackElement(int i) {
    if instr.hasReturnValue()
    then
      // If the call has a return value, it will be on top of the stack
      if i = 0
      then result = this.getInstruction(CilCallTag()).getResultVariable()
      else
        // Otherwise, get the stack element from the predecessor. However, the call also popped the arguments
        // off the stack, so we need to adjust the index accordingly.
        result =
          getTranslatedCilInstruction(instr.getABackwardPredecessor())
              .getStackElement(i + instr.getNumberOfArguments() - 1)
    else
      // If the call has no return value, just get the stack element from the predecessor, adjusting for the popped arguments.
      result =
        getTranslatedCilInstruction(instr.getABackwardPredecessor())
            .getStackElement(i + instr.getNumberOfArguments())
  }
}

class TranslatedCilLoadString extends TranslatedCilInstruction, TTranslatedCilLoadString {
  override Raw::CilLdstr instr;

  TranslatedCilLoadString() { this = TTranslatedCilLoadString(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Const and
    tag = SingleTag() and
    v.asSome() = this.getTempVariable(CilLoadStringVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilLoadStringVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override string getStringConstant(InstructionTag tag) {
    tag = SingleTag() and
    result = instr.getValue()
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilLoadStringVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(SingleTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

class TranslatedCilLoadArg extends TranslatedCilInstruction, TTranslatedCilLoadArg {
  override Raw::CilLoadArgument instr;

  TranslatedCilLoadArg() { this = TTranslatedCilLoadArg(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Copy and
    tag = SingleTag() and
    v.asSome() = this.getTempVariable(CilLoadArgVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilLoadArgVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag instanceof UnaryTag and
    result = this.getLocalVariable(CilParameterVarTag(instr.getArgumentIndex()))
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilLoadArgVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(SingleTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

/**
 * Translation for CIL ldind.* instructions (load indirect through pointer).
 * These instructions pop an address from the stack and push the value at that address.
 */
class TranslatedCilLoadIndirect extends TranslatedCilInstruction, TTranslatedCilLoadIndirect {
  override Raw::CilLoadIndirectInstruction instr;

  TranslatedCilLoadIndirect() { this = TTranslatedCilLoadIndirect(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Load and
    tag = CilLdindLoadTag() and
    v.asSome() = this.getTempVariable(CilLdindVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilLdindVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilLdindLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = CilLdindLoadTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(CilLdindLoadTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilLdindVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(CilLdindLoadTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i)
  }
}

/**
 * Translation for CIL stind.* instructions (store indirect through pointer).
 * These instructions pop a value and an address from the stack, then store the value at that address.
 */
class TranslatedCilStoreIndirect extends TranslatedCilInstruction, TTranslatedCilStoreIndirect {
  override Raw::CilStoreIndirectInstruction instr;

  TranslatedCilStoreIndirect() { this = TTranslatedCilStoreIndirect(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Store and
    tag = CilStindStoreTag() and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilStindStoreTag() and
    exists(Raw::CilInstruction pred | pred = instr.getABackwardPredecessor() |
      operandTag instanceof StoreAddressTag and
      result = getTranslatedCilInstruction(pred).getStackElement(1)
      or
      operandTag instanceof StoreValueTag and
      result = getTranslatedCilInstruction(pred).getStackElement(0)
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = CilStindStoreTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(CilStindStoreTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i + 2)
  }
}

// Translate a `nobjc<constructor>` CIL instruction to:
// 1. x = init
// 2. call co constructor(x, args...)
class TranslatedNewObject extends TranslatedCilInstruction, TTranslatedNewObject {
  override Raw::CilNewobj instr;

  TranslatedNewObject() { this = TTranslatedNewObject(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    not exists(instr.getConstructor()) and
    opcode instanceof Opcode::ExternalRef and
    tag = CilNewObjExternalRefTag() and
    v.asSome() = this.getTempVariable(CilNewObjCallExternalVarTag())
    or
    opcode instanceof Opcode::Init and
    tag = CilNewObjInitTag() and
    v.asSome() = this.getTempVariable(CilNewObjInitVarTag())
    or
    opcode instanceof Opcode::Call and
    tag = CilNewObjCallTag() and
    v.isNone()
  }

  override string getExternalName(InstructionTag tag) {
    not exists(instr.getConstructor()) and
    tag = CilCallTargetTag() and
    result = instr.getExternalName()
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = CilNewObjInitVarTag()
    or
    not exists(instr.getConstructor()) and tag = CilNewObjCallExternalVarTag()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilNewObjCallTag() and
    (
      not exists(instr.getConstructor()) and
      operandTag instanceof CallTargetTag and
      result = this.getInstruction(CilNewObjExternalRefTag()).getResultVariable()
      or
      exists(int i | i = operandTag.(CilOperandTag).getCilIndex() |
        // The 0'th argument to the constructor is the just-zero-initialized new object
        if i = 0
        then result = this.getInstruction(CilNewObjInitTag()).getResultVariable()
        else
          // And the other arguments are the constructor arguments
          result =
            getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = CilNewObjInitTag() and
    succType instanceof DirectSuccessor and
    (
      if exists(instr.getConstructor())
      then result = this.getInstruction(CilNewObjCallTag())
      else result = this.getInstruction(CilNewObjExternalRefTag())
    )
    or
    not exists(instr.getConstructor()) and
    (
      tag = CilNewObjExternalRefTag() and
      succType instanceof DirectSuccessor and
      result = this.getInstruction(CilNewObjCallTag())
    )
    or
    tag = CilNewObjCallTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(CilNewObjInitTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilNewObjInitVarTag()) }

  final override TranslatedCilMethod getStaticCallTarget(InstructionTag tag) {
    tag = CilNewObjCallTag() and
    result = getTranslatedFunction(instr.getConstructor())
  }

  final override Variable getStackElement(int i) {
    // The new top element is the constructed object
    if i = 0
    then result = this.getTempVariable(CilNewObjInitVarTag())
    else
      // And the other arguments have been popped off the stack.
      // Note: We don't subtract 1 because the number of arguments is actually
      // one more than `instr.getNumberOfArguments()` since we the 0'th
      // argument is the newly-constructed object.
      result =
        getTranslatedCilInstruction(instr.getABackwardPredecessor())
            .getStackElement(i + instr.getNumberOfArguments())
  }
}

class TranslatedDup extends TranslatedCilInstruction, TTranslatedDup {
  override Raw::CilDup instr;

  TranslatedDup() { this = TTranslatedDup(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Copy and
    tag = SingleTag() and
    v.asSome() = this.getTempVariable(CilDupVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilDupVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag instanceof UnaryTag and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilDupVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(SingleTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

/**
 * Translate a CIL stfld instruction to the following sequence:
 * x = fieldaddress[field] obj
 * store x value
 */
class TranslatedCilStoreField extends TranslatedCilInstruction, TTranslatedCilStoreField {
  override Raw::CilStfld instr;

  TranslatedCilStoreField() { this = TTranslatedCilStoreField(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::FieldAddress and
    tag = CilStoreFieldAddressTag() and
    v.asSome() = this.getTempVariable(CilStoreFieldAddressVarTag())
    or
    opcode instanceof Opcode::Store and
    tag = CilStoreFieldStoreTag() and
    v.isNone()
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = CilStoreFieldAddressVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilStoreFieldAddressTag() and
    operandTag instanceof UnaryTag and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(1)
    or
    tag = CilStoreFieldStoreTag() and
    (
      operandTag instanceof StoreAddressTag and
      result = this.getInstruction(CilStoreFieldAddressTag()).getResultVariable()
      or
      operandTag instanceof StoreValueTag and
      result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(0)
    )
  }

  final override string getFieldName(InstructionTag tag) {
    tag = CilStoreFieldAddressTag() and
    result = instr.getField().getName()
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = CilStoreFieldAddressTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(CilStoreFieldStoreTag())
    or
    tag = CilStoreFieldStoreTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(CilStoreFieldAddressTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i + 2)
  }
}

class TranslatedCilLoadField extends TranslatedCilInstruction, TTranslatedCilLoadField {
  override Raw::CilLdfld instr;

  TranslatedCilLoadField() { this = TTranslatedCilLoadField(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::FieldAddress and
    tag = CilLoadFieldAddressTag() and
    v.asSome() = this.getTempVariable(CilLoadFieldAddressVarTag())
    or
    opcode instanceof Opcode::Load and
    tag = CilLoadFieldLoadTag() and
    v.asSome() = this.getTempVariable(CilLoadFieldLoadVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = CilLoadFieldAddressVarTag() or tag = CilLoadFieldLoadVarTag()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CilLoadFieldAddressTag() and
    operandTag instanceof UnaryTag and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(0)
    or
    tag = CilLoadFieldLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getInstruction(CilLoadFieldAddressTag()).getResultVariable()
  }

  final override string getFieldName(InstructionTag tag) {
    tag = CilLoadFieldAddressTag() and
    result = instr.getField().getName()
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = CilLoadFieldAddressTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(CilLoadFieldLoadTag())
    or
    tag = CilLoadFieldLoadTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(CilLoadFieldAddressTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(CilLoadFieldLoadVarTag()) }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(CilLoadFieldLoadTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedCilInstruction(instr.getABackwardPredecessor()).getStackElement(i)
  }
}

// ============================================================================
// JVM Translated Instructions
// ============================================================================
/**
 * Base class for all translated JVM instructions.
 */
abstract class TranslatedJvmInstruction extends TranslatedInstruction {
  Raw::JvmInstruction instr;

  final override Raw::Element getRawElement() { result = instr }

  override string toString() { result = "Translation of " + instr.toString() }

  final override string getDumpId() { result = "jvm_i" + instr.getOffset().toString() }

  /**
   * Gets the i-th stack element (from the top) after this instruction has executed.
   * JVM uses an operand stack similar to CIL.
   */
  abstract Variable getStackElement(int i);

  final override TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(instr.getEnclosingMethod())
  }

  final Variable getJvmLocalVariable(int index) {
    result = this.getLocalVariable(JvmLocalVarTag(index))
  }

  final override Location getLocation() { result = instr.getLocation() }
}

/**
 * Translation of JVM invoke instructions (invokevirtual, invokestatic, invokespecial, invokeinterface).
 */
class TranslatedJvmInvoke extends TranslatedJvmInstruction, TTranslatedJvmInvoke {
  override Raw::JvmInvoke instr;

  TranslatedJvmInvoke() { this = TTranslatedJvmInvoke(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    // External reference for the method being called
    opcode instanceof Opcode::ExternalRef and
    tag = JvmCallTargetTag() and
    v.asSome() = this.getTempVariable(JvmCallTargetVarTag())
    or
    // The actual call instruction
    opcode instanceof Opcode::Call and
    tag = JvmCallTag() and
    (
      if instr.hasReturnValue()
      then v.asSome() = this.getTempVariable(JvmCallResultVarTag())
      else v.isNone()
    )
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = JvmCallTargetVarTag()
    or
    tag = JvmCallResultVarTag() and instr.hasReturnValue()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = JvmCallTag() and
    operandTag instanceof CallTargetTag and
    result = this.getInstruction(JvmCallTargetTag()).getResultVariable()
  }

  final override string getExternalName(InstructionTag tag) {
    tag = JvmCallTargetTag() and
    result = instr.getCallTarget()
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmCallTargetTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(JvmCallTag())
    or
    tag = JvmCallTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmCallTargetTag()) }

  override Variable getResultVariable() {
    if instr.hasReturnValue() then result = this.getTempVariable(JvmCallResultVarTag()) else none()
  }

  final override Variable getStackElement(int i) {
    // After a call, the return value (if any) is on top of the stack
    i = 0 and
    instr.hasReturnValue() and
    result = this.getInstruction(JvmCallTag()).getResultVariable()
    or
    // Rest of the stack has the arguments removed
    i > 0 and
    result =
      getTranslatedJvmInstruction(instr.getABackwardPredecessor())
          .getStackElement(i - 1 + instr.getNumberOfArguments())
    or
    // If no return value, shift the indices
    i >= 0 and
    not instr.hasReturnValue() and
    result =
      getTranslatedJvmInstruction(instr.getABackwardPredecessor())
          .getStackElement(i + instr.getNumberOfArguments())
  }
}

/**
 * Translation of JVM return instructions.
 */
class TranslatedJvmReturn extends TranslatedJvmInstruction, TTranslatedJvmReturn {
  override Raw::JvmReturn instr;

  TranslatedJvmReturn() { this = TTranslatedJvmReturn(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmReturnTag() and
    v.isNone() and
    (
      if instr.getEnclosingMethod().isVoid()
      then opcode instanceof Opcode::Ret
      else opcode instanceof Opcode::RetValue
    )
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = JvmReturnTag() and
    operandTag instanceof UnaryTag and
    not instr.getEnclosingMethod().isVoid() and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override Instruction getEntry() { result = this.getInstruction(JvmReturnTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) { none() }
}

/**
 * Translation of JVM load local variable instructions.
 */
class TranslatedJvmLoadLocal extends TranslatedJvmInstruction, TTranslatedJvmLoadLocal {
  override Raw::JvmLoadLocal instr;

  TranslatedJvmLoadLocal() { this = TTranslatedJvmLoadLocal(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmLoadLocalTag() and
    opcode instanceof Opcode::Copy and
    v.asSome() = this.getTempVariable(JvmLoadLocalResultVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = JvmLoadLocalResultVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = JvmLoadLocalTag() and
    operandTag instanceof UnaryTag and
    result = this.getJvmLocalVariable(instr.getLocalVariableIndex())
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmLoadLocalTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmLoadLocalTag()) }

  override Variable getResultVariable() {
    result = this.getTempVariable(JvmLoadLocalResultVarTag())
  }

  final override Variable getStackElement(int i) {
    i = 0 and
    result = this.getInstruction(JvmLoadLocalTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = JvmLocalVarTag(instr.getLocalVariableIndex())
  }
}

/**
 * Translation of JVM store local variable instructions.
 */
class TranslatedJvmStoreLocal extends TranslatedJvmInstruction, TTranslatedJvmStoreLocal {
  override Raw::JvmStoreLocal instr;

  TranslatedJvmStoreLocal() { this = TTranslatedJvmStoreLocal(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmStoreLocalTag() and
    opcode instanceof Opcode::Copy and
    v.asSome() = this.getJvmLocalVariable(instr.getLocalVariableIndex())
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = JvmStoreLocalTag() and
    operandTag instanceof UnaryTag and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmStoreLocalTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmStoreLocalTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 1)
  }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = JvmLocalVarTag(instr.getLocalVariableIndex())
  }
}

/**
 * Translation of JVM nop instruction.
 */
class TranslatedJvmNop extends TranslatedJvmInstruction, TTranslatedJvmNop {
  override Raw::JvmNop instr;

  TranslatedJvmNop() { this = TTranslatedJvmNop(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmNopTag() and
    opcode instanceof Opcode::Nop and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmNopTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmNopTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i)
  }
}

/**
 * Translation of JVM conditional branch instructions (ifeq, ifne, if_icmpeq, etc.).
 */
class TranslatedJvmBranch extends TranslatedJvmInstruction, TTranslatedJvmBranch {
  override Raw::JvmConditionalBranch instr;

  TranslatedJvmBranch() { this = TTranslatedJvmBranch(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmBranchCJumpTag() and
    opcode instanceof Opcode::CJump and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    // For unary branches (ifeq, ifne, etc.), the condition value is on the stack
    tag = JvmBranchCJumpTag() and
    operandTag instanceof CondTag and
    instr instanceof Raw::JvmUnaryConditionalBranch and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
    or
    // For binary branches (if_icmpeq, etc.), we'd need to compute comparison
    // For now, use the top stack element as condition
    tag = JvmBranchCJumpTag() and
    operandTag instanceof CondTag and
    instr instanceof Raw::JvmBinaryConditionalBranch and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmBranchCJumpTag() and
    (
      // True branch - goes to branch target
      succType.(BooleanSuccessor).getValue() = true and
      result = getTranslatedJvmInstruction(instr.getBranchTargetInstruction()).getEntry()
      or
      // False branch - falls through to next instruction
      succType.(BooleanSuccessor).getValue() = false and
      result = getTranslatedJvmInstruction(instr.getFallThroughSuccessor()).getEntry()
    )
  }

  override Instruction getEntry() { result = this.getInstruction(JvmBranchCJumpTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    // After a unary branch, one element is consumed
    instr instanceof Raw::JvmUnaryConditionalBranch and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 1)
    or
    // After a binary branch, two elements are consumed
    instr instanceof Raw::JvmBinaryConditionalBranch and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 2)
  }
}

/**
 * Translation of JVM unconditional branch instructions (goto, goto_w).
 */
class TranslatedJvmGoto extends TranslatedJvmInstruction, TTranslatedJvmGoto {
  override Raw::JvmUnconditionalBranch instr;

  TranslatedJvmGoto() { this = TTranslatedJvmGoto(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmGotoJumpTag() and
    opcode instanceof Opcode::Goto and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmGotoJumpTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getBranchTargetInstruction()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmGotoJumpTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i)
  }
}

/**
 * Translation of JVM arithmetic instructions (iadd, isub, imul, idiv, etc.).
 */
class TranslatedJvmArithmetic extends TranslatedJvmInstruction, TTranslatedJvmArithmetic {
  TranslatedJvmArithmetic() { this = TTranslatedJvmArithmetic(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmArithOpTag() and
    v.asSome() = this.getTempVariable(JvmArithResultVarTag()) and
    (
      instr instanceof Raw::JvmAddInstruction and opcode instanceof Opcode::Add
      or
      instr instanceof Raw::JvmSubInstruction and opcode instanceof Opcode::Sub
      or
      instr instanceof Raw::JvmMulInstruction and opcode instanceof Opcode::Mul
      or
      instr instanceof Raw::JvmDivInstruction and opcode instanceof Opcode::Div
      or
      // Remainder uses Div opcode as there's no dedicated Rem opcode
      instr instanceof Raw::JvmRemInstruction and opcode instanceof Opcode::Div
    )
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = JvmArithResultVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = JvmArithOpTag() and
    (
      operandTag instanceof LeftTag and
      result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(1)
      or
      operandTag instanceof RightTag and
      result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmArithOpTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmArithOpTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(JvmArithResultVarTag()) }

  final override Variable getStackElement(int i) {
    // Result replaces two operands with one result
    i = 0 and
    result = this.getInstruction(JvmArithOpTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 1)
  }
}

/**
 * Translation of JVM field access instructions (getfield, putfield, getstatic, putstatic).
 */
class TranslatedJvmFieldAccess extends TranslatedJvmInstruction, TTranslatedJvmFieldAccess {
  override Raw::JvmFieldAccess instr;

  TranslatedJvmFieldAccess() { this = TTranslatedJvmFieldAccess(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    // For field loads (getfield, getstatic)
    instr instanceof Raw::JvmFieldLoad and
    (
      tag = JvmFieldAddressTag() and
      opcode instanceof Opcode::FieldAddress and
      v.asSome() = this.getTempVariable(JvmFieldAddressVarTag())
      or
      tag = JvmFieldLoadTag() and
      opcode instanceof Opcode::Load and
      v.asSome() = this.getTempVariable(JvmFieldLoadResultVarTag())
    )
    or
    // For field stores (putfield, putstatic)
    instr instanceof Raw::JvmFieldStore and
    (
      tag = JvmFieldAddressTag() and
      opcode instanceof Opcode::FieldAddress and
      v.asSome() = this.getTempVariable(JvmFieldAddressVarTag())
      or
      tag = JvmFieldStoreTag() and
      opcode instanceof Opcode::Store and
      v.isNone()
    )
  }

  override predicate hasTempVariable(TempVariableTag tag) {
    tag = JvmFieldAddressVarTag()
    or
    instr instanceof Raw::JvmFieldLoad and tag = JvmFieldLoadResultVarTag()
  }

  override predicate producesResult() { any() }

  override string getFieldName(InstructionTag tag) {
    tag = JvmFieldAddressTag() and
    result = instr.getFieldClassName() + "." + instr.getFieldName()
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    // For field load, read from the address
    tag = JvmFieldLoadTag() and
    operandTag instanceof LoadAddressTag and
    result = this.getTempVariable(JvmFieldAddressVarTag())
    or
    // For field store, write to the address
    tag = JvmFieldStoreTag() and
    (
      operandTag instanceof StoreAddressTag and
      result = this.getTempVariable(JvmFieldAddressVarTag())
      or
      operandTag instanceof StoreValueTag and
      result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
    )
    or
    // For non-static field access, use object reference as base
    tag = JvmFieldAddressTag() and
    operandTag instanceof UnaryTag and
    not instr.isStatic() and
    (
      instr instanceof Raw::JvmFieldLoad and
      result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
      or
      instr instanceof Raw::JvmFieldStore and
      result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(1)
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    succType instanceof DirectSuccessor and
    (
      tag = JvmFieldAddressTag() and
      (
        instr instanceof Raw::JvmFieldLoad and
        result = this.getInstruction(JvmFieldLoadTag())
        or
        instr instanceof Raw::JvmFieldStore and
        result = this.getInstruction(JvmFieldStoreTag())
      )
      or
      (tag = JvmFieldLoadTag() or tag = JvmFieldStoreTag()) and
      result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
    )
  }

  override Instruction getEntry() { result = this.getInstruction(JvmFieldAddressTag()) }

  override Variable getResultVariable() {
    instr instanceof Raw::JvmFieldLoad and
    result = this.getTempVariable(JvmFieldLoadResultVarTag())
  }

  final override Variable getStackElement(int i) {
    // For getfield: consumes object ref, pushes field value
    instr instanceof Raw::JvmGetfield and
    (
      i = 0 and result = this.getInstruction(JvmFieldLoadTag()).getResultVariable()
      or
      i > 0 and
      result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i)
    )
    or
    // For getstatic: pushes field value (no object ref consumed)
    instr instanceof Raw::JvmGetstatic and
    (
      i = 0 and result = this.getInstruction(JvmFieldLoadTag()).getResultVariable()
      or
      i > 0 and
      result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
    )
    or
    // For putfield: consumes object ref and value
    instr instanceof Raw::JvmPutfield and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 2)
    or
    // For putstatic: consumes value only
    instr instanceof Raw::JvmPutstatic and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 1)
  }
}

/**
 * Translation of JVM new instruction (object allocation).
 */
class TranslatedJvmNew extends TranslatedJvmInstruction, TTranslatedJvmNew {
  override Raw::JvmNew instr;

  TranslatedJvmNew() { this = TTranslatedJvmNew(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmNewInitTag() and
    opcode instanceof Opcode::Init and
    v.asSome() = this.getTempVariable(JvmNewResultVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = JvmNewResultVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmNewInitTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmNewInitTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(JvmNewResultVarTag()) }

  final override Variable getStackElement(int i) {
    // new pushes the uninitialized object reference onto the stack
    i = 0 and
    result = this.getInstruction(JvmNewInitTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

/**
 * Translation of JVM dup instruction (stack duplication).
 */
class TranslatedJvmDup extends TranslatedJvmInstruction, TTranslatedJvmDup {
  override Raw::JvmDupInstruction instr;

  TranslatedJvmDup() { this = TTranslatedJvmDup(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmDupCopyTag() and
    opcode instanceof Opcode::Copy and
    v.asSome() = this.getTempVariable(JvmDupResultVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = JvmDupResultVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = JvmDupCopyTag() and
    operandTag instanceof UnaryTag and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmDupCopyTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmDupCopyTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(JvmDupResultVarTag()) }

  final override Variable getStackElement(int i) {
    // dup duplicates the top element
    i = 0 and
    result = this.getInstruction(JvmDupCopyTag()).getResultVariable()
    or
    // The original element is still there at position 1
    i = 1 and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(0)
    or
    i > 1 and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}

/**
 * Translation of JVM pop instruction (stack pop).
 */
class TranslatedJvmPop extends TranslatedJvmInstruction, TTranslatedJvmPop {
  override Raw::JvmPopInstruction instr;

  TranslatedJvmPop() { this = TTranslatedJvmPop(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmPopTag() and
    opcode instanceof Opcode::Nop and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmPopTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmPopTag()) }

  override Variable getResultVariable() { none() }

  final override Variable getStackElement(int i) {
    // pop removes the top element (pop removes 1, pop2 removes 2)
    instr instanceof Raw::JvmPop and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 1)
    or
    instr instanceof Raw::JvmPop2 and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i + 2)
  }
}

/**
 * Translation of JVM load constant instructions (ldc, bipush, iconst_*, etc.).
 */
class TranslatedJvmLoadConstant extends TranslatedJvmInstruction, TTranslatedJvmLoadConstant {
  override Raw::JvmLoadConstant instr;

  TranslatedJvmLoadConstant() { this = TTranslatedJvmLoadConstant(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = JvmConstTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getTempVariable(JvmConstResultVarTag())
  }

  override predicate hasTempVariable(TempVariableTag tag) { tag = JvmConstResultVarTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = JvmConstTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedJvmInstruction(instr.getASuccessor()).getEntry()
  }

  override Instruction getEntry() { result = this.getInstruction(JvmConstTag()) }

  override Variable getResultVariable() { result = this.getTempVariable(JvmConstResultVarTag()) }

  final override Variable getStackElement(int i) {
    // Constant pushes a value onto the stack
    i = 0 and
    result = this.getInstruction(JvmConstTag()).getResultVariable()
    or
    i > 0 and
    result = getTranslatedJvmInstruction(instr.getABackwardPredecessor()).getStackElement(i - 1)
  }
}
