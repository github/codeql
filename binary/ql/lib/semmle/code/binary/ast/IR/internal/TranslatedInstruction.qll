private import semmle.code.binary.ast.instructions as RawInstruction
private import semmle.code.binary.ast.operand as RawOperand
private import TranslatedElement
private import Opcode as Opcode
private import SimpleBinaryInstruction
private import InstructionTag
private import semmle.code.binary.ast.registers as Registers
private import Instruction
private import Variable
private import codeql.util.Option
private import TranslatedOperand
private import codeql.controlflow.SuccessorType
private import codeql.util.Either

abstract class TranslatedInstruction extends TranslatedElement {
  RawInstruction::Instruction instr;

  final override RawInstruction::Element getRawElement() { result = instr }

  predicate isOperandLoaded(RawOperand::MemoryOperand op) { op = instr.getAnOperand() }

  abstract Instruction getEntry();

  override string toString() { result = "Translation of " + instr }

  final override string getDumpId() { result = "i" + instr.getIndex().toString() }
}

/**
 * An instruction that writes to a destination operand, which may require
 * generating a Store instruction.
 */
abstract class WritingInstruction extends TranslatedInstruction {
  abstract RawOperand::Operand getDestinationOperand();

  abstract Instruction getResultInstruction();

  abstract Either<InstructionTag, TranslatedElement>::Either getLast();

  final override predicate producesResult() { any() }

  private predicate shouldGenerateStore() {
    this.getDestinationOperand() instanceof RawOperand::MemoryOperand
  }

