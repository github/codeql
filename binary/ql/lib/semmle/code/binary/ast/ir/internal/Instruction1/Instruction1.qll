private import semmle.code.binary.ast.ir.internal.InstructionSig
private import semmle.code.binary.ast.ir.internal.InstructionTag
private import semmle.code.binary.ast.Location
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.Opcode
private import codeql.util.Option
private import codeql.util.Either
private import codeql.util.Unit
private import semmle.code.binary.ast.ir.internal.TransformInstruction.TransformInstruction
private import semmle.code.binary.ast.ir.internal.Instruction0.Instruction0

private signature module ControlFlowReachableInputSig {
  class FlowState;

  predicate isSource(Instruction0::Instruction i, FlowState state);

  default predicate isBarrier(Instruction0::Instruction i, FlowState state) { none() }

  default predicate isBarrierOut(Instruction0::Instruction i, FlowState state) { none() }

  default predicate isBarrierIn(Instruction0::Instruction i, FlowState state) { none() }

  predicate isSink(Instruction0::Instruction i, FlowState state);
}

private module ControlFlowReachable<ControlFlowReachableInputSig Input> {
  private import Input

  module Make {
    pragma[nomagic]
    private predicate inBarrier(Instruction0::Instruction i, FlowState state) {
      isBarrierIn(i, state) and
      isSource(i, state)
    }

    pragma[nomagic]
    private predicate outBarrier(Instruction0::Instruction i, FlowState state) {
      isBarrierOut(i, state) and
      isSink(i, state)
    }

    pragma[nomagic]
    private predicate isFullBarrier(Instruction0::Instruction i, FlowState state) {
      isBarrier(i, state)
      or
      isBarrierIn(i, state) and
      not isSource(i, state)
      or
      isBarrierOut(i, state) and
      not isSink(i, state)
    }

    pragma[nomagic]
    private predicate sourceInstruction(Instruction0::Instruction i, FlowState state) {
      isSource(i, state) and
      not isFullBarrier(i, state)
    }

    private predicate sinkInstruction(Instruction0::Instruction i, FlowState state) {
      isSink(i, state) and
      not isFullBarrier(i, state)
    }

    bindingset[i1, i2, state]
    pragma[inline_late]
    private predicate stepFilter(
      Instruction0::Instruction i1, Instruction0::Instruction i2, FlowState state
    ) {
      not isFullBarrier(i1, state) and
      not isFullBarrier(i2, state) and
      not outBarrier(i1, state) and
      not inBarrier(i2, state)
    }

    pragma[nomagic]
    private predicate rev(Instruction0::Instruction i, FlowState state) {
      sinkInstruction(i, state)
      or
      exists(Instruction0::Instruction i1 |
        rev(i1, state) and
        i.getASuccessor() = i1 and
        stepFilter(i, i1, state)
      )
    }

    pragma[nomagic]
    private predicate fwd(Instruction0::Instruction i, FlowState state) {
      rev(i, pragma[only_bind_into](state)) and
      (
        sourceInstruction(i, state)
        or
        exists(Instruction0::Instruction i0 |
          fwd(i0, pragma[only_bind_into](state)) and
          i0.getASuccessor() = i and
          stepFilter(i0, i, state)
        )
      )
    }

    private newtype TNode = MkNode(Instruction0::Instruction i, FlowState state) { fwd(i, state) }

    private class Node extends TNode {
      Instruction0::Instruction getInstruction() { this = MkNode(result, _) }

      FlowState getState() { this = MkNode(_, result) }

      string toString() { result = this.getInstruction().toString() }

