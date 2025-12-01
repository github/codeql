private import semmle.code.binary.ast.ir.internal.InstructionSig
private import semmle.code.binary.ast.ir.internal.Tags
private import semmle.code.binary.ast.Location
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.Opcode
private import codeql.util.Option
private import codeql.util.Either
private import codeql.util.Void
private import semmle.code.binary.ast.ir.internal.TransformInstruction.TransformInstruction
private import semmle.code.binary.ast.ir.internal.Instruction0.Instruction0
private import codeql.ssa.Ssa as SsaImpl

module InstructionInput implements Transform<Instruction0>::TransformInputSig {
  // ------------------------------------------------
  class EitherInstructionTranslatedElementTagPair =
    Either<Instruction0::Instruction, TranslatedElementTagPair>::Either;

  class EitherOperandTagOrOperandTag = Either<Instruction0::OperandTag, OperandTag>::Either;

  class EitherVariableOrTranslatedElementVariablePair =
    Either<Instruction0::Variable, EitherTranslatedElementVariablePairOrFunctionLocalVariablePair>::Either;

  class OptionEitherVariableOrTranslatedElementPair =
    Option<EitherVariableOrTranslatedElementVariablePair>::Option;

  class EitherTranslatedElementVariablePairOrFunctionLocalVariablePair =
    Either<TranslatedElementVariablePair, FunctionLocalVariablePair>::Either;

  private newtype TInstructionTag = SingleTag()

  class OperandTag extends Void {
    int getIndex() { none() }

    EitherOperandTagOrOperandTag getSuccessorTag() { none() }

    EitherOperandTagOrOperandTag getPredecessorTag() { none() }
  }

  class InstructionTag extends TInstructionTag {
    string toString() { result = "SingleTag" }
  }

  class TempVariableTag = Void;

  private newtype TLocalVariableTag =
    MemToSsaVarTag(int offset) {
      offset = getLoadOffset(_)
      or
      offset = getStoreOffset(_)
    }

  class LocalVariableTag extends TLocalVariableTag {
    string toString() {
      exists(int offset | this = MemToSsaVarTag(offset) |
        if offset < 0
        then result = "v_neg" + (-offset).toString()
        else result = "v" + offset.toString()
      )
    }

    predicate isStackAllocated() { any() }
  }

  predicate variableHasOrdering(EitherVariableOrTranslatedElementVariablePair v, int ordering) {
    exists(Instruction0::Function f, FunctionLocalVariablePair p |
      p = v.asRight().asRight() and
      p.getFunction() = f and
      p =
        rank[ordering + 1](FunctionLocalVariablePair cand, int index |
          cand.getFunction() = f and
          cand.getLocalVariableTag() = MemToSsaVarTag(index)
        |
          cand order by index
        )
    )
  }

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

  private newtype TFunctionLocalVariablePair =
    MkFunctionLocalVariablePair(Instruction0::Function f, LocalVariableTag tag) {
      exists(TranslatedElement te |
        te.getEnclosingFunction() = f and
        te.hasLocalVariable(tag)
      )
    }

  class FunctionLocalVariablePair extends TFunctionLocalVariablePair {
    Instruction0::Function f;
    LocalVariableTag tag;

    FunctionLocalVariablePair() { this = MkFunctionLocalVariablePair(f, tag) }

    string toString() { none() }

    Instruction0::Function getFunction() { result = f }

    LocalVariableTag getLocalVariableTag() { result = tag }
  }

  private newtype TTranslatedElementVariablePair =
    MkTranslatedElementVariablePair(TranslatedElement te, TempVariableTag tag) {
      te.hasTempVariable(tag)
    }

  class TranslatedElementVariablePair extends TTranslatedElementVariablePair {
    TranslatedElement te;
    TempVariableTag tag;

    TranslatedElementVariablePair() { this = MkTranslatedElementVariablePair(te, tag) }

    string toString() { none() }

    TranslatedElement getTranslatedElement() { result = te }