  private TranslatedMemoryOperand getTranslatedDestinationOperand() {
    result = getTranslatedOperand(this.getDestinationOperand())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    tag = WriteTag() and
    this.shouldGenerateStore() and
    opcode = Opcode::Store() and
    v.isNone()
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = WriteTag() and
    this.shouldGenerateStore() and
    (
      operandTag = StoreSourceTag() and
      result = this.getResultInstruction().getResultVariable()
      or
      operandTag = StoreDestTag() and
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

  override predicate hasIndex(InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2) {
    tag = WriteTag() and
    (
      this.getInstruction(this.getLast().asLeft()).hasInternalOrder(index0, index1 - 1, index2)
      or
      this.getLast().asRight().hasIndex(_, index0, index1 - 1, index2)
    )
  }
}

predicate isSimpleBinaryInstruction(
  RawInstruction::Instruction instr, Opcode opcode, RawOperand::Operand r
) {
  instr instanceof RawInstruction::Sub and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Sbb and opcode = Opcode::Sub() and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof RawInstruction::Subpd and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Subsd and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Subss and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Psubb and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Psubw and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Psubd and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Psubq and opcode = Opcode::Sub() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Add and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Paddb and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Paddw and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Paddd and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Paddq and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Addpd and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Addsd and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Addss and opcode = Opcode::Add() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Adc and opcode = Opcode::Add() and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof RawInstruction::Adox and opcode = Opcode::Add() and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof RawInstruction::Imul and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Imulzu and opcode = Opcode::Mul() and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof RawInstruction::Mulpd and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Mulps and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Mulsd and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Mulss and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Pmullw and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Pmulld and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Pmulhw and opcode = Opcode::Mul() and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof RawInstruction::Pmulhuw and opcode = Opcode::Mul() and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof RawInstruction::Pmuludq and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Pmuldq and opcode = Opcode::Mul() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Divpd and opcode = Opcode::Div() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Divps and opcode = Opcode::Div() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Divsd and opcode = Opcode::Div() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Divss and opcode = Opcode::Div() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::And and opcode = Opcode::And() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Pand and opcode = Opcode::And() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Andpd and opcode = Opcode::And() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Andps and opcode = Opcode::And() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Or and opcode = Opcode::Or() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Por and opcode = Opcode::Or() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Orpd and opcode = Opcode::Or() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Orps and opcode = Opcode::Or() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Xor and opcode = Opcode::Xor() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Pxor and opcode = Opcode::Xor() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Xorpd and opcode = Opcode::Xor() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Xorps and opcode = Opcode::Xor() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Shl and opcode = Opcode::Shl() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Shr and opcode = Opcode::Shr() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Sar and opcode = Opcode::Sar() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Rol and opcode = Opcode::Rol() and r = instr.getOperand(0)
  or
  instr instanceof RawInstruction::Ror and opcode = Opcode::Ror() and r = instr.getOperand(0)
}

class TranslatedSimpleBinaryInstruction extends WritingInstruction,
  TTranslatedSimpleBinaryInstruction
{
  Opcode opcode;
  RawOperand::Operand dest;

  TranslatedSimpleBinaryInstruction() {
    this = TTranslatedSimpleBinaryInstruction(instr) and
    isSimpleBinaryInstruction(instr, opcode, dest)
  }

  final override Either<InstructionTag, TranslatedElement>::Either getLast() {
    result.asLeft() = SingleTag()
  }

  override Instruction getResultInstruction() { result = this.getInstruction(SingleTag()) }

  final override RawOperand::Operand getDestinationOperand() { result = dest }

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
      operandTag = LeftTag() and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag = RightTag() and
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

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    super.hasIndex(tag, index0, index1, index2)
    or
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

class TranslatedCall extends TranslatedInstruction, TTranslatedCall {
  override RawInstruction::Call instr;

  TranslatedCall() { this = TTranslatedCall(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode = Opcode::Call() and
    v.isNone() // We dont know this yet
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag = CallTargetTag() and
    result = this.getTranslatedOperand().getResultVariable()
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
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
    exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      result = this.getInstruction(SingleTag())
    )
  }

  override Variable getResultVariable() { none() } // TODO: We don't know where this is yet

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

class TranslatedJmp extends TranslatedInstruction, TTranslatedJmp {
  override RawInstruction::Jmp instr;

  TranslatedJmp() { this = TTranslatedJmp(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode = Opcode::Jump() and
    v.isNone() // A jump has no result
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag = JumpTargetTag() and
    result = this.getTranslatedOperand().getResultVariable()
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
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
    exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      result = this.getInstruction(SingleTag())
    )
  }

  override Variable getResultVariable() { none() }

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

abstract class TranslatedCopy extends TranslatedInstruction {
  private predicate shouldGenerateStore() {
    instr.getOperand(0) instanceof RawOperand::MemoryOperand
  }

  override predicate isOperandLoaded(RawOperand::MemoryOperand op) { op = instr.getOperand(1) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    if this.shouldGenerateStore()
    then
      opcode = Opcode::Store() and
      v.isNone()
    else (
      opcode = Opcode::Copy() and
      v.asSome() = this.getTranslatedDestOperand().getResultVariable()
    )
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    if this.shouldGenerateStore()
    then (
      operandTag = StoreSourceTag() and
      result = this.getTranslatedSourceOperand().getResultVariable()
      or
      operandTag = StoreDestTag() and
      result = this.getTranslatedDestOperand().getResultVariable()
    ) else (
      operandTag = UnaryTag() and
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

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

class TranslatedMov extends TranslatedCopy, TTranslatedMov {
  override RawInstruction::Mov instr;

  TranslatedMov() { this = TTranslatedMov(instr) }
}

class TranslatedMovsd extends TranslatedCopy, TTranslatedMovsd {
  override RawInstruction::Movsd instr;

  TranslatedMovsd() { this = TTranslatedMovsd(instr) }
}

class TranslatedMovzx extends TranslatedCopy, TTranslatedMovzx {
  // TODO: This should also perform a zero-extension
  override RawInstruction::Movzx instr;

  TranslatedMovzx() { this = TTranslatedMovzx(instr) }
}

class TranslatedMovsxd extends TranslatedCopy, TTranslatedMovsxd {
  // TODO: What does this one do?
  override RawInstruction::Movsxd instr;

  TranslatedMovsxd() { this = TTranslatedMovsxd(instr) }
}

class TranslatedMovsx extends TranslatedCopy, TTranslatedMovsx {
  // TODO: What does this one do?
  override RawInstruction::Movsx instr;

  TranslatedMovsx() { this = TTranslatedMovsx(instr) }
}

private Variable getEspVariable() {
  result = getTranslatedVariableReal(any(Registers::RspRegister r))
}

class TranslatedPush extends TranslatedInstruction, TTranslatedPush {
  override RawInstruction::Push instr;

  TranslatedPush() { this = TTranslatedPush(instr) }

  override predicate hasTempVariable(VariableTag tag) { tag = PushConstVarTag() }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    // x = 8
    tag = PushSubConstTag() and
    opcode = Opcode::Const() and
    v.asSome() = this.getVariable(PushConstVarTag())
    or
    // esp = esp - x
    tag = PushSubTag() and
    opcode = Opcode::Sub() and
    v.asSome() = getEspVariable()
    or
    // store [esp], y
    tag = PushStoreTag() and
    opcode = Opcode::Store() and
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
      operandTag = LeftTag() and
      result = getEspVariable()
      or
      operandTag = RightTag() and
      result = this.getInstruction(PushSubConstTag()).getResultVariable()
    )
    or
    tag = PushStoreTag() and
    (
      operandTag = StoreSourceTag() and
      result = this.getTranslatedOperand().getResultVariable()
      or
      operandTag = StoreDestTag() and
      result = getEspVariable()
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

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    index0 = instr.getIndex() and
    (
      tag = PushSubConstTag() and
      index1 = 0
      or
      tag = PushSubTag() and
      index1 = 1
      or
      tag = PushStoreTag() and
      index1 = 2
    ) and
    index2 = 0
  }
}

class TranslatedTest extends TranslatedInstruction, TTranslatedTest {
  override RawInstruction::Test instr;

  TranslatedTest() { this = TTranslatedTest(instr) }

  override predicate hasSynthVariable(SynthRegisterTag tag) { tag = CmpRegisterTag() }

  override predicate hasTempVariable(VariableTag tag) {
    tag = TestVarTag()
    or
    tag = ZeroVarTag()
  }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = TestAndTag() and
    opcode = Opcode::And() and
    v.asSome() = this.getVariable(TestVarTag())
    or
    tag = TestZeroTag() and
    opcode = Opcode::Const() and
    v.asSome() = this.getVariable(ZeroVarTag())
    or
    tag = TestCmpTag() and
    opcode = Opcode::Cmp() and
    v.asSome() = getTranslatedVariableSynth(CmpRegisterTag())
  }

  override int getConstantValue(InstructionTag tag) {
    tag = TestZeroTag() and
    result = 0
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = TestAndTag() and
    (
      operandTag = LeftTag() and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag = RightTag() and
      result = this.getRightOperand().getResultVariable()
    )
    or
    tag = TestCmpTag() and
    (
      operandTag = LeftTag() and
      result = this.getVariable(TestVarTag())
      or
      operandTag = RightTag() and
      result = this.getVariable(ZeroVarTag())
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

  override Variable getResultVariable() { result = getTranslatedVariableSynth(CmpRegisterTag()) }

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    index0 = instr.getIndex() and
    (
      tag = TestAndTag() and
      index1 = 0
      or
      tag = TestZeroTag() and
      index1 = 1
      or
      tag = TestCmpTag() and
      index1 = 2
    ) and
    index2 = 0
  }
}

// TODO: This does not handle setting flags via sub. Like:
// #-----|     sub ecx, 0x01
// #-----|     jz +0x3E
class TranslatedConditionalJump extends TranslatedInstruction, TTranslatedConditionalJump {
  override RawInstruction::ConditionalJumpInstruction instr;

  TranslatedConditionalJump() { this = TTranslatedConditionalJump(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode = Opcode::CJump() and
    tag = SingleTag() and
    v.isNone() // A jump has no result
  }

  override predicate hasJumpCondition(InstructionTag tag, Opcode::Condition kind) {
    tag = SingleTag() and
    (
      instr instanceof RawInstruction::Jb and kind = Opcode::LT()
      or
      instr instanceof RawInstruction::Jbe and kind = Opcode::LE()
      or
      instr instanceof RawInstruction::Jz and kind = Opcode::EQ()
      or
      instr instanceof RawInstruction::Jnz and kind = Opcode::NE()
      or
      instr instanceof RawInstruction::Jnb and kind = Opcode::GE()
      or
      instr instanceof RawInstruction::Jnbe and kind = Opcode::GT()
      or
      instr instanceof RawInstruction::Jnl and kind = Opcode::GE()
      or
      instr instanceof RawInstruction::Jnle and kind = Opcode::GT()
      or
      instr instanceof RawInstruction::Jl and kind = Opcode::LT()
      or
      instr instanceof RawInstruction::Jle and kind = Opcode::LE()
      or
      instr instanceof RawInstruction::Js and kind = Opcode::LT() // TODO: Not semantically correct
      or
      instr instanceof RawInstruction::Jns and kind = Opcode::GE() // TODO: Not semantically correct
    )
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    (
      operandTag = JumpTargetTag() and
      result = this.getTranslatedOperand().getResultVariable()
      or
      operandTag = CondTag() and
      result = getTranslatedVariableSynth(CmpRegisterTag())
    )
  }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
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
    exists(Option<Instruction>::Option op | op = this.getTranslatedOperand().getEntry() |
      result = op.asSome()
      or
      op.isNone() and
      result = this.getInstruction(SingleTag())
    )
  }

  override Variable getResultVariable() { none() }

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

class TranslatedCmp extends TranslatedInstruction, TTranslatedCmp {
  override RawInstruction::Cmp instr;

  TranslatedCmp() { this = TTranslatedCmp(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode = Opcode::Cmp() and
    tag = SingleTag() and
    v.asSome() = getTranslatedVariableSynth(CmpRegisterTag())
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    (
      operandTag = LeftTag() and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag = RightTag() and
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

  override Variable getResultVariable() { result = getTranslatedVariableSynth(CmpRegisterTag()) }

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

class TranslatedLea extends TranslatedInstruction, TTranslatedLea {
  override RawInstruction::Lea instr;

  TranslatedLea() { this = TTranslatedLea(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode = Opcode::Copy() and
    v.asSome() = this.getTranslatedDestOperand().getResultVariable()
  }

  override predicate producesResult() { any() }

  override predicate isOperandLoaded(RawOperand::MemoryOperand op) { none() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    operandTag = UnaryTag() and
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

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }

  override string toString() { result = TranslatedInstruction.super.toString() }
}

class TranslatedPop extends TranslatedInstruction, TTranslatedPop {
  override RawInstruction::Pop instr;

  TranslatedPop() { this = TTranslatedPop(instr) }

  override predicate hasTempVariable(VariableTag tag) { tag = PopConstVarTag() }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = PopLoadTag() and
    opcode = Opcode::Load() and
    v.asSome() = this.getTranslatedOperand().getResultVariable()
    or
    // x = 8
    tag = PopAddConstTag() and
    opcode = Opcode::Const() and
    v.asSome() = this.getVariable(PopConstVarTag())
    or
    // esp = esp + x
    tag = PopAddTag() and
    opcode = Opcode::Add() and
    v.asSome() = getEspVariable()
  }

  override int getConstantValue(InstructionTag tag) {
    tag = PopAddConstTag() and
    result = 8 // TODO: Make this depend on architecture
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = PopLoadTag() and
    operandTag = UnaryTag() and
    result = getEspVariable()
    or
    tag = PopAddTag() and
    (
      operandTag = LeftTag() and
      result = getEspVariable()
      or
      operandTag = RightTag() and
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

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    index0 = instr.getIndex() and
    (
      tag = PopLoadTag() and
      index1 = 0
      or
      tag = PopAddConstTag() and
      index1 = 1
      or
      tag = PopAddTag() and
      index1 = 2
    ) and
    index2 = 0
  }
}

class TranslatedRet extends TranslatedInstruction, TTranslatedRet {
  override RawInstruction::Ret instr;

  TranslatedRet() { this = TTranslatedRet(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode = Opcode::Ret() and
    tag = SingleTag() and
    v.isNone()
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override Instruction getEntry() { result = this.getInstruction(SingleTag()) }

  override Variable getResultVariable() { none() }

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

abstract class TranslatedDecOrInc extends WritingInstruction {
  abstract Opcode getOpcode();

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    super.hasInstruction(opcode, tag, v)
    or
    tag = DecOrIncConstTag() and
    opcode = Opcode::Const() and
    v.asSome() = this.getVariable(DecOrIncConstVarTag())
    or
    tag = DecOrIncOpTag() and
    opcode = this.getOpcode() and
    v.asSome() = this.getTranslatedOperand().getResultVariable()
  }

  override int getConstantValue(InstructionTag tag) {
    tag = DecOrIncConstTag() and
    result = 1
  }

  override predicate hasTempVariable(VariableTag tag) {
    tag = DecOrIncConstVarTag()
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    result = super.getVariableOperand(tag, operandTag)
    or
    tag = DecOrIncOpTag() and
    (
      operandTag = LeftTag() and
      result = this.getTranslatedOperand().getResultVariable()
      or
      operandTag = RightTag() and
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

  final override RawOperand::Operand getDestinationOperand() { result = instr.getOperand(0) }

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    super.hasIndex(tag, index0, index1, index2)
    or
    index0 = instr.getIndex() and
    (
      tag = DecOrIncConstTag() and
      index1 = 0
      or
      tag = DecOrIncOpTag() and
      index1 = 1
    ) and
    index2 = 0
  }
}

class TranslatedDec extends TranslatedDecOrInc, TTranslatedDec {
  override RawInstruction::Dec instr;

  TranslatedDec() { this = TTranslatedDec(instr) }

  override Opcode getOpcode() { result = Opcode::Sub() }
}

class TranslatedInc extends TranslatedDecOrInc, TTranslatedInc {
  override RawInstruction::Inc instr;

  TranslatedInc() { this = TTranslatedInc(instr) }

  override Opcode getOpcode() { result = Opcode::Add() }
}

class TranslatedNop extends TranslatedInstruction, TTranslatedNop {
  override RawInstruction::Nop instr;

  TranslatedNop() { this = TTranslatedNop(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode = Opcode::Nop() and
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

  final override predicate hasIndex(
    InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2
  ) {
    tag = SingleTag() and
    index0 = instr.getIndex() and
    index1 = 0 and
    index2 = 0
  }
}

abstract class TranslatedBtBase extends TranslatedInstruction {
  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    opcode = Opcode::Shl() and
    tag = BtShiftTag() and
    v.asSome() = this.getVariable(BtVarTag())
    or
    opcode = Opcode::And() and
    tag = BtAndTag() and
    v.asSome() = this.getVariable(BtVarTag())
    or
    opcode = Opcode::Const() and
    tag = BtOneTag() and
    v.asSome() = this.getVariable(BtOneVarTag())
    or
    opcode = Opcode::Cmp() and
    tag = BtCmpTag() and
    v.asSome() = getTranslatedVariableSynth(CmpRegisterTag())
    or
    opcode = Opcode::Const() and
    tag = BtZeroTag() and
    v.asSome() = this.getVariable(BtZeroVarTag())
  }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = BtShiftTag() and
    (
      operandTag = LeftTag() and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag = RightTag() and
      result = this.getRightOperand().getResultVariable()
    )
    or
    tag = BtAndTag() and
    (
      operandTag = LeftTag() and
      result = this.getVariable(BtVarTag())
      or
      operandTag = RightTag() and
      result = this.getVariable(BtOneVarTag())
    )
    or
    tag = BtCmpTag() and
    (
      operandTag = LeftTag() and
      result = this.getVariable(BtVarTag())
      or
      operandTag = RightTag() and
      result = this.getVariable(BtZeroVarTag())
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

  override predicate hasTempVariable(VariableTag tag) {
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

  override predicate hasIndex(InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2) {
    index0 = instr.getIndex() and
    index2 = 0 and
    (
      tag = BtShiftTag() and
      index1 = 0
      or
      tag = BtOneTag() and
      index1 = 1
      or
      tag = BtAndTag() and
      index1 = 2
      or
      tag = BtZeroTag() and
      index1 = 3
      or
      tag = BtCmpTag() and
      index1 = 4
    )
  }

  final override Variable getResultVariable() {
    result = getTranslatedVariableSynth(CmpRegisterTag())
  }
}

class TranslatedBt extends TranslatedBtBase, TTranslatedBt {
  override RawInstruction::Bt instr;

  TranslatedBt() { this = TTranslatedBt(instr) }

  override TranslatedOperand getLeftOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override TranslatedOperand getRightOperand() {
    result = getTranslatedOperand(instr.getOperand(1))
  }

  override Instruction getSuccessorAfterCmp() {
    result = getTranslatedInstruction(instr.getASuccessor()).getEntry()
  }
}

class TranslatedBtr extends TranslatedBtBase, TTranslatedBtr {
  override RawInstruction::Btr instr;

  TranslatedBtr() { this = TTranslatedBtr(instr) }

  override TranslatedOperand getLeftOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override TranslatedOperand getRightOperand() {
    result = getTranslatedOperand(instr.getOperand(1))
  }

  override predicate hasTempVariable(VariableTag tag) {
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
    opcode = Opcode::Const() and
    v.asSome() = this.getVariable(BtrOneVarTag())
    or
    tag = BtrShiftTag() and
    opcode = Opcode::Shl() and
    v.asSome() = this.getVariable(BtrVarTag())
    or
    tag = BtrNotTag() and
    opcode = Opcode::Not() and
    v.asSome() = this.getVariable(BtrVarTag())
    or
    tag = BtrAndTag() and
    opcode = Opcode::And() and
    v.asSome() = this.getVariable(BtrVarTag())
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
      operandTag = LeftTag() and
      result = this.getVariable(BtrOneVarTag())
      or
      operandTag = RightTag() and
      result = this.getRightOperand().getResultVariable()
    )
    or
    tag = BtrNotTag() and
    operandTag = UnaryTag() and
    result = this.getVariable(BtrVarTag())
    or
    tag = BtrAndTag() and
    (
      operandTag = LeftTag() and
      result = this.getLeftOperand().getResultVariable()
      or
      operandTag = RightTag() and
      result = this.getVariable(BtrVarTag())
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

  override predicate hasIndex(InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2) {
    super.hasIndex(tag, index0, index1, index2)
    or
    index2 = 0 and
    exists(int maxIndex1 |
      maxIndex1 = max(int i | super.hasIndex(_, index0, i, _)) and
      index0 = instr.getIndex()
    |
      tag = BtrOneTag() and
      index1 = maxIndex1 + 1
      or
      tag = BtrShiftTag() and
      index1 = maxIndex1 + 2
      or
      tag = BtrNotTag() and
      index1 = maxIndex1 + 3
      or
      tag = BtrAndTag() and
      index1 = maxIndex1 + 4
    )
  }

  override Instruction getSuccessorAfterCmp() { result = this.getInstruction(BtrOneTag()) }
}
