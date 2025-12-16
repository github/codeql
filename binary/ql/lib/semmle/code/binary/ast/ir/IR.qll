import semmle.code.binary.ast.Location
import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.Opcode
private import semmle.code.binary.ast.ir.internal.Tags
private import codeql.controlflow.BasicBlock as BB
private import semmle.code.binary.dataflow.Ssa

private module FinalInstruction {
  private import internal.Instruction2.Instruction2::Instruction2 as Instruction

  class Function instanceof Instruction::Function {
    string getName() { result = super.getName() }

    string toString() { result = super.toString() }

    FunEntryInstruction getEntryInstruction() { result = super.getEntryInstruction() }

    BasicBlock getEntryBlock() { result = super.getEntryBlock() }

    Location getLocation() { result = super.getLocation() }

    predicate isProgramEntryPoint() { super.isProgramEntryPoint() }

    Type getDeclaringType() { result = super.getDeclaringType() }

    predicate isPublic() { super.isPublic() }

    /**
     * Gets the fully qualified name of this method in the format:
     * "Namespace.ClassName.MethodName".
     *
     * If no declaring type exists, only the method name is returned.
     */
    string getFullyQualifiedName() {
      exists(Type t | t = this.getDeclaringType() | result = t.getFullName() + "." + this.getName())
      or
      not exists(this.getDeclaringType()) and
      result = this.getName()
    }

    /**
     * Holds if this method matches the given namespace, class name, and method name.
     *
     * If no declaring type exists, `namespace = className = ""`.
     */
    predicate hasFullyQualifiedName(string namespace, string className, string methodName) {
      exists(Type t | t = this.getDeclaringType() |
        t.getNamespace() = namespace and
        t.getName() = className and
        this.getName() = methodName
      )
      or
      not exists(this.getDeclaringType()) and
      namespace = "" and
      className = "" and
      this.getName() = methodName
    }
  }

  class Type instanceof Instruction::Type {
    Function getAFunction() { result = super.getAFunction() }

    string toString() { result = super.toString() }

    string getFullName() { result = super.getFullName() }

    string getNamespace() { result = super.getNamespace() }

    string getName() { result = super.getName() }

    Location getLocation() { result = super.getLocation() }
  }

  class Operand instanceof Instruction::Operand {
    string toString() { result = super.toString() }

    Instruction getUse() { result = super.getUse() }

    Variable getVariable() { result = super.getVariable() }

    Function getEnclosingFunction() { result = super.getEnclosingFunction() }

    OperandTag getOperandTag() { result = super.getOperandTag() }

    Location getLocation() { result = super.getLocation() }

    Ssa::Definition getDef() { result.getARead() = this }

    Instruction getAnyDef() { result = this.getDef().getAnUltimateDefinition().asInstruction() }
  }

  class StoreValueOperand extends Operand instanceof Instruction::StoreValueOperand { }

  class StoreAddressOperand extends Operand instanceof Instruction::StoreAddressOperand { }

  class UnaryOperand extends Operand instanceof Instruction::UnaryOperand { }

  class LoadAddressOperand extends Operand instanceof Instruction::LoadAddressOperand { }

  class ConditionOperand extends Operand instanceof Instruction::ConditionOperand { }

  class ConditionJumpTargetOperand extends Operand instanceof Instruction::ConditionJumpTargetOperand
  { }

  class JumpTargetOperand extends Operand instanceof Instruction::JumpTargetOperand { }

  class LeftOperand extends Operand instanceof Instruction::LeftOperand { }

  class RightOperand extends Operand instanceof Instruction::RightOperand { }

  class CallTargetOperand extends Operand instanceof Instruction::CallTargetOperand { }

  class InstructionTag instanceof Instruction::InstructionTag {
    string toString() { result = super.toString() }
  }

  class OperandTag instanceof Instruction::OperandTag {
    int getIndex() { result = super.getIndex() }

    OperandTag getSuccessorTag() { result = super.getSuccessorTag() }

    OperandTag getPredecessorTag() { result = super.getPredecessorTag() }

    string toString() { result = super.toString() }
  }

  class LeftTag extends OperandTag instanceof Instruction::LeftTag { }

  class RightTag extends OperandTag instanceof Instruction::RightTag { }

  class UnaryTag extends OperandTag instanceof Instruction::UnaryTag { }

  class StoreValueTag extends OperandTag instanceof Instruction::StoreValueTag { }

  class LoadAddressTag extends OperandTag instanceof Instruction::LoadAddressTag { }

  class StoreAddressTag extends OperandTag instanceof Instruction::StoreAddressTag { }