    TempVariableTag getVariableTag() { result = tag }
  }

  // ------------------------------------------------
  private module SsaInput implements SsaImpl::InputSig<Location, Instruction0::BasicBlock> {
    class SourceVariable = Instruction0::Variable;

    predicate variableWrite(Instruction0::BasicBlock bb, int i, SourceVariable v, boolean certain) {
      bb.getNode(i).asInstruction().getResultVariable() = v and
      certain = true
    }

    predicate variableRead(Instruction0::BasicBlock bb, int i, SourceVariable v, boolean certain) {
      bb.getNode(i).asOperand().getVariable() = v and
      certain = true
    }
  }

  private module Ssa {
    private module Ssa = SsaImpl::Make<Location, Instruction0::BinaryCfg, SsaInput>;

    class Definition extends Ssa::Definition {
      Instruction0::Instruction getInstruction() {
        exists(Instruction0::BasicBlock bb, int i |
          this.definesAt(_, bb, i) and
          bb.getNode(i).asInstruction() = result
        )
      }

      Instruction0::Operand getARead() {
        exists(Instruction0::BasicBlock bb, int i |
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

      Definition getInput(Instruction0::BasicBlock bb) {
        Ssa::phiHasInputFromBlock(this, result, bb)
      }

      Definition getAnInput() { result = this.getInput(_) }
    }

    class SourceVariable = SsaInput::SourceVariable;

    pragma[nomagic]
    predicate ssaDefReachesRead(
      Instruction0::Variable v, Definition def, Instruction0::BasicBlock bb, int i
    ) {
      Ssa::ssaDefReachesRead(v, def, bb, i)
    }

    pragma[nomagic]
    predicate phiHasInputFromBlock(PhiNode phi, Definition input, Instruction0::BasicBlock bb) {
      Ssa::phiHasInputFromBlock(phi, input, bb)
    }

    pragma[nomagic]
    Instruction0::Instruction getADef(Instruction0::Operand op) {
      exists(Instruction0::Variable v, Ssa::Definition def, Instruction0::BasicBlock bb, int i |
        def = getDef(op) and
        def.definesAt(v, bb, i) and
        result = bb.getNode(i).asInstruction()
      )
    }

    pragma[nomagic]
    Ssa::Definition getDef(Instruction0::Operand op) {
      exists(Instruction0::Variable v, Instruction0::BasicBlock bbRead, int iRead |
        ssaDefReachesRead(v, result, bbRead, iRead) and
        op = bbRead.getNode(iRead).asOperand()
      )
    }
  }

  private int getInstructionConstantValue(Instruction0::Instruction instr) {
    result = instr.(Instruction0::ConstInstruction).getValue()
  }

  pragma[nomagic]
  private int getConstantValue(Instruction0::Operand op) {
    result = getInstructionConstantValue(Ssa::getADef(op))
  }

  private predicate isStackPointerVariable(Instruction0::Variable v) {
    v instanceof Instruction0::StackPointer
  }

  /** Holds if `def2 = def1 + k`. */
  pragma[nomagic]
  private predicate step(Ssa::Definition def1, Ssa::Definition def2, int k) {
    exists(Instruction0::BinaryInstruction binary, Ssa::Definition left, int c |
      left.getARead() = binary.getLeftOperand() and
      c = getConstantValue(binary.getRightOperand()) and
      def2.getInstruction() = binary and
      def1 = left
    |
      binary instanceof Instruction0::AddInstruction and
      k = c
      or
      binary instanceof Instruction0::SubInstruction and
      k = -c
    )
    or
    def2.getInstruction().(Instruction0::CopyInstruction).getOperand() = def1.getARead() and
    k = 0
    // or
    // // TODO: Restrict it non-back edges to prevent non-termination?
    // def2.(Ssa::PhiNode).getAnInput() = def1 and
    // k = 0
  }

