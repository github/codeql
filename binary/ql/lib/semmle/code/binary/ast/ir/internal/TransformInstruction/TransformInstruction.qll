private import semmle.code.binary.ast.ir.internal.InstructionSig
private import semmle.code.binary.ast.ir.internal.Tags
private import semmle.code.binary.ast.Location
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import codeql.util.Option
private import codeql.util.Either
private import codeql.controlflow.BasicBlock as BB

private class Opcode = Opcode::Opcode;

module Transform<InstructionSig Input> {
  signature module TransformInputSig {
    default EitherVariableOrTranslatedElementVariablePair getResultVariable(Input::Instruction instr) {
      none()
    }

    default EitherVariableOrTranslatedElementVariablePair getOperandVariable(Input::Operand op) {
      none()
    }

    default predicate hasAdditionalOperand(
      Input::Instruction instr, EitherOperandTagOrOperandTag operandTag,
      EitherVariableOrTranslatedElementVariablePair v
    ) {
      none()
    }

    default predicate variableHasOrdering(
      EitherVariableOrTranslatedElementVariablePair v, int ordering
    ) {
      none()
    }

    bindingset[oldOrdering]
    default predicate variableHasOrdering(
      EitherVariableOrTranslatedElementVariablePair v, int ordering, int oldOrdering
    ) {
      none()
    }

    default predicate isRemovedInstruction(Input::Instruction instr) { none() }

    class InstructionTag {
      string toString();
    }

    class OperandTag {
      int getIndex();

      EitherOperandTagOrOperandTag getSuccessorTag();

      EitherOperandTagOrOperandTag getPredecessorTag();

      string toString();
    }

    class TempVariableTag {
      string toString();
    }

    class LocalVariableTag {
      string toString();

      predicate isStackAllocated();
    }

    class TranslatedElement {
      EitherInstructionTranslatedElementTagPair getSuccessor(
        InstructionTag tag, SuccessorType succType
      );

      EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
        Input::Instruction i, SuccessorType succType
      );

      EitherInstructionTranslatedElementTagPair getReferencedInstruction(InstructionTag tag);

      Input::Function getEnclosingFunction();

      predicate producesResult();

      int getConstantValue(InstructionTag tag);

      predicate hasTempVariable(TempVariableTag tag);

      predicate hasLocalVariable(LocalVariableTag tag);

      EitherVariableOrTranslatedElementVariablePair getVariableOperand(
        InstructionTag tag, EitherOperandTagOrOperandTag operandTag
      );

      Either<Input::Instruction, Input::Operand>::Either getRawElement();

      predicate hasInstruction(
        Opcode opcode, InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
      );

      Input::Function getStaticTarget(InstructionTag tag);

      predicate hasJumpCondition(InstructionTag tag, Opcode::ConditionKind kind);

      string toString();

      string getDumpId();
    }

    // This one only exists because we can't use `Either<Input::Instruction, TranslatedElementTagPair>::Either` in getSuccessor because of https://github.com/github/codeql-core/issues/5091.
    class EitherInstructionTranslatedElementTagPair {
      Input::Instruction asLeft();

      TranslatedElementTagPair asRight();
    }

    // This one only exists because we can't use `Either<Input::Variable, TranslatedElementVariablePair>::Either` in getVariableOperand because of https://github.com/github/codeql-core/issues/5091.
    class EitherVariableOrTranslatedElementVariablePair {
      Input::Variable asLeft();

      EitherTranslatedElementVariablePairOrFunctionLocalVariablePair asRight();
    }

    // This one only exists because we can't use `Option<Either<Input::Variable, TranslatedElementVariablePair>::Either>::Option` in hasInstruction because of https://github.com/github/codeql-core/issues/5091.
    class OptionEitherVariableOrTranslatedElementPair {
      predicate isNone();

      EitherVariableOrTranslatedElementVariablePair asSome();
    }

    class TranslatedElementTagPair {
      string toString();

      TranslatedElement getTranslatedElement();

      InstructionTag getInstructionTag();
    }

    class TranslatedElementVariablePair {
      string toString();

      TranslatedElement getTranslatedElement();

      TempVariableTag getVariableTag();
    }

    class FunctionLocalVariablePair {
      Input::Function getFunction();

      LocalVariableTag getLocalVariableTag();
    }

    class EitherTranslatedElementVariablePairOrFunctionLocalVariablePair {
      TranslatedElementVariablePair asLeft();

      FunctionLocalVariablePair asRight();
    }

    class EitherOperandTagOrOperandTag {
      Input::OperandTag asLeft();

      OperandTag asRight();
    }

