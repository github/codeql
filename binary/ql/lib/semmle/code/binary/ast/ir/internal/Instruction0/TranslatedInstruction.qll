private import semmle.code.binary.ast.instructions as Raw
private import TranslatedElement
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import semmle.code.binary.ast.ir.internal.InstructionTag
private import Instruction
private import Variable
private import TranslatedFunction
private import codeql.util.Option
private import TranslatedOperand
private import codeql.controlflow.SuccessorType
private import codeql.util.Either

abstract class TranslatedInstruction extends TranslatedElement {
  Raw::Instruction instr;

  final override Raw::Element getRawElement() { result = instr }

  predicate isOperandLoaded(Raw::MemoryOperand op) { op = instr.getAnOperand() }

  abstract Instruction getEntry();

  override string toString() { result = "Translation of " + instr }

  final override string getDumpId() { result = "i" + instr.getIndex().toString() }
}

/**
 * An instruction that writes to a destination operand, which may require
 * generating a Store instruction.
 */
abstract class WritingInstruction extends TranslatedInstruction {
  abstract Raw::Operand getDestinationOperand();

  abstract Instruction getResultInstruction();

  abstract Either<InstructionTag, TranslatedElement>::Either getLast();

  final override predicate producesResult() { any() }

  private predicate shouldGenerateStore() {
    this.getDestinationOperand() instanceof Raw::MemoryOperand
  }

