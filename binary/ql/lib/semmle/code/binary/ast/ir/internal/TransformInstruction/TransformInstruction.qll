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

    default predicate isRemovedInstruction(Input::Instruction instr) { none() }

    class InstructionTag {
      string toString();
    }

    class TempVariableTag {
      string toString();
    }

    class LocalVariableTag {
      string toString();
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
        InstructionTag tag, OperandTag operandTag
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

    // This one only exists because we can't use `Option<Either<Input::Instruction, TranslatedElementTagPair>::Either>::Option` in TranslatedOperand::getEntry because of https://github.com/github/codeql-core/issues/5091.
    class OptionEitherInstructionTranslatedElementTagPair {
      predicate isNone();

      EitherInstructionTranslatedElementTagPair asSome();
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

    class TranslatedInstruction extends TranslatedElement {
      EitherInstructionTranslatedElementTagPair getEntry();
    }

    class TranslatedOperand extends TranslatedElement {
      OptionEitherInstructionTranslatedElementTagPair getEntry();
    }
  }

  module Make<TransformInputSig TransformInput> implements InstructionSig {
    class Function instanceof Input::Function {
      string getName() { result = super.getName() }

      string toString() { result = super.getName() }

      Instruction getEntryInstruction() { result = getNewInstruction(super.getEntryInstruction()) }

      BasicBlock getEntryBlock() { result = this.getEntryInstruction().getBasicBlock() }

      Location getLocation() { result = this.getEntryInstruction().getLocation() }

      predicate isProgramEntryPoint() { super.isProgramEntryPoint() }
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
    }

    private module MInstructionTag = Either<Input::InstructionTag, TransformInput::InstructionTag>;

    class InstructionTag = MInstructionTag::Either;

    class TempVariableTag = Either<Input::TempVariableTag, TransformInput::TempVariableTag>::Either;

    final private class FinalTranslatedElement = TransformInput::TranslatedElement;

    private class TranslatedElement extends FinalTranslatedElement {
      final predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
        exists(TransformInput::OptionEitherVariableOrTranslatedElementPair o |
          super.hasInstruction(opcode, tag.asRight(), o)
        |
          o.isNone() and
          v.isNone()
          or
          exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e | e = o.asSome() |
            v.asSome() = getNewVariable(e.asLeft())
            or
            exists(
              TransformInput::EitherTranslatedElementVariablePairOrFunctionLocalVariablePair tevp
            |
              e.asRight() = tevp
            |
              exists(TransformInput::TranslatedElementVariablePair p |
                tevp.asLeft() = p and
                v.asSome() = getTempVariable(p.getTranslatedElement(), p.getVariableTag())
              )
              or
              exists(TransformInput::FunctionLocalVariablePair p |
                tevp.asRight() = p and
                v.asSome() = getLocalVariable(p.getFunction(), p.getLocalVariableTag())
              )
            )
          )
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
          e = super.getVariableOperand(tag.asRight(), operandTag)
        |
          result = getNewVariable(e.asLeft())
          or
          exists(
            TransformInput::EitherTranslatedElementVariablePairOrFunctionLocalVariablePair tevp
          |
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

    private class TranslatedOperand extends TranslatedElement instanceof TransformInput::TranslatedOperand
    {
      final Option<Instruction>::Option getEntry() {
        exists(TransformInput::OptionEitherInstructionTranslatedElementTagPair o |
          o = super.getEntry()
        |
          o.isNone() and
          result.isNone()
          or
          exists(TransformInput::EitherInstructionTranslatedElementTagPair e | e = o.asSome() |
            result.asSome() = getNewInstruction(e.asLeft())
            or
            exists(TransformInput::TranslatedElementTagPair p |
              e.asRight() = p and
              result.asSome() =
                p.getTranslatedElement()
                    .(TranslatedElement)
                    .getInstruction(MInstructionTag::right(p.getInstructionTag()))
            )
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
          not exists(operandTag.getPredecessorTag())
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

      override string getImmediateValue() { result = this.getValue().toString() }
    }

    class InstrRefInstruction extends Instruction {
      InstrRefInstruction() { this.getOpcode() instanceof Opcode::InstrRef }

      Instruction getReferencedInstruction() {
        exists(Input::InstrRefInstruction instrRef |
          this = TOldInstruction(instrRef) and
          result = getNewInstruction(instrRef.getReferencedInstruction())
        )
        or
        exists(TranslatedElement te, InstructionTag tag |
          this = MkInstruction(te, tag) and
          result = te.getReferencedInstruction(tag)
        )
      }

      final override string getImmediateValue() {
        exists(Instruction ref | ref = this.getReferencedInstruction() |
          result = ref.getResultVariable().toString()
          or
          not exists(ref.getResultVariable()) and
          result = "<reference to instruction without result>"
        )
      }
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

    private class OldInstruction extends TOldInstruction, Instruction {
      Input::Instruction old;

      OldInstruction() { this = TOldInstruction(old) }

      override Opcode getOpcode() { result = old.getOpcode() }

      override Operand getOperand(OperandTag operandTag) {
        result = getNewOperand(old.getOperand(operandTag))
      }

      override string getImmediateValue() { result = old.getImmediateValue() }

      override Instruction getSuccessor(SuccessorType succType) {
        exists(Input::Instruction oldSucc |
          not exists(getInstructionSuccessor(old, _)) and
          oldSucc = getNonRemovedSuccessor(old, succType) and
          result = getNewInstruction(oldSucc)
        )
        or
        exists(Instruction i | i = getInstructionSuccessor(old, succType) |
          exists(Input::Instruction iOld | i = TOldInstruction(iOld) |
            if TransformInput::isRemovedInstruction(iOld)
            then result = TOldInstruction(getNonRemovedSuccessor(iOld, _))
            else result = i
          )
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
          e = TransformInput::getResultVariable(old)
        |
          result = getNewVariable(e.asLeft())
          or
          exists(
            TransformInput::EitherTranslatedElementVariablePairOrFunctionLocalVariablePair tevp
          |
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
        )
      }

      override Function getEnclosingFunction() { result = old.getEnclosingFunction() }

      override InstructionTag getInstructionTag() { result.asLeft() = old.getInstructionTag() }
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

    private class NewOperand extends MkOperand, Operand {
      TranslatedElement te;
      InstructionTag tag;
      OperandTag operandTag;

      NewOperand() { this = MkOperand(te, tag, operandTag) }

      override Variable getVariable() { result = te.getVariableOperand(tag, operandTag) }

      override OperandTag getOperandTag() { result = operandTag }
    }

    private class OldOperand extends TOldOperand, Operand {
      Input::Operand old;

      OldOperand() { this = TOldOperand(old) }

      override Variable getVariable() {
        not exists(TransformInput::getOperandVariable(old)) and
        result = getNewVariable(old.getVariable())
        or
        exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e |
          e = TransformInput::getOperandVariable(old)
        |
          result = getNewVariable(e.asLeft())
          or
          exists(
            TransformInput::EitherTranslatedElementVariablePairOrFunctionLocalVariablePair tevp
          |
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
        )
      }

      override OperandTag getOperandTag() { result = old.getOperandTag() }
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
            not exists(tag.getSuccessorTag()) and
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
