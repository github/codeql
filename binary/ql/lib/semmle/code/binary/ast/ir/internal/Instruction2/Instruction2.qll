private import semmle.code.binary.ast.ir.internal.InstructionSig
private import semmle.code.binary.ast.ir.internal.InstructionTag
private import semmle.code.binary.ast.Location
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.Opcode
private import codeql.util.Option
private import codeql.util.Either
private import semmle.code.binary.ast.ir.internal.TransformInstruction.TransformInstruction
private import semmle.code.binary.ast.ir.internal.Instruction1.Instruction1
private import codeql.ssa.Ssa as SsaImpl

module InstructionInput implements Transform<Instruction1>::TransformInputSig {
  // ------------------------------------------------
  class EitherInstructionTranslatedElementTagPair =
    Either<Instruction1::Instruction, TranslatedElementTagPair>::Either;

  class EitherVariableOrTranslatedElementVariablePair =
    Either<Instruction1::Variable, TranslatedElementVariablePair>::Either;

  class OptionEitherVariableOrTranslatedElementPair =
    Option<EitherVariableOrTranslatedElementVariablePair>::Option;

  class OptionEitherInstructionTranslatedElementTagPair =
    Option<EitherInstructionTranslatedElementTagPair>::Option;

  private newtype TTranslatedElementTagPair =
    MkTranslatedElementTagPair(TranslatedElement te, InstructionTag tag) {
      te.hasInstruction(_, tag, _)
    }

  class TranslatedElementTagPair extends TTranslatedElementTagPair {
    TranslatedElement te;
    InstructionTag tag;

    TranslatedElementTagPair() { this = MkTranslatedElementTagPair(te, tag) }

    string toString() { none() }

    TranslatedElement getTranslatedElement() { result = te }

    InstructionTag getInstructionTag() { result = tag }
  }

  private newtype TTranslatedElementVariablePair =
    MkTranslatedElementVariablePair(TranslatedElement te, VariableTag tag) {
      te.hasTempVariable(tag)
    }

  class TranslatedElementVariablePair extends TTranslatedElementVariablePair {
    TranslatedElement te;
    VariableTag tag;

    TranslatedElementVariablePair() { this = MkTranslatedElementVariablePair(te, tag) }

    string toString() { none() }

    TranslatedElement getTranslatedElement() { result = te }

    VariableTag getVariableTag() { result = tag }
  }

  // ------------------------------------------------
  private module SsaInput implements SsaImpl::InputSig<Location, Instruction1::BasicBlock> {
    class SourceVariable = Instruction1::Variable;

    predicate variableWrite(Instruction1::BasicBlock bb, int i, SourceVariable v, boolean certain) {
      bb.getNode(i).asInstruction().getResultVariable() = v and
      certain = true
    }

    predicate variableRead(Instruction1::BasicBlock bb, int i, SourceVariable v, boolean certain) {
      bb.getNode(i).asOperand().getVariable() = v and
      certain = true
    }
  }

  private module Ssa {
    private module Ssa = SsaImpl::Make<Location, Instruction1::BinaryCfg, SsaInput>;

    class Definition extends Ssa::Definition {
      Instruction1::Instruction getInstruction() {
        exists(Instruction1::BasicBlock bb, int i |
          this.definesAt(_, bb, i) and
          bb.getNode(i).asInstruction() = result
        )
      }

      Instruction1::Operand getARead() {
        exists(Instruction1::BasicBlock bb, int i |
          Ssa::ssaDefReachesRead(_, this, bb, i) and
          result = bb.getNode(i).asOperand()
        )
      }

      override string toString() {
        result = "SSA def(" + this.getInstruction() + ")"
        or
        not exists(this.getInstruction()) and
        result = super.toString()
      }
    }

    class PhiNode extends Definition, Ssa::PhiNode {
      override string toString() { result = Ssa::PhiNode.super.toString() }

      Definition getInput(Instruction1::BasicBlock bb) {
        Ssa::phiHasInputFromBlock(this, result, bb)
      }

      Definition getAnInput() { result = this.getInput(_) }
    }

    class SourceVariable = SsaInput::SourceVariable;

    pragma[nomagic]
    predicate ssaDefReachesRead(
      Instruction1::Variable v, Definition def, Instruction1::BasicBlock bb, int i
    ) {
      Ssa::ssaDefReachesRead(v, def, bb, i)
    }