  private predicate isSource(Ssa::Definition def, int k) {
    exists(Ssa::SourceVariable v |
      v = def.getInstruction().(Instruction0::InitInstruction).getResultVariable() and
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

  private int getLoadOffset(Instruction0::LoadInstruction load) {
    exists(Ssa::Definition def |
      def.getARead() = load.getOperand() and
      result = unique(int offset | fwd(def, offset))
    )
  }

  private int getStoreOffset(Instruction0::StoreInstruction store) {
    exists(Ssa::Definition def |
      def.getARead() = store.getAddressOperand() and
      result = unique(int offset | fwd(def, offset))
    )
  }

  private newtype TTranslatedElement =
    TTranslatedLoad(Instruction0::LoadInstruction load) { exists(getLoadOffset(load)) } or
    TTranslatedStore(Instruction0::StoreInstruction store) { exists(getStoreOffset(store)) } or
    TTranslatedVariable(Instruction0::Function f, int offset) {
      exists(Instruction0::Instruction instr |
        offset = getLoadOffset(instr) or offset = getStoreOffset(instr)
      |
        instr.getEnclosingFunction() = f
      )
    }

  EitherVariableOrTranslatedElementVariablePair getResultVariable(Instruction0::Instruction instr) {
    none()
  }

  EitherVariableOrTranslatedElementVariablePair getOperandVariable(Instruction0::Operand op) {
    exists(Ssa::Definition def, Instruction0::LoadInstruction load, Instruction0::Function f |
      def.getInstruction() = load and
      def.getARead() = op and
      f = load.getEnclosingFunction() and
      result.asRight().asRight().getFunction() = f and
      result.asRight().asRight().getLocalVariableTag() = MemToSsaVarTag(getLoadOffset(load))
    )
  }

  private predicate isRemovedAddress0(Instruction0::Instruction instr) {
    exists(Ssa::Definition def | instr = def.getInstruction() |
      exists(Instruction0::LoadInstruction load |
        exists(TTranslatedLoad(load)) and
        load.getOperand() = unique( | | def.getARead())
      )
      or
      exists(Instruction0::StoreInstruction store |
        exists(TTranslatedStore(store)) and
        store.getAddressOperand() = unique( | | def.getARead())
      )
    )
  }

  private predicate isRemovedAddress(Instruction0::Instruction instr) {
    isRemovedAddress0(instr)
    or
    exists(Ssa::Definition def |
      def.getInstruction() = instr and
      forex(Instruction0::Operand op | op = def.getARead() | isRemovedAddress(op.getUse())) // TODO: Recursion through forex is bad for performance
    )
  }

  predicate isRemovedInstruction(Instruction0::Instruction instr) {
    exists(TTranslatedLoad(instr))
    or
    exists(TTranslatedStore(instr))
    or
    isRemovedAddress(instr)
    or
    // Remove initializations of stack/frame pointer initializations if they
    // are not used
    exists(Instruction0::InitInstruction init | instr = init |
      init.getResultVariable() instanceof Instruction0::StackPointer
      or
      init.getResultVariable() instanceof Instruction0::FramePointer
    ) and
    not any(Ssa::Definition def).getInstruction() = instr
  }

  abstract class TranslatedElement extends TTranslatedElement {
    abstract EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    );

    abstract EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction0::Instruction i, SuccessorType succType
    );

    abstract predicate producesResult();

    Instruction0::Function getStaticTarget(InstructionTag tag) { none() }

    int getConstantValue(InstructionTag tag) { none() }

    EitherInstructionTranslatedElementTagPair getReferencedInstruction(InstructionTag tag) {
      none()
    }

    abstract Instruction0::Function getEnclosingFunction();

    predicate hasJumpCondition(InstructionTag tag, ConditionKind kind) { none() }

    predicate hasTempVariable(TempVariableTag tag) { none() }

    predicate hasLocalVariable(LocalVariableTag tag) { none() }

    abstract EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, EitherOperandTagOrOperandTag operandTag
    );

    abstract predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    );

    abstract string toString();

    abstract string getDumpId();

