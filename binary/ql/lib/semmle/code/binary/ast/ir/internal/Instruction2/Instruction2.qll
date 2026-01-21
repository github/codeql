private import semmle.code.binary.ast.ir.internal.InstructionSig
private import semmle.code.binary.ast.ir.internal.Tags
private import semmle.code.binary.ast.Location
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.Opcode
private import codeql.util.Option
private import codeql.util.Either
private import codeql.util.Unit
private import codeql.util.Void
private import semmle.code.binary.ast.ir.internal.TransformInstruction.TransformInstruction
private import semmle.code.binary.ast.ir.internal.Instruction1.Instruction1
private import codeql.ssa.Ssa as SsaImpl

private signature module ControlFlowReachableInputSig {
  class FlowState;

  predicate isSource(Instruction1::Instruction i, FlowState state);

  default predicate isBarrier(Instruction1::Instruction i, FlowState state) { none() }

  default predicate isBarrierOut(Instruction1::Instruction i, FlowState state) { none() }

  default predicate isBarrierIn(Instruction1::Instruction i, FlowState state) { none() }

  predicate isSink(Instruction1::Instruction i, FlowState state);
}

private module ControlFlowReachable<ControlFlowReachableInputSig Input> {
  private import Input

  module Make {
    pragma[nomagic]
    private predicate inBarrier(Instruction1::Instruction i, FlowState state) {
      isBarrierIn(i, state) and
      isSource(i, state)
    }

    pragma[nomagic]
    private predicate outBarrier(Instruction1::Instruction i, FlowState state) {
      isBarrierOut(i, state) and
      isSink(i, state)
    }

    pragma[nomagic]
    private predicate isFullBarrier(Instruction1::Instruction i, FlowState state) {
      isBarrier(i, state)
      or
      isBarrierIn(i, state) and
      not isSource(i, state)
      or
      isBarrierOut(i, state) and
      not isSink(i, state)
    }

    pragma[nomagic]
    private predicate sourceInstruction(Instruction1::Instruction i, FlowState state) {
      isSource(i, state) and
      not isFullBarrier(i, state)
    }

    private predicate sinkInstruction(Instruction1::Instruction i, FlowState state) {
      isSink(i, state) and
      not isFullBarrier(i, state)
    }

    bindingset[i1, i2, state]
    pragma[inline_late]
    private predicate stepFilter(
      Instruction1::Instruction i1, Instruction1::Instruction i2, FlowState state
    ) {
      not isFullBarrier(i1, state) and
      not isFullBarrier(i2, state) and
      not outBarrier(i1, state) and
      not inBarrier(i2, state)
    }

    pragma[nomagic]
    private predicate rev(Instruction1::Instruction i, FlowState state) {
      sinkInstruction(i, state)
      or
      exists(Instruction1::Instruction i1 |
        rev(i1, state) and
        i.getASuccessor() = i1 and
        stepFilter(i, i1, state)
      )
    }

    pragma[nomagic]
    private predicate fwd(Instruction1::Instruction i, FlowState state) {
      rev(i, pragma[only_bind_into](state)) and
      (
        sourceInstruction(i, state)
        or
        exists(Instruction1::Instruction i0 |
          fwd(i0, pragma[only_bind_into](state)) and
          i0.getASuccessor() = i and
          stepFilter(i0, i, state)
        )
      )
    }

    private newtype TNode = MkNode(Instruction1::Instruction i, FlowState state) { fwd(i, state) }

    private class Node extends TNode {
      Instruction1::Instruction getInstruction() { this = MkNode(result, _) }

      FlowState getState() { this = MkNode(_, result) }

      string toString() { result = this.getInstruction().toString() }

      Node getASuccessor() {
        exists(Instruction1::Instruction i, FlowState state |
          this = MkNode(i, pragma[only_bind_into](state)) and
          result = MkNode(i.getASuccessor(), pragma[only_bind_into](state))
        )
      }

      predicate isSource() { sourceInstruction(this.getInstruction(), this.getState()) }

      predicate isSink() { sinkInstruction(this.getInstruction(), this.getState()) }
    }

    private Node getASuccessor(Node n) { result = n.getASuccessor() }

    private predicate sourceNode(Node n) { n.isSource() }

    private predicate sinkNode(Node n) { n.isSink() }

    private predicate flowsPlus(Node source, Node sink) =
      doublyBoundedFastTC(getASuccessor/1, sourceNode/1, sinkNode/1)(source, sink)

    predicate flowsTo(Instruction1::Instruction source, Instruction1::Instruction sink) {
      exists(Node n1, Node n2 |
        n1.getInstruction() = source and
        n2.getInstruction() = sink
      |
        flowsPlus(n1, n2)
        or
        n1 = n2 and
        n1.isSource() and
        n2.isSink()
      )
    }
  }
}