    pragma[nomagic]
    predicate phiHasInputFromBlock(PhiNode phi, Definition input, Instruction1::BasicBlock bb) {
      Ssa::phiHasInputFromBlock(phi, input, bb)
    }

    pragma[nomagic]
    Instruction1::Instruction getADef(Instruction1::Operand op) {
      exists(Instruction1::Variable v, Ssa::Definition def, Instruction1::BasicBlock bb, int i |
        def = getDef(op) and
        def.definesAt(v, bb, i) and
        result = bb.getNode(i).asInstruction()
      )
    }

    pragma[nomagic]
    Ssa::Definition getDef(Instruction1::Operand op) {
      exists(Instruction1::Variable v, Instruction1::BasicBlock bbRead, int iRead |
        ssaDefReachesRead(v, result, bbRead, iRead) and
        op = bbRead.getNode(iRead).asOperand()
      )
    }
  }

  private int getInstructionConstantValue(Instruction1::Instruction instr) {
    result = instr.(Instruction1::ConstInstruction).getValue()
  }

  pragma[nomagic]
  private int getConstantValue(Instruction1::Operand op) {
    result = getInstructionConstantValue(Ssa::getADef(op))
  }

  private predicate isStackPointerVariable(Instruction1::Variable v) {
    v.toString() = "rsp" // TODO: Something else here
  }

  /** Holds if `def2 = def1 + k`. */
  pragma[nomagic]
  private predicate step(Ssa::Definition def1, Ssa::Definition def2, int k) {
    exists(Instruction1::BinaryInstruction binary, Ssa::Definition left, int c |
      left.getARead() = binary.getLeftOperand() and
      c = getConstantValue(binary.getRightOperand()) and
      def2.getInstruction() = binary and
      def1 = left
    |
      binary instanceof Instruction1::AddInstruction and
      k = c
      or
      binary instanceof Instruction1::SubInstruction and
      k = -c
    )
    or
    def2.getInstruction().(Instruction1::CopyInstruction).getOperand() = def1.getARead() and
    k = 0
    // or
    // // TODO: Restrict it non-back edges to prevent non-termination?
    // def2.(Ssa::PhiNode).getAnInput() = def1 and
    // k = 0
  }

  private predicate isSource(Ssa::Definition def, int k) {
    exists(Ssa::SourceVariable v |
      v = def.getInstruction().(Instruction1::InitInstruction).getResultVariable() and
      isStackPointerVariable(v)
    ) and
    k = 0
  }

  private predicate fwd(Ssa::Definition def, int k) {
    isSource(def, k)
    or
    exists(Ssa::Definition def0, int k0 |
      fwd(def0, k0) and
      step(def0, def, k - k0)
    )
  }

  private int getLoadOffset(Instruction1::LoadInstruction load) {
    exists(Ssa::Definition def |
      def.getARead() = load.getOperand() and
      result = unique(int offset | fwd(def, offset))
    )
  }

  private int getStoreOffset(Instruction1::StoreInstruction store) {
    exists(Ssa::Definition def |
      def.getARead() = store.getAddressOperand() and
      result = unique(int offset | fwd(def, offset))
    )
  }

  private newtype TTranslatedElement =
    TTranslatedLoad(Instruction1::LoadInstruction load) { exists(getLoadOffset(load)) } or
    TTranslatedStore(Instruction1::StoreInstruction store) { exists(getStoreOffset(store)) } or
    TTranslatedVariable(Instruction1::Function f, int offset) {
      exists(Instruction1::Instruction instr |
        offset = getLoadOffset(instr) or offset = getStoreOffset(instr)
      |
        instr.getEnclosingFunction() = f
      )
    }

  EitherVariableOrTranslatedElementVariablePair getResultVariable(Instruction1::Instruction instr) {
    none()
  }

  EitherVariableOrTranslatedElementVariablePair getOperandVariable(Instruction1::Operand op) {
    exists(
      Ssa::Definition def, Instruction1::LoadInstruction load, Instruction1::Function f, int offset
    |
      def.getInstruction() = load and
      def.getARead() = op and
      f = load.getEnclosingFunction() and
      offset = getLoadOffset(load) and
      result.asRight().getTranslatedElement() = TTranslatedVariable(f, offset) and
      result.asRight().getVariableTag() = MemToSsaVarTag()
    )
  }