  private TranslatedMemoryOperand getTranslatedDestinationOperand() {
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
      operandTag = StoreValueTag() and
      result = this.getResultInstruction().getResultVariable()
      or
      operandTag = StoreAddressTag() and
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

predicate isSimpleBinaryInstruction(Raw::Instruction instr, Opcode opcode, Raw::Operand r) {
  instr instanceof Raw::Sub and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Sbb and opcode instanceof Opcode::Sub and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::Subpd and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Subsd and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Subss and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Psubb and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Psubw and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Psubd and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Psubq and opcode instanceof Opcode::Sub and r = instr.getOperand(0)
  or
  instr instanceof Raw::Add and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Paddb and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Paddw and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Paddd and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Paddq and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Addpd and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Addsd and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Addss and opcode instanceof Opcode::Add and r = instr.getOperand(0)
  or
  instr instanceof Raw::Adc and opcode instanceof Opcode::Add and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::Adox and opcode instanceof Opcode::Add and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::Imul and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Imulzu and opcode instanceof Opcode::Mul and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::Mulpd and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Mulps and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Mulsd and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Mulss and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Pmullw and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Pmulld and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Pmulhw and opcode instanceof Opcode::Mul and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::Pmulhuw and opcode instanceof Opcode::Mul and r = instr.getOperand(0) // TODO: Not semantically correct
  or
  instr instanceof Raw::Pmuludq and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Pmuldq and opcode instanceof Opcode::Mul and r = instr.getOperand(0)
  or
  instr instanceof Raw::Divpd and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::Divps and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::Divsd and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::Divss and opcode instanceof Opcode::Div and r = instr.getOperand(0)
  or
  instr instanceof Raw::And and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::Pand and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::Andpd and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::Andps and opcode instanceof Opcode::And and r = instr.getOperand(0)
  or
  instr instanceof Raw::Or and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::Por and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::Orpd and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::Orps and opcode instanceof Opcode::Or and r = instr.getOperand(0)
  or
  instr instanceof Raw::Xor and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::Pxor and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::Xorpd and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::Xorps and opcode instanceof Opcode::Xor and r = instr.getOperand(0)
  or
  instr instanceof Raw::Shl and opcode instanceof Opcode::Shl and r = instr.getOperand(0)
  or
  instr instanceof Raw::Shr and opcode instanceof Opcode::Shr and r = instr.getOperand(0)
  or
  instr instanceof Raw::Sar and opcode instanceof Opcode::Sar and r = instr.getOperand(0)
  or
  instr instanceof Raw::Rol and opcode instanceof Opcode::Rol and r = instr.getOperand(0)
  or
  instr instanceof Raw::Ror and opcode instanceof Opcode::Ror and r = instr.getOperand(0)
}

class TranslatedSimpleBinaryInstruction extends WritingInstruction,
  TTranslatedSimpleBinaryInstruction
{
  Opcode opcode;
  Raw::Operand dest;

  TranslatedSimpleBinaryInstruction() {
    this = TTranslatedSimpleBinaryInstruction(instr) and
    isSimpleBinaryInstruction(instr, opcode, dest)
  }

  final override Either<InstructionTag, TranslatedElement>::Either getLast() {
    result.asLeft() = SingleTag()
  }

  override Instruction getResultInstruction() { result = this.getInstruction(SingleTag()) }

  final override Raw::Operand getDestinationOperand() { result = dest }

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
}

class TranslatedCall extends TranslatedInstruction, TTranslatedCall {
  override Raw::Call instr;

  TranslatedCall() { this = TTranslatedCall(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Call and
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

  override Variable getResultVariable() { none() } // TODO: We don't know where this is yet. Probably rax for x86

  override TranslatedFunction getStaticCallTarget(InstructionTag tag) {
    tag = SingleTag() and
    result = TTranslatedFunction(instr.getTarget())
  }
}

class TranslatedJmp extends TranslatedInstruction, TTranslatedJmp {
  override Raw::Jmp instr;

  TranslatedJmp() { this = TTranslatedJmp(instr) }

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
}

abstract class TranslatedCopy extends TranslatedInstruction {
  private predicate shouldGenerateStore() { instr.getOperand(0) instanceof Raw::MemoryOperand }

  override predicate isOperandLoaded(Raw::MemoryOperand op) { op = instr.getOperand(1) }

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
      operandTag = StoreValueTag() and
      result = this.getTranslatedSourceOperand().getResultVariable()
      or
      operandTag = StoreAddressTag() and
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
}

class TranslatedMov extends TranslatedCopy, TTranslatedMov {
  override Raw::Mov instr;

  TranslatedMov() { this = TTranslatedMov(instr) }
}

class TranslatedMovsd extends TranslatedCopy, TTranslatedMovsd {
  override Raw::Movsd instr;

  TranslatedMovsd() { this = TTranslatedMovsd(instr) }
}

class TranslatedMovq extends TranslatedCopy, TTranslatedMovq {
  override Raw::Movq instr;

  TranslatedMovq() { this = TTranslatedMovq(instr) }
}

class TranslatedMovss extends TranslatedCopy, TTranslatedMovss {
  override Raw::Movss instr;

  TranslatedMovss() { this = TTranslatedMovss(instr) }
}

class TranslatedMovzx extends TranslatedCopy, TTranslatedMovzx {
  // TODO: This should also perform a zero-extension
  override Raw::Movzx instr;

  TranslatedMovzx() { this = TTranslatedMovzx(instr) }
}

class TranslatedMovsxd extends TranslatedCopy, TTranslatedMovsxd {
  // TODO: What does this one do?
  override Raw::Movsxd instr;

  TranslatedMovsxd() { this = TTranslatedMovsxd(instr) }
}

class TranslatedMovsx extends TranslatedCopy, TTranslatedMovsx {
  // TODO: What does this one do?
  override Raw::Movsx instr;

  TranslatedMovsx() { this = TTranslatedMovsx(instr) }
}

class TranslatedMovaps extends TranslatedCopy, TTranslatedMovaps {
  override Raw::Movaps instr;

  TranslatedMovaps() { this = TTranslatedMovaps(instr) }
}

class TranslatedMovups extends TranslatedCopy, TTranslatedMovups {
  override Raw::Movups instr;

  TranslatedMovups() { this = TTranslatedMovups(instr) }
}

class TranslatedMovdqu extends TranslatedCopy, TTranslatedMovdqu {
  override Raw::Movdqu instr;

  TranslatedMovdqu() { this = TTranslatedMovdqu(instr) }
}

class TranslatedMovdqa extends TranslatedCopy, TTranslatedMovdqa {
  override Raw::Movdqa instr;

  TranslatedMovdqa() { this = TTranslatedMovdqa(instr) }
}

private Variable getEspVariable() { result = getTranslatedVariableReal(any(Raw::RspRegister r)) }

class TranslatedPush extends TranslatedInstruction, TTranslatedPush {
  override Raw::Push instr;

  TranslatedPush() { this = TTranslatedPush(instr) }

  override predicate hasTempVariable(VariableTag tag) { tag = PushConstVarTag() }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    // x = 8
    tag = PushSubConstTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getVariable(PushConstVarTag())
    or
    // esp = esp - x
    tag = PushSubTag() and
    opcode instanceof Opcode::Sub and
    v.asSome() = getEspVariable()
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
      operandTag = LeftTag() and
      result = getEspVariable()
      or
      operandTag = RightTag() and
      result = this.getInstruction(PushSubConstTag()).getResultVariable()
    )
    or
    tag = PushStoreTag() and
    (
      operandTag = StoreValueTag() and
      result = this.getTranslatedOperand().getResultVariable()
      or
      operandTag = StoreAddressTag() and
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
}

class TranslatedTest extends TranslatedInstruction, TTranslatedTest {
  override Raw::Test instr;

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
    opcode instanceof Opcode::And and
    v.asSome() = this.getVariable(TestVarTag())
    or
    tag = TestZeroTag() and
    opcode instanceof Opcode::Const and
    v.asSome() = this.getVariable(ZeroVarTag())
    or
    tag = TestCmpTag() and
    opcode instanceof Opcode::Sub and
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
}

class TranslatedConditionalJump extends TranslatedInstruction, TTranslatedConditionalJump {
  override Raw::ConditionalJumpInstruction instr;

  TranslatedConditionalJump() { this = TTranslatedConditionalJump(instr) }

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
      instr instanceof Raw::Jb and kind = Opcode::LT()
      or
      instr instanceof Raw::Jbe and kind = Opcode::LE()
      or
      instr instanceof Raw::Jz and kind = Opcode::EQ()
      or
      instr instanceof Raw::Jnz and kind = Opcode::NE()
      or
      instr instanceof Raw::Jnb and kind = Opcode::GE()
      or
      instr instanceof Raw::Jnbe and kind = Opcode::GT()
      or
      instr instanceof Raw::Jnl and kind = Opcode::GE()
      or
      instr instanceof Raw::Jnle and kind = Opcode::GT()
      or
      instr instanceof Raw::Jl and kind = Opcode::LT()
      or
      instr instanceof Raw::Jle and kind = Opcode::LE()
      or
      instr instanceof Raw::Js and kind = Opcode::LT() // TODO: Not semantically correct
      or
      instr instanceof Raw::Jns and kind = Opcode::GE() // TODO: Not semantically correct
    )
  }

  override predicate hasSynthVariable(SynthRegisterTag tag) { tag = CmpRegisterTag() }

  override predicate producesResult() { any() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = SingleTag() and
    (
      operandTag = CondJumpTargetTag() and
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
}

class TranslatedCmp extends TranslatedInstruction, TTranslatedCmp {
  override Raw::Cmp instr;

  TranslatedCmp() { this = TTranslatedCmp(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Sub and
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
}

class TranslatedLea extends TranslatedInstruction, TTranslatedLea {
  override Raw::Lea instr;

  TranslatedLea() { this = TTranslatedLea(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = SingleTag() and
    opcode instanceof Opcode::Copy and
    v.asSome() = this.getTranslatedDestOperand().getResultVariable()
  }

  override predicate producesResult() { any() }

  override predicate isOperandLoaded(Raw::MemoryOperand op) { none() }

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

  override string toString() { result = TranslatedInstruction.super.toString() }
}

class TranslatedPop extends TranslatedInstruction, TTranslatedPop {
  override Raw::Pop instr;

  TranslatedPop() { this = TTranslatedPop(instr) }

  override predicate hasTempVariable(VariableTag tag) { tag = PopConstVarTag() }

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
    v.asSome() = this.getVariable(PopConstVarTag())
    or
    // esp = esp + x
    tag = PopAddTag() and
    opcode instanceof Opcode::Add and
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
}

class TranslatedRet extends TranslatedInstruction, TTranslatedRet {
  override Raw::Ret instr;

  TranslatedRet() { this = TTranslatedRet(instr) }

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

abstract class TranslatedDecOrInc extends WritingInstruction {
  abstract Opcode getOpcode();

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    super.hasInstruction(opcode, tag, v)
    or
    tag = DecOrIncConstTag() and
    opcode instanceof Opcode::Const and
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

  override predicate hasTempVariable(VariableTag tag) { tag = DecOrIncConstVarTag() }

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

  final override Raw::Operand getDestinationOperand() { result = instr.getOperand(0) }
}

class TranslatedDec extends TranslatedDecOrInc, TTranslatedDec {
  override Raw::Dec instr;

  TranslatedDec() { this = TTranslatedDec(instr) }

  override Opcode getOpcode() { result instanceof Opcode::Sub }
}

class TranslatedInc extends TranslatedDecOrInc, TTranslatedInc {
  override Raw::Inc instr;

  TranslatedInc() { this = TTranslatedInc(instr) }

  override Opcode getOpcode() { result instanceof Opcode::Add }
}

class TranslatedNop extends TranslatedInstruction, TTranslatedNop {
  override Raw::Nop instr;

  TranslatedNop() { this = TTranslatedNop(instr) }

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

abstract class TranslatedBtBase extends TranslatedInstruction {
  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    opcode instanceof Opcode::Shl and
    tag = BtShiftTag() and
    v.asSome() = this.getVariable(BtVarTag())
    or
    opcode instanceof Opcode::And and
    tag = BtAndTag() and
    v.asSome() = this.getVariable(BtVarTag())
    or
    opcode instanceof Opcode::Const and
    tag = BtOneTag() and
    v.asSome() = this.getVariable(BtOneVarTag())
    or
    opcode instanceof Opcode::Sub and
    tag = BtCmpTag() and
    v.asSome() = getTranslatedVariableSynth(CmpRegisterTag())
    or
    opcode instanceof Opcode::Const and
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

  final override Variable getResultVariable() {
    result = getTranslatedVariableSynth(CmpRegisterTag())
  }
}

class TranslatedBt extends TranslatedBtBase, TTranslatedBt {
  override Raw::Bt instr;

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
  override Raw::Btr instr;

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
    opcode instanceof Opcode::Const and
    v.asSome() = this.getVariable(BtrOneVarTag())
    or
    tag = BtrShiftTag() and
    opcode instanceof Opcode::Shl and
    v.asSome() = this.getVariable(BtrVarTag())
    or
    tag = BtrNotTag() and
    opcode instanceof Opcode::Not and
    v.asSome() = this.getVariable(BtrVarTag())
    or
    tag = BtrAndTag() and
    opcode instanceof Opcode::And and
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

  override Instruction getSuccessorAfterCmp() { result = this.getInstruction(BtrOneTag()) }
}

class TranslatedNeg extends WritingInstruction, TTranslatedNeg {
  override Raw::Neg instr;

  TranslatedNeg() { this = TTranslatedNeg(instr) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::Const and
    tag = NegConstZeroTag() and
    v.asSome() = this.getVariable(NegConstZeroVarTag())
    or
    opcode instanceof Opcode::Sub and
    tag = NegSubTag() and
    v.asSome() = this.getTranslatedOperand().getResultVariable()
  }

  override int getConstantValue(InstructionTag tag) {
    tag = NegConstZeroTag() and
    result = 0
  }

  override predicate hasTempVariable(VariableTag tag) { tag = NegConstZeroVarTag() }

  TranslatedOperand getTranslatedOperand() { result = getTranslatedOperand(instr.getOperand(0)) }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
    tag = NegSubTag() and
    (
      operandTag = LeftTag() and
      result = this.getInstruction(NegConstZeroTag()).getResultVariable()
      or
      operandTag = RightTag() and
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

  final override Raw::Operand getDestinationOperand() { result = instr.getOperand(0) }
}