  class CallTargetTag extends OperandTag instanceof Instruction::CallTargetTag { }

  class CondTag extends OperandTag instanceof Instruction::CondTag { }

  class CondJumpTargetTag extends OperandTag instanceof Instruction::CondJumpTargetTag { }

  class JumpTargetTag extends OperandTag instanceof Instruction::JumpTargetTag { }

  class TempVariableTag instanceof Instruction::TempVariableTag {
    string toString() { result = super.toString() }
  }

  class Variable instanceof Instruction::Variable {
    string toString() { result = super.toString() }

    Location getLocation() { result = super.getLocation() }

    Operand getAnAccess() { result = super.getAnAccess() }
  }

  class TempVariable extends Variable instanceof Instruction::TempVariable { }

  class LocalVariable extends Variable instanceof Instruction::LocalVariable {
    Function getEnclosingFunction() { result = super.getEnclosingFunction() }

    predicate isStackAllocated() { super.isStackAllocated() }
  }

  class StackPointer extends LocalVariable instanceof Instruction::StackPointer { }

  class FramePointer extends LocalVariable instanceof Instruction::FramePointer { }

  module BinaryCfg implements BB::CfgSig<Location> {
    class BasicBlock instanceof Instruction::BasicBlock {
      ControlFlowNode getNode(int index) { result = super.getNode(index) }

      ControlFlowNode getANode() { result = super.getANode() }

      ControlFlowNode getFirstNode() { result = super.getFirstNode() }

      ControlFlowNode getLastNode() { result = super.getLastNode() }

      int length() { result = super.length() }

      BasicBlock getASuccessor() { result = super.getASuccessor() }

      BasicBlock getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

      BasicBlock getAPredecessor() { result = super.getAPredecessor() }

      int getNumberOfInstructions() { result = super.getNumberOfInstructions() }

      string toString() { result = super.toString() }

      string getDumpString() { result = super.getDumpString() }

      Location getLocation() { result = super.getLocation() }

      Function getEnclosingFunction() { result = super.getEnclosingFunction() }

      predicate isFunctionEntryBasicBlock() { super.isFunctionEntryBasicBlock() }

      predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

      predicate dominates(BasicBlock bb) { super.dominates(bb) }

      BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

      predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

      predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

      predicate postDominates(BasicBlock bb) { super.postDominates(bb) }

      predicate edgeDominates(BasicBlock dominated, SuccessorType s) {
        exists(BasicBlock succ |
          succ = this.getASuccessor(s) and dominatingEdge(this, succ) and succ.dominates(dominated)
        )
      }
    }

    class EntryBasicBlock extends BasicBlock {
      EntryBasicBlock() { this.isFunctionEntryBasicBlock() }
    }

    additional class ConditionBasicBlock extends BasicBlock {
      ConditionBasicBlock() { this.getLastNode().asInstruction() instanceof CJumpInstruction }
    }

    pragma[nomagic]
    predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
      bb1.getASuccessor() = bb2 and
      bb1 = bb2.getImmediateDominator() and
      forall(BasicBlock pred | pred = bb2.getAPredecessor() and pred != bb1 | bb2.dominates(pred))
    }

    class ControlFlowNode instanceof Instruction::ControlFlowNode {
      Instruction asInstruction() { result = super.asInstruction() }

      Operand asOperand() { result = super.asOperand() }

      Function getEnclosingFunction() { result = super.getEnclosingFunction() }

      Location getLocation() { result = super.getLocation() }