  predicate isRemovedInstruction(Instruction1::Instruction instr) {
    exists(TTranslatedLoad(instr))
    or
    exists(TTranslatedStore(instr))
  }

  abstract class TranslatedElement extends TTranslatedElement {
    abstract EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    );

    abstract EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction1::Instruction i, SuccessorType succType
    );

    abstract predicate producesResult();

    Instruction1::Function getStaticTarget(InstructionTag tag) { none() }

    int getConstantValue(InstructionTag tag) { none() }

    EitherInstructionTranslatedElementTagPair getReferencedInstruction(InstructionTag tag) {
      none()
    }

    predicate hasJumpCondition(InstructionTag tag, ConditionKind kind) { none() }

    predicate hasTempVariable(VariableTag tag) { none() }

    abstract EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, OperandTag operandTag
    );

    abstract predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    );

    abstract string toString();

    abstract string getDumpId();

    abstract Either<Instruction1::Instruction, Instruction1::Operand>::Either getRawElement();
  }

  private class TranslatedVariable extends TranslatedElement {
    Instruction1::Function f;
    int offset;

    TranslatedVariable() { this = TTranslatedVariable(f, offset) }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      none()
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction1::Instruction i, SuccessorType succType
    ) {
      none()
    }

    override predicate producesResult() { none() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, OperandTag operandTag
    ) {
      none()
    }

    override predicate hasTempVariable(VariableTag tag) { tag = MemToSsaVarTag() }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      none()
    }

    override string toString() { result = "TranslatedVariable at offset " + offset.toString() }

    override Either<Instruction1::Instruction, Instruction1::Operand>::Either getRawElement() {
      none()
    }

    final override string getDumpId() {
      if offset < 0
      then result = "v_neg" + (-offset).toString()
      else result = "v" + offset.toString()
    }
  }

  abstract class TranslatedInstruction extends TranslatedElement {
    Instruction1::Instruction instr;

    override Either<Instruction1::Instruction, Instruction1::Operand>::Either getRawElement() {
      result.asLeft() = instr
    }

    abstract EitherInstructionTranslatedElementTagPair getEntry();

    final override string getDumpId() { none() }
  }

  private class TranslatedLoadInstruction extends TranslatedInstruction {
    override Instruction1::LoadInstruction instr;

    TranslatedLoadInstruction() { this = TTranslatedLoad(instr) }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      none()
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction1::Instruction i, SuccessorType succType
    ) {
      i.getSuccessor(succType) = instr and
      result.asLeft() = instr.getASuccessor()
    }

    override predicate producesResult() { none() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, OperandTag operandTag
    ) {
      none()
    }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      none()
    }

    override string toString() { result = "TranslatedLoadInstruction" }

    final override EitherInstructionTranslatedElementTagPair getEntry() { none() }
  }

  private class TranslatedStoreInstruction extends TranslatedInstruction {
    override Instruction1::StoreInstruction instr;

    TranslatedStoreInstruction() { this = TTranslatedStore(instr) }

    int getOffset() { result = getStoreOffset(instr) }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      tag = SingleTag() and
      result.asLeft() = instr.getSuccessor(succType)
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction1::Instruction i, SuccessorType succType
    ) {
      i.getSuccessor(succType) = instr and
      result.asRight().getTranslatedElement() = this and
      result.asRight().getInstructionTag() = SingleTag()
    }

    override predicate producesResult() { none() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, OperandTag operandTag
    ) {
      tag = SingleTag() and
      operandTag = UnaryTag() and
      result.asLeft() = instr.getValueOperand().getVariable()
    }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      opcode instanceof Copy and
      tag = SingleTag() and
      v.asSome().asRight().getTranslatedElement() =
        TTranslatedVariable(instr.getEnclosingFunction(), this.getOffset()) and
      v.asSome().asRight().getVariableTag() = MemToSsaVarTag()
    }

    override string toString() { result = "TranslatedStoreInstruction" }

    final override EitherInstructionTranslatedElementTagPair getEntry() { none() }
  }

  abstract class TranslatedOperand extends TranslatedElement {
    abstract OptionEitherInstructionTranslatedElementTagPair getEntry();
  }
}

module Instruction2 = Transform<Instruction1>::Make<InstructionInput>;