    class TranslatedInstruction extends TranslatedElement {
      EitherInstructionTranslatedElementTagPair getEntry();
    }
  }

  module Make<TransformInputSig TransformInput> implements InstructionSig {
    class Function instanceof Input::Function {
      string getName() { result = super.getName() }

      string toString() { result = super.getName() }

      FunEntryInstruction getEntryInstruction() {
        result = TOldInstruction(super.getEntryInstruction())
      }

      BasicBlock getEntryBlock() { result = this.getEntryInstruction().getBasicBlock() }

      Location getLocation() { result = this.getEntryInstruction().getLocation() }

      predicate isProgramEntryPoint() { super.isProgramEntryPoint() }

      Type getDeclaringType() { result = super.getDeclaringType() }

      predicate isPublic() { super.isPublic() }
    }

    class Type instanceof Input::Type {
      Function getAFunction() { result = super.getAFunction() }

      string toString() { result = super.toString() }

      string getFullName() { result = super.getFullName() }

      string getNamespace() { result = super.getNamespace() }

      string getName() { result = super.getName() }

      Location getLocation() { result = super.getLocation() }
    }

    private newtype TVariable =
      TOldVariable(Input::Variable v) or
      TNewTempVariable(TranslatedElement te, TransformInput::TempVariableTag tag) {
        hasTempVariable(te, tag)
      } or
      TNewLocalVariable(Function f, TransformInput::LocalVariableTag tag) {
        exists(TranslatedElement te |
          te.getEnclosingFunction() = f and
          te.hasLocalVariable(tag)
        )
      }

    private Variable getNewVariable(Input::Variable v) { v = result.asOldVariable() }

    private Variable getTempVariable(TranslatedElement te, TransformInput::TempVariableTag tag) {
      result.isNewTempVariable(te, tag)
    }

    private Variable getLocalVariable(Function tf, TransformInput::LocalVariableTag tag) {
      result.isNewLocalVariable(tf, tag)
    }

    class Variable extends TVariable {
      Input::Variable asOldVariable() { this = TOldVariable(result) }

      predicate isNewTempVariable(TranslatedElement te, TransformInput::TempVariableTag tag) {
        this = TNewTempVariable(te, tag)
      }

      predicate isNewLocalVariable(Function tf, TransformInput::LocalVariableTag tag) {
        this = TNewLocalVariable(tf, tag)
      }

      final string toString() {
        result = this.asOldVariable().toString()
        or
        exists(TransformInput::TempVariableTag tag, TranslatedElement te |
          this.isNewTempVariable(te, tag) and
          result = te.getDumpId() + "." + tag.toString()
        )
        or
        exists(TransformInput::LocalVariableTag tag |
          this.isNewLocalVariable(_, tag) and
          result = tag.toString()
        )
      }

      Location getLocation() { result instanceof EmptyLocation }

      Operand getAnAccess() { result.getVariable() = this }
    }

    class StackPointer extends LocalVariable {
      StackPointer() { this.asOldVariable() instanceof Input::StackPointer }
    }

    class FramePointer extends LocalVariable {
      FramePointer() { this.asOldVariable() instanceof Input::FramePointer }
    }

    class TempVariable extends Variable {
      TempVariable() {
        this.asOldVariable() instanceof Input::TempVariable
        or
        this.isNewTempVariable(_, _)
      }
    }

    class LocalVariable extends Variable {
      LocalVariable() {
        this.asOldVariable() instanceof Input::LocalVariable
        or
        this.isNewLocalVariable(_, _)
      }

      Function getEnclosingFunction() {
        result = this.asOldVariable().(Input::LocalVariable).getEnclosingFunction()
        or
        exists(Function f |
          this.isNewLocalVariable(f, _) and
          result = f
        )
      }

      predicate isStackAllocated() {
        this.asOldVariable().(Input::LocalVariable).isStackAllocated()
        or
        exists(TransformInput::LocalVariableTag tag |
          this.isNewLocalVariable(_, tag) and
          tag.isStackAllocated()
        )
      }
    }

    predicate variableHasOrdering(Variable v, int ordering) {
      exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e | v = getVariable(e) |
        TransformInput::variableHasOrdering(e, ordering) and
        not Input::variableHasOrdering(v.asOldVariable(), _)
        or
        exists(int oldOrdering |
          Input::variableHasOrdering(v.asOldVariable(), oldOrdering) and
          TransformInput::variableHasOrdering(e, ordering, oldOrdering)
        )
      )
      or
      not exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e |
        TransformInput::variableHasOrdering(e, _) and
        v = getVariable(e)
      ) and
      Input::variableHasOrdering(v.asOldVariable(), ordering)
    }

    private module MInstructionTag = Either<Input::InstructionTag, TransformInput::InstructionTag>;

    class InstructionTag = MInstructionTag::Either;

    class TempVariableTag = Either<Input::TempVariableTag, TransformInput::TempVariableTag>::Either;

    final private class FinalOperandTag = TransformInput::EitherOperandTagOrOperandTag;

    class OperandTag extends FinalOperandTag {
      final int getIndex() {
        result = this.asLeft().getIndex()
        or
        result = this.asRight().getIndex()
      }

      final OperandTag getSuccessorTag() {
        result.asLeft() = this.asLeft().getSuccessorTag()
        or
        result = this.asRight().getSuccessorTag()
      }

      final OperandTag getPredecessorTag() { this = result.getSuccessorTag() }

      string toString() {
        result = this.asLeft().toString()
        or
        result = this.asRight().toString()
      }
    }

    class LeftTag extends OperandTag {
      LeftTag() { this.asLeft() instanceof Input::LeftTag }
    }

    class RightTag extends OperandTag {
      RightTag() { this.asLeft() instanceof Input::RightTag }
    }

    class UnaryTag extends OperandTag {
      UnaryTag() { this.asLeft() instanceof Input::UnaryTag }
    }

    class StoreValueTag extends OperandTag {
      StoreValueTag() { this.asLeft() instanceof Input::StoreValueTag }
    }

    class LoadAddressTag extends OperandTag {
      LoadAddressTag() { this.asLeft() instanceof Input::LoadAddressTag }
    }

    class StoreAddressTag extends OperandTag {
      StoreAddressTag() { this.asLeft() instanceof Input::StoreAddressTag }
    }

    class CallTargetTag extends OperandTag {
      CallTargetTag() { this.asLeft() instanceof Input::CallTargetTag }
    }

    class CondTag extends OperandTag {
      CondTag() { this.asLeft() instanceof Input::CondTag }
    }

    class CondJumpTargetTag extends OperandTag {
      CondJumpTargetTag() { this.asLeft() instanceof Input::CondJumpTargetTag }
    }

    class JumpTargetTag extends OperandTag {
      JumpTargetTag() { this.asLeft() instanceof Input::JumpTargetTag }
    }

    final private class FinalTranslatedElement = TransformInput::TranslatedElement;

    private class TranslatedElement extends FinalTranslatedElement {
      final predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
        exists(TransformInput::OptionEitherVariableOrTranslatedElementPair o |
          super.hasInstruction(opcode, tag.asRight(), o)
        |
          o.isNone() and
          v.isNone()
          or
          v.asSome() = getVariable(o.asSome())
        )
      }

      final Instruction getReferencedInstruction(InstructionTag tag) {
        exists(TransformInput::EitherInstructionTranslatedElementTagPair e |
          e = super.getReferencedInstruction(tag.asRight())
        |
          result = getNewInstruction(e.asLeft())
          or
          exists(TransformInput::TranslatedElementTagPair p |
            p = e.asRight() and
            result =
              p.getTranslatedElement()
                  .(TranslatedElement)
                  .getInstruction(MInstructionTag::right(p.getInstructionTag()))
          )
        )
      }

      final Instruction getInstruction(InstructionTag tag) { result = MkInstruction(this, tag) }

      final Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
        exists(TransformInput::EitherInstructionTranslatedElementTagPair e |
          e = super.getSuccessor(tag.asRight(), succType)
        |
          result = getNewInstruction(e.asLeft())
          or
          exists(TransformInput::TranslatedElementTagPair p |
            p = e.asRight() and
            result =
              p.getTranslatedElement()
                  .(TranslatedElement)
                  .getInstruction(MInstructionTag::right(p.getInstructionTag()))
          )
        )
      }

      final Instruction getInstructionSuccessor(Input::Instruction i, SuccessorType succType) {
        exists(TransformInput::EitherInstructionTranslatedElementTagPair e |
          e = super.getInstructionSuccessor(i, succType)
        |
          result = getNewInstruction(e.asLeft())
          or
          exists(TransformInput::TranslatedElementTagPair p |
            p = e.asRight() and
            result =
              p.getTranslatedElement()
                  .(TranslatedElement)
                  .getInstruction(MInstructionTag::right(p.getInstructionTag()))
          )
        )
      }

      final Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) {
        exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e |
          e = super.getVariableOperand(tag.asRight(), operandTag) and
          result = getVariable(e)
        )
      }
    }

    private class TranslatedInstruction extends TranslatedElement instanceof TransformInput::TranslatedInstruction
    {
      final Instruction getEntry() {
        exists(TransformInput::EitherInstructionTranslatedElementTagPair e | e = super.getEntry() |
          result = getNewInstruction(e.asLeft())
          or
          exists(TransformInput::TranslatedElementTagPair p |
            p = e.asRight() and
            result =
              p.getTranslatedElement()
                  .(TranslatedElement)
                  .getInstruction(MInstructionTag::right(p.getInstructionTag()))
          )
        )
      }
    }

    private predicate hasInstruction(TranslatedElement te, InstructionTag tag) {
      te.hasInstruction(_, tag, _)
    }

    private predicate hasTempVariable(TranslatedElement te, TransformInput::TempVariableTag tag) {
      te.hasTempVariable(tag)
    }

    private newtype TInstruction =
      TOldInstruction(Input::Instruction i) { not TransformInput::isRemovedInstruction(i) } or
      MkInstruction(TranslatedElement te, InstructionTag tag) { hasInstruction(te, tag) }

    private TranslatedInstruction getTranslatedInstruction(Input::Instruction i) {
      result.getRawElement().asLeft() = i and
      result.producesResult()
    }

    private Instruction getNewInstruction(Input::Instruction i) {
      result = TOldInstruction(i)
      or
      result = getTranslatedInstruction(i).getEntry()
    }

    private Operand getNewOperand(Input::Operand o) { result = TOldOperand(o) }

    private Operand getAdditionalOperand(Input::Instruction instr, OperandTag operandTag) {
      result = MkAdditionalOperand(instr, operandTag)
    }

    class Instruction extends TInstruction {
      private string getResultString() {
        result = this.getResultVariable().toString() + " = "
        or
        not exists(this.getResultVariable()) and
        result = ""
      }

      private string getOperandString() {
        result =
          " " +
            strictconcat(OperandTag op, string s |
              s = this.getOperand(op).getVariable().toString()
            |
              s, " " order by op.getIndex()
            )
        or
        not exists(this.getAnOperand()) and
        result = ""
      }

      string getImmediateValue() { none() }

      final private string getImmediateValue1() {
        result = "[" + this.getImmediateValue() + "]"
        or
        not exists(this.getImmediateValue()) and
        result = ""
      }

      final string toString() {
        result =
          this.getResultString() + this.getOpcode().toString() + this.getImmediateValue1() +
            this.getOperandString()
      }

      Opcode getOpcode() { none() }

      Operand getOperand(OperandTag operandTag) { none() }

      final Operand getAnOperand() { result = this.getOperand(_) }

      Instruction getSuccessor(SuccessorType succType) { none() }

      final Instruction getASuccessor() { result = this.getSuccessor(_) }

      final Instruction getAPredecessor() { this = result.getASuccessor() }

      Location getLocation() { none() }

      Variable getResultVariable() { none() }

      Function getEnclosingFunction() { none() }

      BasicBlock getBasicBlock() { result.getANode().asInstruction() = this }

      Operand getFirstOperand() {
        exists(OperandTag operandTag |
          result = this.getOperand(operandTag) and
          not exists(this.getOperand(operandTag.getPredecessorTag()))
        )
      }

      InstructionTag getInstructionTag() { none() }
    }

    class RetInstruction extends Instruction {
      RetInstruction() { this.getOpcode() instanceof Opcode::Ret }
    }

    class RetValueInstruction extends Instruction {
      RetValueInstruction() { this.getOpcode() instanceof Opcode::RetValue }

      UnaryOperand getReturnValueOperand() { result = this.getAnOperand() }
    }

    class InitInstruction extends Instruction {
      InitInstruction() { this.getOpcode() instanceof Opcode::Init }
    }

    class CJumpInstruction extends Instruction {
      CJumpInstruction() { this.getOpcode() instanceof Opcode::CJump }

      Opcode::ConditionKind getKind() {
        exists(Input::CJumpInstruction cjump |
          this = TOldInstruction(cjump) and
          result = cjump.getKind()
        )
        or
        exists(TranslatedElement te, InstructionTag tag |
          this = MkInstruction(te, tag) and
          te.hasJumpCondition(tag.asRight(), result)
        )
      }

      override string getImmediateValue() { result = Opcode::stringOfConditionKind(this.getKind()) }

      ConditionOperand getConditionOperand() { result = this.getAnOperand() }

      ConditionJumpTargetOperand getJumpTargetOperand() { result = this.getAnOperand() }
    }

    class JumpInstruction extends Instruction {
      JumpInstruction() { this.getOpcode() instanceof Opcode::Jump }

      JumpTargetOperand getJumpTargetOperand() { result = this.getAnOperand() }
    }

    class FunEntryInstruction extends Instruction {
      FunEntryInstruction() { this.getOpcode() instanceof Opcode::FunEntry }
    }

    class BinaryInstruction extends Instruction {
      BinaryInstruction() { this.getOpcode() instanceof Opcode::BinaryOpcode }

      LeftOperand getLeftOperand() { result = this.getAnOperand() }

      RightOperand getRightOperand() { result = this.getAnOperand() }
    }

    class SubInstruction extends BinaryInstruction {
      SubInstruction() { this.getOpcode() instanceof Opcode::Sub }
    }

    class AddInstruction extends BinaryInstruction {
      AddInstruction() { this.getOpcode() instanceof Opcode::Add }
    }

    class ShlInstruction extends BinaryInstruction {
      ShlInstruction() { this.getOpcode() instanceof Opcode::Shl }
    }

    class ShrInstruction extends BinaryInstruction {
      ShrInstruction() { this.getOpcode() instanceof Opcode::Shr }
    }

    class RolInstruction extends BinaryInstruction {
      RolInstruction() { this.getOpcode() instanceof Opcode::Rol }
    }

    class RorInstruction extends BinaryInstruction {
      RorInstruction() { this.getOpcode() instanceof Opcode::Ror }
    }

    class AndInstruction extends BinaryInstruction {
      AndInstruction() { this.getOpcode() instanceof Opcode::And }
    }

    class OrInstruction extends BinaryInstruction {
      OrInstruction() { this.getOpcode() instanceof Opcode::Or }
    }

    class XorInstruction extends BinaryInstruction {
      XorInstruction() { this.getOpcode() instanceof Opcode::Xor }
    }

    class CopyInstruction extends Instruction {
      CopyInstruction() { this.getOpcode() instanceof Opcode::Copy }

      UnaryOperand getOperand() { result = this.getAnOperand() }
    }

    class CallInstruction extends Instruction {
      CallInstruction() { this.getOpcode() instanceof Opcode::Call }

      Function getStaticTarget() {
        exists(Input::CallInstruction call |
          this = TOldInstruction(call) and
          result = call.getStaticTarget()
        )
        or
        exists(TranslatedElement te, InstructionTag tag |
          this = MkInstruction(te, tag) and
          result = te.getStaticTarget(tag.asRight())
        )
      }

      CallTargetOperand getTargetOperand() { result = this.getAnOperand() }

      override string getImmediateValue() { result = this.getStaticTarget().getName() }
    }

    class LoadInstruction extends Instruction {
      LoadInstruction() { this.getOpcode() instanceof Opcode::Load }

      LoadAddressOperand getOperand() { result = this.getAnOperand() }
    }

    class StoreInstruction extends Instruction {
      StoreInstruction() { this.getOpcode() instanceof Opcode::Store }

      StoreValueOperand getValueOperand() { result = this.getAnOperand() }

      StoreAddressOperand getAddressOperand() { result = this.getAnOperand() }
    }

    class ConstInstruction extends Instruction {
      ConstInstruction() { this.getOpcode() instanceof Opcode::Const }

      int getValue() {
        exists(Input::ConstInstruction const |
          this = TOldInstruction(const) and
          result = const.getValue()
        )
        or
        exists(TranslatedElement te, InstructionTag tag |
          this = MkInstruction(te, tag) and
          result = te.getConstantValue(tag.asRight())
        )
      }

      string getStringValue() {
        exists(Input::ConstInstruction const |
          this = TOldInstruction(const) and
          result = const.getStringValue()
        )
      }

      override string getImmediateValue() { result = this.getValue().toString() }
    }

    class ExternalRefInstruction extends Instruction {
      ExternalRefInstruction() { this.getOpcode() instanceof Opcode::ExternalRef }

      string getExternalName() {
        exists(Input::ExternalRefInstruction extRef |
          this = TOldInstruction(extRef) and
          result = extRef.getExternalName()
        )
      }
    }

    class FieldAddressInstruction extends Instruction {
      FieldAddressInstruction() { this.getOpcode() instanceof Opcode::FieldAddress }

      UnaryOperand getBaseOperand() { result = this.getAnOperand() }

      string getFieldName() {
        exists(Input::FieldAddressInstruction fieldAddr |
          this = TOldInstruction(fieldAddr) and
          result = fieldAddr.getFieldName()
        )
      }

      final override string getImmediateValue() { result = this.getFieldName() }
    }

    private class NewInstruction extends MkInstruction, Instruction {
      Opcode opcode;
      TranslatedElement te;
      InstructionTag tag;

      NewInstruction() { this = MkInstruction(te, tag) and te.hasInstruction(opcode, tag, _) }

      override Opcode getOpcode() { te.hasInstruction(result, tag, _) }

      override string getImmediateValue() { none() }

      override Operand getOperand(OperandTag operandTag) { result = MkOperand(te, tag, operandTag) }

      override Instruction getSuccessor(SuccessorType succType) {
        result = te.getSuccessor(tag, succType)
      }

      override Location getLocation() { result instanceof EmptyLocation }

      override Variable getResultVariable() {
        exists(Option<Variable>::Option v |
          te.hasInstruction(_, tag, v) and
          result = v.asSome()
        )
      }

      override Function getEnclosingFunction() {
        result.getEntryInstruction() = this or
        result = this.getAPredecessor().getEnclosingFunction()
      }

      override InstructionTag getInstructionTag() { result = tag }
    }

    private Instruction getInstructionSuccessor(Input::Instruction old, SuccessorType succType) {
      result = any(TranslatedElement te).getInstructionSuccessor(old, succType)
    }

    private Input::Instruction getASuccessorIfRemoved(Input::Instruction i) {
      TransformInput::isRemovedInstruction(i) and
      result = i.getASuccessor()
    }

    private Input::Instruction getSuccessorFromNonRemoved(Input::Instruction i, SuccessorType t) {
      result = i.getSuccessor(t) and
      not TransformInput::isRemovedInstruction(i)
      or
      result = getASuccessorIfRemoved(getSuccessorFromNonRemoved(i, t))
    }

    private Input::Instruction getNonRemovedSuccessor(Input::Instruction i, SuccessorType t) {
      result = getSuccessorFromNonRemoved(i, t) and not TransformInput::isRemovedInstruction(result)
    }

    private Input::Instruction getSuccessorIfRemoved(Input::Instruction instr) {
      TransformInput::isRemovedInstruction(instr) and
      result = instr.getSuccessor(_)
    }

    private Input::Instruction getFirstNonRemoved(Input::Instruction instr) {
      result = getSuccessorIfRemoved*(instr) and not TransformInput::isRemovedInstruction(result)
    }

    private class OldInstruction extends TOldInstruction, Instruction {
      Input::Instruction old;

      OldInstruction() { this = TOldInstruction(old) }

      override Opcode getOpcode() { result = old.getOpcode() }

      override Operand getOperand(OperandTag operandTag) {
        result = getNewOperand(old.getOperand(operandTag.asLeft()))
        or
        result = getAdditionalOperand(old, operandTag)
      }

      override string getImmediateValue() { result = old.getImmediateValue() }

      private Input::Instruction getOldInstruction() { result = old }

      override Instruction getSuccessor(SuccessorType succType) {
        exists(Input::Instruction oldSucc |
          not exists(getInstructionSuccessor(old, _)) and
          oldSucc = getNonRemovedSuccessor(old, succType) and
          result = getNewInstruction(oldSucc)
        )
        or
        exists(Instruction i | i = getInstructionSuccessor(old, succType) |
          result = getNewInstruction(getFirstNonRemoved(i.(OldInstruction).getOldInstruction()))
          or
          not i instanceof OldInstruction and
          result = i
        )
      }

      override Location getLocation() { result = old.getLocation() }

      override Variable getResultVariable() {
        not exists(TransformInput::getResultVariable(old)) and
        result = getNewVariable(old.getResultVariable())
        or
        exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e |
          e = TransformInput::getResultVariable(old) and
          result = getVariable(e)
        )
      }

      override Function getEnclosingFunction() { result = old.getEnclosingFunction() }

      override InstructionTag getInstructionTag() { result.asLeft() = old.getInstructionTag() }
    }

    private Variable getVariable(TransformInput::EitherVariableOrTranslatedElementVariablePair e) {
      result.asOldVariable() = e.asLeft()
      or
      exists(TransformInput::EitherTranslatedElementVariablePairOrFunctionLocalVariablePair tevp |
        e.asRight() = tevp
      |
        exists(TransformInput::TranslatedElementVariablePair p |
          tevp.asLeft() = p and
          result = getTempVariable(p.getTranslatedElement(), p.getVariableTag())
        )
        or
        exists(TransformInput::FunctionLocalVariablePair p |
          tevp.asRight() = p and
          result = getLocalVariable(p.getFunction(), p.getLocalVariableTag())
        )
      )
    }

    private newtype TOperand =
      TOldOperand(Input::Operand op) {
        exists(Input::Instruction use |
          use = op.getUse() and
          not TransformInput::isRemovedInstruction(use)
        )
      } or
      MkOperand(TranslatedElement te, InstructionTag tag, OperandTag operandTag) {
        exists(te.getVariableOperand(tag, operandTag))
      } or
      MkAdditionalOperand(Input::Instruction instr, OperandTag operandTag) {
        TransformInput::hasAdditionalOperand(instr, operandTag, _)
      }

    class Operand extends TOperand {
      final string toString() {
        result = this.getVariable().toString() + " @ " + this.getUse().getOpcode().toString()
      }

      final Instruction getUse() { result.getAnOperand() = this }

      Variable getVariable() { none() }

      final Function getEnclosingFunction() { result = this.getUse().getEnclosingFunction() }

      Location getLocation() { result instanceof EmptyLocation }

      OperandTag getOperandTag() { none() }
    }

    abstract private class NewOperand extends Operand {
      OperandTag operandTag;

      override OperandTag getOperandTag() { result = operandTag }
    }

    private class NewOperand1 extends MkOperand, NewOperand {
      TranslatedElement te;
      InstructionTag tag;

      NewOperand1() { this = MkOperand(te, tag, operandTag) }

      override Variable getVariable() { result = te.getVariableOperand(tag, operandTag) }
    }

    private class NewOperand2 extends MkAdditionalOperand, NewOperand {
      Input::Instruction instr;

      NewOperand2() { this = MkAdditionalOperand(instr, operandTag) }

      override Variable getVariable() {
        exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e |
          TransformInput::hasAdditionalOperand(instr, operandTag, e) and
          result = getVariable(e)
        )
      }

      override OperandTag getOperandTag() { result = operandTag }
    }

    private class OldOperand extends TOldOperand, Operand {
      Input::Operand old;

      OldOperand() { this = TOldOperand(old) }

      override Variable getVariable() {
        not exists(TransformInput::getOperandVariable(old)) and
        result = getNewVariable(old.getVariable())
        or
        result = getVariable(TransformInput::getOperandVariable(old))
      }

      override OperandTag getOperandTag() { result.asLeft() = old.getOperandTag() }
    }

    class StoreValueOperand extends Operand {
      StoreValueOperand() { this.getOperandTag() instanceof StoreValueTag }
    }

    class StoreAddressOperand extends Operand {
      StoreAddressOperand() { this.getOperandTag() instanceof StoreAddressTag }
    }

    class LoadAddressOperand extends Operand {
      LoadAddressOperand() { this.getOperandTag() instanceof LoadAddressTag }
    }

    class UnaryOperand extends Operand {
      UnaryOperand() { this.getOperandTag() instanceof UnaryTag }
    }

    class ConditionOperand extends Operand {
      ConditionOperand() { this.getOperandTag() instanceof CondTag }
    }

    class ConditionJumpTargetOperand extends Operand {
      ConditionJumpTargetOperand() { this.getOperandTag() instanceof CondJumpTargetTag }
    }

    class JumpTargetOperand extends Operand {
      JumpTargetOperand() { this.getOperandTag() instanceof JumpTargetTag }
    }

    class LeftOperand extends Operand {
      LeftOperand() { this.getOperandTag() instanceof LeftTag }
    }

    class CallTargetOperand extends Operand {
      CallTargetOperand() { this.getOperandTag() instanceof CallTargetTag }
    }

    class RightOperand extends Operand {
      RightOperand() { this.getOperandTag() instanceof RightTag }
    }

    additional module BinaryCfg implements BB::CfgSig<Location> {
      private ControlFlowNode getASuccessor(ControlFlowNode n) { result = n.getSuccessor(_) }

      private ControlFlowNode getAPredecessor(ControlFlowNode n) { n = getASuccessor(result) }

      private predicate isJoin(ControlFlowNode n) { strictcount(getAPredecessor(n)) > 1 }

      private predicate isBranch(ControlFlowNode n) { strictcount(getASuccessor(n)) > 1 }

      private predicate startsBasicBlock(ControlFlowNode n) {
        n.asOperand() = any(Function f).getEntryInstruction().getFirstOperand()
        or
        exists(Instruction i |
          n.asInstruction() = i and
          i = any(Function f).getEntryInstruction() and
          not exists(i.getAnOperand())
        )
        or
        not exists(getAPredecessor(n)) and exists(getASuccessor(n))
        or
        isJoin(n)
        or
        isBranch(getAPredecessor(n))
      }

      private newtype TBasicBlock = TMkBasicBlock(ControlFlowNode n) { startsBasicBlock(n) }

      private predicate intraBBSucc(ControlFlowNode n1, ControlFlowNode n2) {
        n2 = getASuccessor(n1) and
        not startsBasicBlock(n2)
      }

      private predicate bbIndex(ControlFlowNode bbStart, ControlFlowNode i, int index) =
        shortestDistances(startsBasicBlock/1, intraBBSucc/2)(bbStart, i, index)

      private predicate entryBB(BasicBlock bb) { bb.isFunctionEntryBasicBlock() }

      private predicate succBB(BasicBlock pred, BasicBlock succ) { pred.getASuccessor() = succ }

      /** Holds if `dom` is an immediate dominator of `bb`. */
      cached
      private predicate bbIdominates(BasicBlock dom, BasicBlock bb) =
        idominance(entryBB/1, succBB/2)(_, dom, bb)

      private predicate predBB(BasicBlock succ, BasicBlock pred) { pred.getASuccessor() = succ }

      private class FunctionExitBasicBlock extends BasicBlock {
        FunctionExitBasicBlock() { this.getLastNode().asInstruction() instanceof RetInstruction }
      }

      private predicate exitBB(FunctionExitBasicBlock exit) { any() }

      /** Holds if `dom` is an immediate post-dominator of `bb`. */
      cached
      private predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
        idominance(exitBB/1, predBB/2)(_, dom, bb)

      class BasicBlock extends TBasicBlock {
        ControlFlowNode getNode(int i) { bbIndex(this.getFirstNode(), result, i) }

        ControlFlowNode getLastNode() { result = this.getNode(this.getNumberOfInstructions() - 1) }

        int length() { result = strictcount(this.getNode(_)) }

        BasicBlock getASuccessor() { result = this.getASuccessor(_) }

        ControlFlowNode getANode() { result = this.getNode(_) }

        ControlFlowNode getFirstNode() { this = TMkBasicBlock(result) }

        BasicBlock getASuccessor(SuccessorType t) {
          result.getFirstNode() = this.getLastNode().getSuccessor(t)
        }

        BasicBlock getAPredecessor() { this = result.getASuccessor() }

        int getNumberOfInstructions() { result = strictcount(this.getNode(_)) }

        string toString() { result = this.getFirstNode().toString() + ".." + this.getLastNode() }

        string getDumpString() {
          result =
            strictconcat(int index, ControlFlowNode node |
              node = this.getNode(index)
            |
              node.toString(), "\n" order by index
            )
        }

        Location getLocation() { result = this.getFirstNode().getLocation() }

        Function getEnclosingFunction() { result = this.getFirstNode().getEnclosingFunction() }

        predicate isFunctionEntryBasicBlock() {
          any(Function f).getEntryInstruction() =
            [this.getFirstNode().asInstruction(), this.getFirstNode().asOperand().getUse()]
        }

        predicate strictlyDominates(BasicBlock bb) { bbIdominates+(this, bb) }

        predicate dominates(BasicBlock bb) { this.strictlyDominates(bb) or this = bb }

        predicate inDominanceFrontier(BasicBlock df) {
          this.getASuccessor() = df and
          not bbIdominates(this, df)
          or
          exists(BasicBlock prev | prev.inDominanceFrontier(df) |
            bbIdominates(this, prev) and
            not bbIdominates(this, df)
          )
        }

        BasicBlock getImmediateDominator() { bbIdominates(result, this) }

        /**
         * Holds if this basic block strictly post-dominates basic block `bb`.
         *
         * That is, all paths reaching a normal exit point basic block from basic
         * block `bb` must go through this basic block and this basic block is
         * different from `bb`.
         */
        predicate strictlyPostDominates(BasicBlock bb) { bbIPostDominates+(this, bb) }

        /**
         * Holds if this basic block post-dominates basic block `bb`.
         *
         * That is, all paths reaching a normal exit point basic block from basic
         * block `bb` must go through this basic block.
         */
        predicate postDominates(BasicBlock bb) {
          this.strictlyPostDominates(bb) or
          this = bb
        }
      }

      class EntryBasicBlock extends BasicBlock {
        EntryBasicBlock() { this.isFunctionEntryBasicBlock() }
      }

      pragma[nomagic]
      predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
        bb1.getASuccessor() = bb2 and
        bb1 = bb2.getImmediateDominator() and
        forall(BasicBlock pred | pred = bb2.getAPredecessor() and pred != bb1 | bb2.dominates(pred))
      }

      private newtype TControlFlowNode =
        TInstructionControlFlowNode(Instruction i) or
        TOperandControlFlowNode(Operand op)

      class ControlFlowNode extends TControlFlowNode {
        Instruction asInstruction() { this = TInstructionControlFlowNode(result) }

        Operand asOperand() { this = TOperandControlFlowNode(result) }

        string toString() {
          result = this.asInstruction().toString()
          or
          result = this.asOperand().toString()
        }

        Location getLocation() {
          result = this.asInstruction().getLocation()
          or
          result = this.asOperand().getLocation()
        }

        ControlFlowNode getSuccessor(SuccessorType t) {
          t instanceof DirectSuccessor and
          exists(Instruction i, OperandTag tag | this.asOperand() = i.getOperand(tag) |
            result.asOperand() = i.getOperand(tag.getSuccessorTag())
            or
            this.asOperand() = i.getOperand(tag) and
            not exists(i.getOperand(tag.getSuccessorTag())) and
            result.asInstruction() = i
          )
          or
          exists(Instruction i | i = this.asInstruction().getSuccessor(t) |
            result.asOperand() = i.getFirstOperand()
            or
            not exists(i.getAnOperand()) and
            result.asInstruction() = i
          )
        }

        Function getEnclosingFunction() {
          result = this.asInstruction().getEnclosingFunction()
          or
          result = this.asOperand().getEnclosingFunction()
        }
      }
    }

    class BasicBlock = BinaryCfg::BasicBlock;

    class ControlFlowNode = BinaryCfg::ControlFlowNode;
  }
}
