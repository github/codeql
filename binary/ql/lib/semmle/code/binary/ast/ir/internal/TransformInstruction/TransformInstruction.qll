private import semmle.code.binary.ast.ir.internal.InstructionSig
private import semmle.code.binary.ast.ir.internal.InstructionTag as Tags
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

    class TranslatedElement {
      EitherInstructionTranslatedElementTagPair getSuccessor(
        Tags::InstructionTag tag, SuccessorType succType
      );

      EitherInstructionTranslatedElementTagPair getInstructionSuccessor(
        Input::Instruction i, SuccessorType succType
      );

      predicate producesResult();

      int getConstantValue(Tags::InstructionTag tag);

      predicate hasTempVariable(Tags::VariableTag tag);

      EitherVariableOrTranslatedElementVariablePair getVariableOperand(
        Tags::InstructionTag tag, Tags::OperandTag operandTag
      );

      Either<Input::Instruction, Input::Operand>::Either getRawElement();

      predicate hasInstruction(
        Opcode opcode, Tags::InstructionTag tag, OptionEitherVariableOrTranslatedElementPair v
      );

      Input::Function getStaticTarget(Tags::InstructionTag tag);

      predicate hasJumpCondition(Tags::InstructionTag tag, Opcode::ConditionKind kind);

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

      TranslatedElementVariablePair asRight();
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

      Tags::InstructionTag getInstructionTag();
    }

    class TranslatedElementVariablePair {
      string toString();

      TranslatedElement getTranslatedElement();

      Tags::VariableTag getVariableTag();
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
      TNewVariable(TranslatedElement te, Tags::VariableTag tag) { hasTempVariable(te, tag) }

    private Variable getNewVariable(Input::Variable v) { v = result.asOldVariable() }

    private Variable getTempVariable(TranslatedElement te, Tags::VariableTag tag) {
      result.isNewVariable(te, tag)
    }

    class Variable extends TVariable {
      Input::Variable asOldVariable() { this = TOldVariable(result) }

      predicate isNewVariable(TranslatedElement te, Tags::VariableTag tag) {
        this = TNewVariable(te, tag)
      }

      final string toString() {
        result = this.asOldVariable().toString()
        or
        exists(Tags::VariableTag tag, TranslatedElement te |
          this.isNewVariable(te, tag) and
          result = te.getDumpId() + "." + Tags::stringOfVariableTag(tag)
        )
      }

      Location getLocation() { result instanceof EmptyLocation }

      Operand getAnAccess() { result.getVariable() = this }
    }

    final private class FinalTranslatedElement = TransformInput::TranslatedElement;

    private class TranslatedElement extends FinalTranslatedElement {
      final predicate hasInstruction(
        Opcode opcode, Tags::InstructionTag tag, Option<Variable>::Option v
      ) {
        exists(TransformInput::OptionEitherVariableOrTranslatedElementPair o |
          super.hasInstruction(opcode, tag, o)
        |
          o.isNone() and
          v.isNone()
          or
          exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e | e = o.asSome() |
            v.asSome() = getNewVariable(e.asLeft())
            or
            exists(TransformInput::TranslatedElementVariablePair tevp |
              e.asRight() = tevp and
              v.asSome() = getTempVariable(tevp.getTranslatedElement(), tevp.getVariableTag())
            )
          )
        )
      }

      final Instruction getInstruction(Tags::InstructionTag tag) {
        result = MkInstruction(this, tag)
      }

      final Instruction getSuccessor(Tags::InstructionTag tag, SuccessorType succType) {
        exists(TransformInput::EitherInstructionTranslatedElementTagPair e |
          e = super.getSuccessor(tag, succType)
        |
          result = getNewInstruction(e.asLeft())
          or
          exists(TransformInput::TranslatedElementTagPair p |
            p = e.asRight() and
            result =
              p.getTranslatedElement().(TranslatedElement).getInstruction(p.getInstructionTag())
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
              p.getTranslatedElement().(TranslatedElement).getInstruction(p.getInstructionTag())
          )
        )
      }

      final Variable getVariableOperand(Tags::InstructionTag tag, Tags::OperandTag operandTag) {
        exists(TransformInput::EitherVariableOrTranslatedElementVariablePair e |
          e = super.getVariableOperand(tag, operandTag)
        |
          result = getNewVariable(e.asLeft())
          or
          exists(TransformInput::TranslatedElementVariablePair tevp |
            e.asRight() = tevp and
            result = getTempVariable(tevp.getTranslatedElement(), tevp.getVariableTag())
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
              p.getTranslatedElement().(TranslatedElement).getInstruction(p.getInstructionTag())
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
                p.getTranslatedElement().(TranslatedElement).getInstruction(p.getInstructionTag())
            )
          )
        )
      }
    }

    private predicate hasInstruction(TranslatedElement te, Tags::InstructionTag tag) {
      te.hasInstruction(_, tag, _)
    }

    private predicate hasTempVariable(TranslatedElement te, Tags::VariableTag tag) {
      te.hasTempVariable(tag)
    }

    private newtype TInstruction =
      TOldInstruction(Input::Instruction i) { not TransformInput::isRemovedInstruction(i) } or
      MkInstruction(TranslatedElement te, Tags::InstructionTag tag) { hasInstruction(te, tag) }

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
            strictconcat(Tags::OperandTag op, string s |
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

      Operand getOperand(Tags::OperandTag operandTag) { none() }

      final Operand getAnOperand() { result = this.getOperand(_) }

      Instruction getSuccessor(SuccessorType succType) { none() }

      final Instruction getASuccessor() { result = this.getSuccessor(_) }

      final Instruction getAPredecessor() { this = result.getASuccessor() }

      Location getLocation() { none() }

      Variable getResultVariable() { none() }

      Function getEnclosingFunction() { none() }

      BasicBlock getBasicBlock() { result.getANode().asInstruction() = this }

      Operand getFirstOperand() {
        exists(Tags::OperandTag operandTag |
          result = this.getOperand(operandTag) and
          not exists(operandTag.getPredecessorTag())
        )
      }

      Tags::InstructionTag getInstructionTag() { none() }
    }

    class RetInstruction extends Instruction {
      RetInstruction() { this.getOpcode() instanceof Opcode::Ret }
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
        exists(TranslatedElement te, Tags::InstructionTag tag |
          this = MkInstruction(te, tag) and
          te.hasJumpCondition(tag, result)
        )
      }

      override string getImmediateValue() { result = Opcode::stringOfConditionKind(this.getKind()) }

      ConditionOperand getConditionOperand() { result = this.getAnOperand() }

      ConditionJumpTargetOperand getJumpTargetOperand() { result = this.getAnOperand() }
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
        exists(TranslatedElement te, Tags::InstructionTag tag |
          this = MkInstruction(te, tag) and
          result = te.getStaticTarget(tag)
        )
      }

      override string getImmediateValue() { result = this.getStaticTarget().getName() }
    }

    class LoadInstruction extends Instruction {
      LoadInstruction() { this.getOpcode() instanceof Opcode::Load }

      UnaryOperand getOperand() { result = this.getAnOperand() }
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
        exists(TranslatedElement te, Tags::InstructionTag tag |
          this = MkInstruction(te, tag) and
          result = te.getConstantValue(tag)
        )
      }

      override string getImmediateValue() { result = this.getValue().toString() }
    }

    private class NewInstruction extends MkInstruction, Instruction {
      Opcode opcode;
      TranslatedElement te;
      Tags::InstructionTag tag;

      NewInstruction() { this = MkInstruction(te, tag) and te.hasInstruction(opcode, tag, _) }

      override Opcode getOpcode() { te.hasInstruction(result, tag, _) }

      override string getImmediateValue() { none() }

      override Operand getOperand(Tags::OperandTag operandTag) {
        result = MkOperand(te, tag, operandTag)
      }

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

      override Tags::InstructionTag getInstructionTag() { result = tag }
    }

    private Instruction getInstructionSuccessor(Input::Instruction old, SuccessorType succType) {
      result = any(TranslatedElement te).getInstructionSuccessor(old, succType)
    }

    private class OldInstruction extends TOldInstruction, Instruction {
      Input::Instruction old;

      OldInstruction() { this = TOldInstruction(old) }

      override Opcode getOpcode() { result = old.getOpcode() }

      override Operand getOperand(Tags::OperandTag operandTag) {
        result = getNewOperand(old.getOperand(operandTag))
      }

      override string getImmediateValue() { result = old.getImmediateValue() }

      override Instruction getSuccessor(SuccessorType succType) {
        exists(Input::Instruction oldSucc |
          not exists(getInstructionSuccessor(old, _)) and
          oldSucc = old.getSuccessor(succType) and
          result = getNewInstruction(oldSucc)
        )
        or
        result = getInstructionSuccessor(old, succType)
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
          exists(TransformInput::TranslatedElementVariablePair tevp |
            e.asRight() = tevp and
            result = getTempVariable(tevp.getTranslatedElement(), tevp.getVariableTag())
          )
        )
      }

      override Function getEnclosingFunction() { result = old.getEnclosingFunction() }

      override Tags::InstructionTag getInstructionTag() { result = old.getInstructionTag() }
    }

    private newtype TOperand =
      TOldOperand(Input::Operand op) {
        exists(Input::Instruction use |
          use = op.getUse() and
          not TransformInput::isRemovedInstruction(use)
        )
      } or
      MkOperand(TranslatedElement te, Tags::InstructionTag tag, Tags::OperandTag operandTag) {
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

      Tags::OperandTag getOperandTag() { none() }
    }

    private class NewOperand extends MkOperand, Operand {
      TranslatedElement te;
      Tags::InstructionTag tag;
      Tags::OperandTag operandTag;

      NewOperand() { this = MkOperand(te, tag, operandTag) }

      override Variable getVariable() { result = te.getVariableOperand(tag, operandTag) }

      override Tags::OperandTag getOperandTag() { result = operandTag }
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
          exists(TransformInput::TranslatedElementVariablePair tevp |
            e.asRight() = tevp and
            result = getTempVariable(tevp.getTranslatedElement(), tevp.getVariableTag())
          )
        )
      }

      override Tags::OperandTag getOperandTag() { result = old.getOperandTag() }
    }

    class StoreValueOperand extends Operand {
      StoreValueOperand() { this.getOperandTag() instanceof Tags::StoreValueTag }
    }

    class StoreAddressOperand extends Operand {
      StoreAddressOperand() { this.getOperandTag() instanceof Tags::StoreAddressTag }
    }

    class UnaryOperand extends Operand {
      UnaryOperand() { this.getOperandTag() instanceof Tags::UnaryTag }
    }

    class ConditionOperand extends Operand {
      ConditionOperand() { this.getOperandTag() instanceof Tags::CondTag }
    }

    class ConditionJumpTargetOperand extends Operand {
      ConditionJumpTargetOperand() { this.getOperandTag() instanceof Tags::CondJumpTargetTag }
    }

    class LeftOperand extends Operand {
      LeftOperand() { this.getOperandTag() instanceof Tags::LeftTag }
    }

    class RightOperand extends Operand {
      RightOperand() { this.getOperandTag() instanceof Tags::RightTag }
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
          exists(Instruction i, Tags::OperandTag tag | this.asOperand() = i.getOperand(tag) |
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