/**
 * This transformation inserts missing comparisons in cases such as:
 * ```
 * sub rax, rbx
 * jz label
 * ```
 *
 * It also synthesises parameter instructions.
 */
private module InstructionInput implements Transform<Instruction1>::TransformInputSig {
  // ------------------------------------------------
  class EitherOperandTagOrOperandTag = Either<Instruction1::OperandTag, OperandTag>::Either;

  class EitherInstructionTranslatedElementTagPair =
    Either<Instruction1::Instruction, TranslatedElementTagPair>::Either;

  class EitherVariableOrTranslatedElementVariablePair =
    Either<Instruction1::Variable, EitherTranslatedElementVariablePairOrFunctionLocalVariablePair>::Either;

  class OptionEitherVariableOrTranslatedElementPair =
    Option<EitherVariableOrTranslatedElementVariablePair>::Option;

  class EitherTranslatedElementVariablePairOrFunctionLocalVariablePair =
    Either<TranslatedElementVariablePair, FunctionLocalVariablePair>::Either;

  private newtype TOperandTag =
    ArgOperand(int index) {
      index =
        [0 .. max(Instruction1::CallInstruction call |
            |
            strictcount(Instruction1::Variable v | deadDefFlowsToCall(v, call))
          )]
    }

  class OperandTag extends TOperandTag {
    int getIndex() { this = ArgOperand(result) }

    EitherOperandTagOrOperandTag getSuccessorTag() {
      exists(int i |
        this = ArgOperand(i) and
        result.asRight() = ArgOperand(i + 1)
      )
    }

    EitherOperandTagOrOperandTag getPredecessorTag() {
      this = ArgOperand(0) and
      result.asLeft() instanceof Instruction1::CallTargetTag
      or
      exists(int i |
        this = ArgOperand(i + 1) and
        result.asRight() = ArgOperand(i)
      )
    }

    string toString() {
      exists(int i |
        this = ArgOperand(i) and
        result = "ArgOperand(" + i.toString() + ")"
      )
    }
  }

  private newtype TInstructionTag =
    ZeroTag() or
    CmpDefTag(ConditionKind k) or
    InitializeParameterTag(Instruction1::Variable v) { isReadBeforeInitialization(v, _) }

  class LocalVariableTag extends Void {
    predicate isStackAllocated() { none() }
  }

  private newtype TTempVariableTag = ZeroVarTag()

  class TempVariableTag extends TTempVariableTag {
    TempVariableTag() { this = ZeroVarTag() }

    string toString() { result = "ZeroVarTag" }
  }

  class InstructionTag extends TInstructionTag {
    string toString() {
      this = ZeroTag() and
      result = "ZeroTag"
      or
      exists(ConditionKind k |
        this = CmpDefTag(k) and
        result = "CmpDefTag(" + stringOfConditionKind(k) + ")"
      )
      or
      exists(Instruction1::Variable v |
        this = InitializeParameterTag(v) and
        result = "InitializeParameterTag(" + v.toString() + ")"
      )
    }
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

  private newtype TFunctionLocalVariablePair =
    MkFunctionLocalVariablePair(Instruction1::Function f, LocalVariableTag tag) {
      exists(TranslatedElement te |
        te.getEnclosingFunction() = f and
        te.hasLocalVariable(tag)
      )
    }

  class FunctionLocalVariablePair extends TFunctionLocalVariablePair {
    Instruction1::Function f;
    LocalVariableTag tag;

    FunctionLocalVariablePair() { this = MkFunctionLocalVariablePair(f, tag) }

    string toString() { none() }

    Instruction1::Function getFunction() { result = f }

    LocalVariableTag getLocalVariableTag() { result = tag }
  }

  // ------------------------------------------------
  private predicate modifiesFlag(Instruction1::Instruction i) {
    i instanceof Instruction1::SubInstruction
    or
    i instanceof Instruction1::AddInstruction
    or
    i instanceof Instruction1::ShlInstruction
    or
    i instanceof Instruction1::ShrInstruction
    or
    i instanceof Instruction1::RolInstruction
    or
    i instanceof Instruction1::RorInstruction
    or
    i instanceof Instruction1::OrInstruction
    or
    i instanceof Instruction1::AndInstruction
    or
    i instanceof Instruction1::XorInstruction
  }

  private module ModifiesFlagToCJumpInput implements ControlFlowReachableInputSig {
    class FlowState = Unit;

    predicate isSource(Instruction1::Instruction i, FlowState state) {
      modifiesFlag(i) and exists(state)
    }

    predicate isSink(Instruction1::Instruction i, FlowState state) {
      i instanceof Instruction1::CJumpInstruction and exists(state)
    }

    predicate isBarrierIn(Instruction1::Instruction i, FlowState state) { isSource(i, state) }
  }

  private module ModifiesFlagToCJump = ControlFlowReachable<ModifiesFlagToCJumpInput>::Make;