      Node getASuccessor() {
        exists(Instruction0::Instruction i, FlowState state |
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

    predicate flowsTo(Instruction0::Instruction source, Instruction0::Instruction sink) {
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
 */
private module InstructionInput implements Transform<Instruction0>::TransformInputSig {
  // ------------------------------------------------
  class EitherInstructionTranslatedElementTagPair =
    Either<Instruction0::Instruction, TranslatedElementTagPair>::Either;

  class EitherVariableOrTranslatedElementVariablePair =
    Either<Instruction0::Variable, TranslatedElementVariablePair>::Either;

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

  private predicate modifiesFlag(Instruction0::Instruction i) {
    i instanceof Instruction0::SubInstruction
    or
    i instanceof Instruction0::AddInstruction
    or
    i instanceof Instruction0::ShlInstruction
    or
    i instanceof Instruction0::ShrInstruction
    or
    i instanceof Instruction0::RolInstruction
    or
    i instanceof Instruction0::RorInstruction
    or
    i instanceof Instruction0::OrInstruction
    or
    i instanceof Instruction0::AndInstruction
    or
    i instanceof Instruction0::XorInstruction
  }

  private module ModifiesFlagToCJumpInput implements ControlFlowReachableInputSig {
    class FlowState = Unit;

    predicate isSource(Instruction0::Instruction i, FlowState state) {
      modifiesFlag(i) and exists(state)
    }

    predicate isSink(Instruction0::Instruction i, FlowState state) {
      i instanceof Instruction0::CJumpInstruction and exists(state)
    }

    predicate isBarrierIn(Instruction0::Instruction i, FlowState state) { isSource(i, state) }
  }

  private module ModifiesFlagToCJump = ControlFlowReachable<ModifiesFlagToCJumpInput>::Make;

  private predicate noWriteToFlagSource(
    Instruction0::Instruction i, Instruction0::CJumpInstruction cjump, Instruction0::Variable v
  ) {
    ModifiesFlagToCJump::flowsTo(i, cjump) and
    v = cjump.getConditionOperand().getVariable()
  }

  private module NoWriteToFlagInput implements ControlFlowReachableInputSig {
    class FlowState = Instruction0::Variable;

    predicate isSource(Instruction0::Instruction i, FlowState state) {
      noWriteToFlagSource(i, _, state)
    }

    predicate isSink(Instruction0::Instruction i, FlowState state) {
      i.(Instruction0::CJumpInstruction).getConditionOperand().getVariable() = state
    }

    predicate isBarrierIn(Instruction0::Instruction i, FlowState state) { isSource(i, state) }

    predicate isBarrier(Instruction0::Instruction i, FlowState state) {
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
    Instruction0::Instruction i, Instruction0::CJumpInstruction cjump, ConditionKind kind
  ) {
    // There is control-flow from i to cjump without a write to the
    // variable that is used as a condition to cjump
    NoWriteToFlag::flowsTo(i, cjump) and
    cjump.getKind() = kind
  }

  // ------------------------------------------------
  private newtype TTranslatedElement =
    TTranslatedComparisonInstruction(
      Instruction0::Instruction i, Instruction0::CJumpInstruction cjump, ConditionKind kind
    ) {
      controlFlowsToCmp(i, cjump, kind)
    }

  abstract class TranslatedElement extends TTranslatedElement {
    abstract EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    );

    EitherInstructionTranslatedElementTagPair getReferencedInstruction(InstructionTag tag) { none() }

    abstract EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction0::Instruction i, SuccessorType succType
    );

    abstract predicate producesResult();

    Instruction0::Function getStaticTarget(InstructionTag tag) { none() }

    int getConstantValue(InstructionTag tag) { none() }

    predicate hasJumpCondition(InstructionTag tag, ConditionKind kind) { none() }

    predicate hasTempVariable(VariableTag tag) { none() }

    abstract EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, OperandTag operandTag
    );

    abstract predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    );

    abstract string toString();

    abstract Either<Instruction0::Instruction, Instruction0::Operand>::Either getRawElement();

    final string getDumpId() { none() }
  }

  abstract class TranslatedInstruction extends TranslatedElement {
    Instruction0::Instruction instr;

    abstract EitherInstructionTranslatedElementTagPair getEntry();

    final override Either<Instruction0::Instruction, Instruction0::Operand>::Either getRawElement() {
      result.asLeft() = instr
    }
  }

  private class TranslatedComparisonInstruction extends TranslatedInstruction {
    ConditionKind kind;
    Instruction0::CJumpInstruction cjump;

    TranslatedComparisonInstruction() {
      this = TTranslatedComparisonInstruction(instr, cjump, kind)
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction0::Instruction i, SuccessorType succType
    ) {
      i = instr and
      succType instanceof DirectSuccessor and
      result.asRight().getTranslatedElement() = this and
      result.asRight().getInstructionTag() = Stage1ZeroTag()
    }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      tag = Stage1ZeroTag() and
      succType instanceof DirectSuccessor and
      result.asRight().getTranslatedElement() = this and
      result.asRight().getInstructionTag() = Stage1CmpDefTag(kind)
      or
      tag = Stage1CmpDefTag(kind) and
      result.asLeft() = instr.getSuccessor(succType)
    }

    override predicate producesResult() { none() }

    override predicate hasTempVariable(VariableTag tag) { tag = ZeroVarTag() }

    override EitherVariableOrTranslatedElementVariablePair getVariableOperand(
      InstructionTag tag, OperandTag operandTag
    ) {
      tag = Stage1CmpDefTag(kind) and
      (
        operandTag = LeftTag() and
        result.asLeft() = instr.getResultVariable()
        or
        operandTag = RightTag() and
        result.asRight().getTranslatedElement() = this and
        result.asRight().getVariableTag() = ZeroVarTag()
      )
    }

    override predicate hasInstruction(
      Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
    ) {
      tag = Stage1CmpDefTag(kind) and
      opcode instanceof Sub and
      v.asSome().asLeft() = cjump.getConditionOperand().getVariable()
      or
      tag = Stage1ZeroTag() and
      opcode instanceof Const and
      v.asSome().asRight().getTranslatedElement() = this and
      v.asSome().asRight().getVariableTag() = ZeroVarTag()
    }

    override int getConstantValue(InstructionTag tag) {
      tag = Stage1ZeroTag() and
      result = 0
    }

    override predicate hasJumpCondition(InstructionTag tag, ConditionKind k) {
      kind = k and
      tag = Stage1CmpDefTag(kind)
    }

    override string toString() { result = "Flag writing for " + instr.toString() }

    override EitherInstructionTranslatedElementTagPair getEntry() { result.asLeft() = instr }
  }

  class TranslatedOperand extends TranslatedElement {
    TranslatedOperand() { none() }

    override EitherInstructionTranslatedElementTagPair getSuccessor(
      InstructionTag tag, SuccessorType succType
    ) {
      none()
    }

    override EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
      Instruction0::Instruction i, SuccessorType succType
    ) {
      none()
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

    override string toString() { none() }

    OptionEitherInstructionTranslatedElementTagPair getEntry() { none() }

    override Either<Instruction0::Instruction, Instruction0::Operand>::Either getRawElement() {
      none()
    }
  }
}

module Instruction1 = Transform<Instruction0>::Make<InstructionInput>;