      string toString() { result = super.toString() }
    }
  }

  class BasicBlock = BinaryCfg::BasicBlock;

  class EntryBasicBlock = BinaryCfg::EntryBasicBlock;

  class ConditionBasicBlock = BinaryCfg::ConditionBasicBlock;

  class ControlFlowNode = BinaryCfg::ControlFlowNode;

  class Instruction instanceof Instruction::Instruction {
    string toString() { result = super.toString() }

    Opcode getOpcode() { result = super.getOpcode() }

    Operand getOperand(OperandTag operandTag) { result = super.getOperand(operandTag) }

    Operand getAnOperand() { result = super.getAnOperand() }

    string getImmediateValue() { result = super.getImmediateValue() }

    Instruction getSuccessor(SuccessorType succType) { result = super.getSuccessor(succType) }

    Instruction getASuccessor() { result = super.getASuccessor() }

    Instruction getAPredecessor() { result = super.getAPredecessor() }

    Location getLocation() { result = super.getLocation() }

    Variable getResultVariable() { result = super.getResultVariable() }

    Function getEnclosingFunction() { result = super.getEnclosingFunction() }

    BasicBlock getBasicBlock() { result = super.getBasicBlock() }

    InstructionTag getInstructionTag() { result = super.getInstructionTag() }

    Operand getFirstOperand() { result = super.getFirstOperand() }

    Operand getAUse() { result.getDef().asInstruction() = this }
  }

  class RetInstruction extends Instruction instanceof Instruction::RetInstruction { }

  class RetValueInstruction extends Instruction instanceof Instruction::RetValueInstruction {
    UnaryOperand getReturnValueOperand() { result = super.getReturnValueOperand() }
  }

  class BinaryInstruction extends Instruction instanceof Instruction::BinaryInstruction {
    LeftOperand getLeftOperand() { result = super.getLeftOperand() }

    RightOperand getRightOperand() { result = super.getRightOperand() }
  }

  class InitInstruction extends Instruction instanceof Instruction::InitInstruction { }

  class ExternalRefInstruction extends Instruction instanceof Instruction::ExternalRefInstruction {
    string getExternalName() { result = super.getExternalName() }

    cached
    predicate hasFullyQualifiedName(string namespace, string className, string methodName) {
      exists(string s, string r |
        this.getExternalName() = s and
        r = "(.+)\\.([^.]+)\\.(\\.?[^.]+)" and
        namespace = s.regexpCapture(r, 1) and
        className = s.regexpCapture(r, 2) and
        methodName = s.regexpCapture(r, 3)
      )
    }

    string getFullyQualifiedName() {
      exists(string namespace, string className, string methodName |
        this.hasFullyQualifiedName(namespace, className, methodName) and
        result = namespace + "." + className + "." + methodName
      )
    }
  }

  class FieldAddressInstruction extends Instruction instanceof Instruction::FieldAddressInstruction {
    UnaryOperand getBaseOperand() { result = super.getBaseOperand() }

    string getFieldName() { result = super.getFieldName() }
  }

  class SubInstruction extends BinaryInstruction instanceof Instruction::SubInstruction { }

  class AddInstruction extends BinaryInstruction instanceof Instruction::AddInstruction { }

  class ShlInstruction extends BinaryInstruction instanceof Instruction::ShlInstruction { }

  class ShrInstruction extends BinaryInstruction instanceof Instruction::ShrInstruction { }

  class RolInstruction extends BinaryInstruction instanceof Instruction::RolInstruction { }

  class RorInstruction extends BinaryInstruction instanceof Instruction::RorInstruction { }

  class OrInstruction extends BinaryInstruction instanceof Instruction::OrInstruction { }

  class AndInstruction extends BinaryInstruction instanceof Instruction::AndInstruction { }

  class XorInstruction extends BinaryInstruction instanceof Instruction::XorInstruction { }

  class FunEntryInstruction extends Instruction instanceof Instruction::FunEntryInstruction { }

  class CJumpInstruction extends Instruction instanceof Instruction::CJumpInstruction {
    ConditionKind getKind() { result = super.getKind() }

    ConditionOperand getConditionOperand() { result = super.getConditionOperand() }

    ConditionJumpTargetOperand getJumpTargetOperand() { result = super.getJumpTargetOperand() }
  }

  class JumpInstruction extends Instruction instanceof Instruction::JumpInstruction {
    JumpTargetOperand getJumpTargetOperand() { result = super.getJumpTargetOperand() }
  }

  class CopyInstruction extends Instruction instanceof Instruction::CopyInstruction {
    UnaryOperand getOperand() { result = super.getOperand() }
  }

  class CallInstruction extends Instruction instanceof Instruction::CallInstruction {
    CallTargetOperand getTargetOperand() { result = super.getTargetOperand() }

    /**
     * Gets the static target of this function call, if it is known (and the
     * function exists in the database).
     */
    Function getStaticTarget() { result = super.getStaticTarget() }
  }

  class LoadInstruction extends Instruction instanceof Instruction::LoadInstruction {
    LoadAddressOperand getOperand() { result = super.getOperand() }
  }

  class StoreInstruction extends Instruction instanceof Instruction::StoreInstruction {
    StoreValueOperand getValueOperand() { result = super.getValueOperand() }

    StoreAddressOperand getAddressOperand() { result = super.getAddressOperand() }
  }

  class ConstInstruction extends Instruction instanceof Instruction::ConstInstruction {
    int getValue() { result = super.getValue() }

    string getStringValue() { result = super.getStringValue() }
  }
}

import FinalInstruction