  private predicate noWriteToFlagSource(
    Instruction1::Instruction i, Instruction1::CJumpInstruction cjump, Instruction1::Variable v
  ) {
    ModifiesFlagToCJump::flowsTo(i, cjump) and
    v = cjump.getConditionOperand().getVariable()
  }

  private module NoWriteToFlagInput implements ControlFlowReachableInputSig {
    class FlowState = Instruction1::Variable;

    predicate isSource(Instruction1::Instruction i, FlowState state) {
      noWriteToFlagSource(i, _, state)
    }

    predicate isSink(Instruction1::Instruction i, FlowState state) {
      i.(Instruction1::CJumpInstruction).getConditionOperand().getVariable() = state
    }

    predicate isBarrierIn(Instruction1::Instruction i, FlowState state) { isSource(i, state) }

    predicate isBarrier(Instruction1::Instruction i, FlowState state) {
      i.getResultVariable() = state
    }
  }

  private module NoWriteToFlag = ControlFlowReachable<NoWriteToFlagInput>::Make;

  /**
   * Holds if there is control-flow from `sub` to a `cmp` instruction with condition kind `kind`.
   *
   * There is only a result if the condition part of `cmp` may be undefined.
   */
  private predicate controlFlowsToCmp(
    Instruction1::Instruction i, Instruction1::CJumpInstruction cjump, ConditionKind kind
  ) {
    // There is control-flow from i to cjump without a write to the
    // variable that is used as a condition to cjump
    NoWriteToFlag::flowsTo(i, cjump) and
    cjump.getKind() = kind
  }

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

  private predicate isReadBeforeInitialization(
    Instruction1::LocalVariable v, Instruction1::Function f
  ) {
    exists(Instruction1::Operand op |
      op.getVariable() = v and
      op.getEnclosingFunction() = f and
      not any(Ssa::Definition def).getARead() = op
    )
  }

  private predicate isDeadDef(Instruction1::Instruction i) {
    i.getResultVariable() instanceof Instruction1::LocalVariable and
    not any(Ssa::Definition def).getInstruction() = i
  }

  private module DeadDefToCallConfig implements ControlFlowReachableInputSig {
    class FlowState = Unit;

    predicate isSource(Instruction1::Instruction i, FlowState state) {
      isDeadDef(i) and exists(state)
    }

    predicate isSink(Instruction1::Instruction i, FlowState state) {
      i instanceof Instruction1::CallInstruction and exists(state)
    }

    predicate isBarrierOut(Instruction1::Instruction i, FlowState state) { isSink(i, state) }
  }

  private module DeadDefToCall = ControlFlowReachable<DeadDefToCallConfig>::Make;

  private predicate deadDefFlowsToCall(
    Instruction1::LocalVariable v, Instruction1::CallInstruction call
  ) {
    exists(Instruction1::Instruction deadDef |
      deadDef.getResultVariable() = v and
      DeadDefToCall::flowsTo(deadDef, call)
    )
  }

  predicate hasAdditionalOperand(
    Instruction1::Instruction i, EitherOperandTagOrOperandTag operandTag,
    EitherVariableOrTranslatedElementVariablePair v
  ) {
    exists(int index, int index0, Instruction1::LocalVariable local |
      operandTag.asRight().getIndex() = index and
      local = v.asLeft() and
      Instruction1::variableHasOrdering(local, index0) and
      deadDefFlowsToCall(local, i) and
      if local.isStackAllocated() then index = index0 + 4 else index = index0
    )
  }

  private newtype TTranslatedElement =
    TTranslatedComparisonInstruction(
      Instruction1::Instruction i, Instruction1::CJumpInstruction cjump, ConditionKind kind
    ) {
      controlFlowsToCmp(i, cjump, kind)
    } or
    TTranslatedInitializeParameters(Instruction1::Function f) { isReadBeforeInitialization(_, f) }

  abstract class TranslatedElement extends TTranslatedElement {
    abstract EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    );

    EitherInstructionTranslatedElementTagPair getReferencedInstruction(InstructionTag tag) {
      none()
    }

    abstract EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction1::Instruction i, SuccessorType succType
    );

    abstract predicate producesResult();

    abstract Instruction1::Function getEnclosingFunction();

    Instruction1::Function getStaticTarget(InstructionTag tag) { none() }

    int getConstantValue(InstructionTag tag) { none() }

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

    abstract Either<Instruction1::Instruction, Instruction1::Operand>::Either getRawElement();

