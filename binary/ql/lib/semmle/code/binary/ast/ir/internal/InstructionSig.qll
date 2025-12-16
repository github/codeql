private import Opcode
private import Tags
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.Location

signature module InstructionSig {
  class Type {
    Function getAFunction();

    string toString();

    string getFullName();

    string getNamespace();

    string getName();

    Location getLocation();
  }

  class Function {
    string getName();

    string toString();

    FunEntryInstruction getEntryInstruction();

    BasicBlock getEntryBlock();

    Location getLocation();

    predicate isProgramEntryPoint();

    Type getDeclaringType();

    predicate isPublic();
  }

  class Operand {
    string toString();

    Instruction getUse();

    Variable getVariable();

    Function getEnclosingFunction();

    OperandTag getOperandTag();

    Location getLocation();
  }

  class StoreValueOperand extends Operand;

  class StoreAddressOperand extends Operand;

  class UnaryOperand extends Operand;

  class LoadAddressOperand extends Operand;

  class ConditionOperand extends Operand;

  class ConditionJumpTargetOperand extends Operand;

  class JumpTargetOperand extends Operand;

  class LeftOperand extends Operand;

  class RightOperand extends Operand;

  class CallTargetOperand extends Operand;

  class InstructionTag {
    string toString();
  }

  class OperandTag {
    int getIndex();

    OperandTag getSuccessorTag();

    OperandTag getPredecessorTag();

    string toString();
  }

  class LeftTag extends OperandTag;

  class RightTag extends OperandTag;

  class UnaryTag extends OperandTag;

  class StoreValueTag extends OperandTag;

  class LoadAddressTag extends OperandTag;

  class StoreAddressTag extends OperandTag;

  class CallTargetTag extends OperandTag;

  class CondTag extends OperandTag;

  class CondJumpTargetTag extends OperandTag;

  class JumpTargetTag extends OperandTag;

  class TempVariableTag {
    string toString();
  }

  class Variable {
    string toString();

    Location getLocation();

    Operand getAnAccess();
  }

  predicate variableHasOrdering(Variable v, int ordering);

  class TempVariable extends Variable;

  class LocalVariable extends Variable {
    Function getEnclosingFunction();

    predicate isStackAllocated();
  }

  class StackPointer extends LocalVariable;

  class FramePointer extends LocalVariable;

  class BasicBlock {
    ControlFlowNode getNode(int index);

    ControlFlowNode getANode();

    ControlFlowNode getFirstNode();

    ControlFlowNode getLastNode();

    BasicBlock getASuccessor();

    BasicBlock getAPredecessor();

    int getNumberOfInstructions();

    string toString();

    string getDumpString();

    Location getLocation();

    Function getEnclosingFunction();

    predicate isFunctionEntryBasicBlock();
  }

  class Instruction {
    string toString();

    Opcode getOpcode();

    Operand getOperand(OperandTag operandTag);

    Operand getAnOperand();

    string getImmediateValue();

    Instruction getSuccessor(SuccessorType succType);

    Instruction getASuccessor();

    Instruction getAPredecessor();

    Location getLocation();

    Variable getResultVariable();

    Function getEnclosingFunction();

    BasicBlock getBasicBlock();

    InstructionTag getInstructionTag();

    Operand getFirstOperand();
  }

  class RetInstruction extends Instruction;

  class RetValueInstruction extends Instruction {
    UnaryOperand getReturnValueOperand();
  }

  class BinaryInstruction extends Instruction {
    LeftOperand getLeftOperand();

    RightOperand getRightOperand();
  }

  class InitInstruction extends Instruction;

  class ExternalRefInstruction extends Instruction {
    string getExternalName();
  }

  class SubInstruction extends BinaryInstruction;

  class AddInstruction extends BinaryInstruction;

  class ShlInstruction extends BinaryInstruction;

  class ShrInstruction extends BinaryInstruction;

  class RolInstruction extends BinaryInstruction;

  class RorInstruction extends BinaryInstruction;

  class OrInstruction extends BinaryInstruction;

  class AndInstruction extends BinaryInstruction;

  class XorInstruction extends BinaryInstruction;

  class FunEntryInstruction extends Instruction;

  class CJumpInstruction extends Instruction {
    ConditionKind getKind();

    ConditionOperand getConditionOperand();

    ConditionJumpTargetOperand getJumpTargetOperand();
  }

  class JumpInstruction extends Instruction {
    JumpTargetOperand getJumpTargetOperand();
  }

  class CopyInstruction extends Instruction {
    UnaryOperand getOperand();
  }

  class CallInstruction extends Instruction {
    CallTargetOperand getTargetOperand();

    /**
     * Gets the static target of this function call, if it is known (and the
     * function exists in the database).
     */
    Function getStaticTarget();
  }

  class LoadInstruction extends Instruction {
    LoadAddressOperand getOperand();
  }

  class StoreInstruction extends Instruction {
    StoreValueOperand getValueOperand();

    StoreAddressOperand getAddressOperand();
  }

  class ConstInstruction extends Instruction {
    int getValue();

    string getStringValue();
  }

  class FieldAddressInstruction extends Instruction {
    UnaryOperand getBaseOperand();

    string getFieldName();
  }

  class ControlFlowNode {
    Instruction asInstruction();

    Operand asOperand();

    Function getEnclosingFunction();

    Location getLocation();

    string toString();
  }
}