    abstract Either<Instruction0::Instruction, Instruction0::Operand>::Either getRawElement();
  }

  abstract class TranslatedInstruction extends TranslatedElement {
    Instruction0::Instruction instr;

    override Either<Instruction0::Instruction, Instruction0::Operand>::Either getRawElement() {
      result.asLeft() = instr
    }

    abstract EitherInstructionTranslatedElementTagPair getEntry();
  }

  private class TranslatedLoadInstruction extends TranslatedInstruction {
    override Instruction0::LoadInstruction instr;

    TranslatedLoadInstruction() { this = TTranslatedLoad(instr) }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      none()
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction0::Instruction i, SuccessorType succType
    ) {
      i.getSuccessor(succType) = instr and
      result.asLeft() = instr.getASuccessor()
    }

    override predicate producesResult() { none() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, EitherOperandTagOrOperandTag operandTag
    ) {
      none()
    }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      none()
    }

    override string toString() { result = "TranslatedLoadInstruction" }

    final override predicate hasLocalVariable(LocalVariableTag tag) {
      tag = MemToSsaVarTag(getLoadOffset(instr))
    }

    final override Instruction0::Function getEnclosingFunction() {
      result = instr.getEnclosingFunction()
    }

    final override EitherInstructionTranslatedElementTagPair getEntry() { none() }

    final override string getDumpId() { result = instr.getResultVariable().toString() } // TODO: Don't use toString
  }

  private Instruction0::Instruction getPredecessorIfRemoved(Instruction0::Instruction instr) {
    isRemovedInstruction(instr) and
    result = instr.getAPredecessor()
  }

  private Instruction0::Instruction getLastNonRemoved(Instruction0::Instruction instr) {
    result = getPredecessorIfRemoved*(instr) and not isRemovedInstruction(result)
  }

  private Instruction0::Instruction getSuccessorIfRemoved(Instruction0::Instruction instr) {
    isRemovedInstruction(instr) and
    result = instr.getASuccessor()
  }

  private Instruction0::Instruction getFirstNonRemoved(Instruction0::Instruction instr) {
    result = getSuccessorIfRemoved*(instr) and not isRemovedInstruction(result)
  }

  private class TranslatedStoreInstruction extends TranslatedInstruction {
    override Instruction0::StoreInstruction instr;

    TranslatedStoreInstruction() { this = TTranslatedStore(instr) }

    int getOffset() { result = getStoreOffset(instr) }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      tag = SingleTag() and
      result.asLeft() = getFirstNonRemoved(instr.getSuccessor(succType))
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction0::Instruction i, SuccessorType succType
    ) {
      i = getLastNonRemoved(instr) and
      succType instanceof DirectSuccessor and
      result.asRight().getTranslatedElement() = this and
      result.asRight().getInstructionTag() = SingleTag()
    }

    override predicate producesResult() { none() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, EitherOperandTagOrOperandTag operandTag
    ) {
      tag = SingleTag() and
      operandTag.asLeft() instanceof Instruction0::UnaryTag and
      result.asLeft() = instr.getValueOperand().getVariable()
    }

    final override Instruction0::Function getEnclosingFunction() {
      result = instr.getEnclosingFunction()
    }

    final override predicate hasLocalVariable(LocalVariableTag tag) {
      tag = MemToSsaVarTag(getStoreOffset(instr))
    }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      opcode instanceof Copy and
      tag = SingleTag() and
      v.asSome().asRight().asRight().getFunction() = instr.getEnclosingFunction() and
      v.asSome().asRight().asRight().getLocalVariableTag() = MemToSsaVarTag(getStoreOffset(instr))
    }

    override string toString() { result = "TranslatedStoreInstruction" }

    final override EitherInstructionTranslatedElementTagPair getEntry() { none() }

    final override string getDumpId() {
      result = instr.getAddressOperand().getVariable().toString()
    } // TODO: Don't use toString
  }
}

module Instruction1 = Transform<Instruction0>::Make<InstructionInput>;