    final string getDumpId() { none() }
  }

  abstract class TranslatedInstruction extends TranslatedElement {
    Instruction1::Instruction instr;

    abstract EitherInstructionTranslatedElementTagPair getEntry();

    final override Either<Instruction1::Instruction, Instruction1::Operand>::Either getRawElement() {
      result.asLeft() = instr
    }
  }

  private class TranslatedComparisonInstruction extends TranslatedInstruction {
    ConditionKind kind;
    Instruction1::CJumpInstruction cjump;

    TranslatedComparisonInstruction() {
      this = TTranslatedComparisonInstruction(instr, cjump, kind)
    }

    final override Instruction1::Function getEnclosingFunction() {
      result = cjump.getEnclosingFunction()
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction1::Instruction i, SuccessorType succType
    ) {
      i = instr and
      succType instanceof DirectSuccessor and
      result.asRight().getTranslatedElement() = this and
      result.asRight().getInstructionTag() = ZeroTag()
    }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      tag = ZeroTag() and
      succType instanceof DirectSuccessor and
      result.asRight().getTranslatedElement() = this and
      result.asRight().getInstructionTag() = CmpDefTag(kind)
      or
      tag = CmpDefTag(kind) and
      result.asLeft() = instr.getSuccessor(succType)
    }

    override predicate producesResult() { none() }

    override predicate hasTempVariable(TempVariableTag tag) { tag = ZeroVarTag() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, EitherOperandTagOrOperandTag operandTag
    ) {
      tag = CmpDefTag(kind) and
      (
        operandTag.asLeft() instanceof Instruction1::LeftTag and
        result.asLeft() = instr.getResultVariable()
        or
        operandTag.asLeft() instanceof Instruction1::RightTag and
        result.asRight().asLeft().getTranslatedElement() = this and
        result.asRight().asLeft().getVariableTag() = ZeroVarTag()
      )
    }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      tag = CmpDefTag(kind) and
      opcode instanceof Sub and
      v.asSome().asLeft() = cjump.getConditionOperand().getVariable()
      or
      tag = ZeroTag() and
      opcode instanceof Const and
      v.asSome().asRight().asLeft().getTranslatedElement() = this and
      v.asSome().asRight().asLeft().getVariableTag() = ZeroVarTag()
    }

    override int getConstantValue(InstructionTag tag) {
      tag = ZeroTag() and
      result = 0
    }

    override predicate hasJumpCondition(InstructionTag tag, ConditionKind k) {
      kind = k and
      tag = CmpDefTag(kind)
    }

    override string toString() { result = "Flag writing for " + instr.toString() }

    override EitherInstructionTranslatedElementTagPair getEntry() { result.asLeft() = instr }
  }

  private predicate parameterHasIndex(Instruction1::Variable v, Instruction1::Function f, int index) {
    v =
      rank[index + 1](Instruction1::LocalVariable cand |
        cand.getEnclosingFunction() = f and
        isReadBeforeInitialization(cand, f)
      |
        cand order by cand.toString() // TODO: Use the right argument ordering. This depends on the calling conventions.
      )
  }

  private Instruction1::Variable getFirstParameter(Instruction1::Function f) {
    parameterHasIndex(result, f, 0)
  }

  private Instruction1::FunEntryInstruction getFunctionEntry(Instruction1::Function f) {
    result.getEnclosingFunction() = f
  }

  private class TranslatedInitializeParameters extends TranslatedInstruction,
    TTranslatedInitializeParameters
  {
    Instruction1::Function func;

    TranslatedInitializeParameters() { this = TTranslatedInitializeParameters(func) }

    final override Instruction1::Function getEnclosingFunction() { result = func }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction1::Instruction i, SuccessorType succType
    ) {
      i = getFunctionEntry(func) and
      succType instanceof DirectSuccessor and
      result.asRight().getTranslatedElement() = this and
      result.asRight().getInstructionTag() = InitializeParameterTag(getFirstParameter(func))
    }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      succType instanceof DirectSuccessor and
      exists(Instruction1::Variable v, int index |
        tag = InitializeParameterTag(v) and
        parameterHasIndex(v, func, index)
      |
        exists(Instruction1::Variable u |
          parameterHasIndex(u, func, index + 1) and
          result.asRight().getTranslatedElement() = this and
          result.asRight().getInstructionTag() = InitializeParameterTag(u)
        )
        or
        not parameterHasIndex(_, func, index + 1) and
        result.asLeft() = getFunctionEntry(func).getSuccessor(succType)
      )
    }

    override predicate producesResult() { none() }

    override predicate hasTempVariable(TempVariableTag tag) { none() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, EitherOperandTagOrOperandTag operandTag
    ) {
      none()
    }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      opcode instanceof Init and
      exists(Instruction1::Variable var |
        isReadBeforeInitialization(var, func) and
        tag = InitializeParameterTag(var) and
        v.asSome().asLeft() = var
      )
    }

    override string toString() { result = "Initialize parameters in " + func.toString() }

    override EitherInstructionTranslatedElementTagPair getEntry() { none() }
  }
}

module Instruction2 = Transform<Instruction1>::Make<InstructionInput>;
