private import Opcode
private import Tags
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.Location

signature module InstructionSig {
  class Function {
    string getName();

    string toString();

    Instruction getEntryInstruction();

    BasicBlock getEntryBlock();

    Location getLocation();

    predicate isProgramEntryPoint();
  }

  class Operand {
    string toString();

    Instruction getUse();

    Variable getVariable();

    Function getEnclosingFunction();

    OperandTag getOperandTag();
  }

  class StoreValueOperand extends Operand;

  class StoreAddressOperand extends Operand;

  class UnaryOperand extends Operand;

  class ConditionOperand extends Operand;

  class ConditionJumpTargetOperand extends Operand;

  class JumpTargetOperand extends Operand;

  class LeftOperand extends Operand;

  class RightOperand extends Operand;

  class InstructionTag {
    string toString();
  }

  class TempVariableTag {
    string toString();
  }

  class Variable {
    string toString();

    Location getLocation();

    Operand getAnAccess();
  }

  class TempVariable extends Variable;

  class LocalVariable extends Variable {
    Function getEnclosingFunction();
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

  class SubInstruction extends BinaryInstruction;

  class AddInstruction extends BinaryInstruction;

  class ShlInstruction extends BinaryInstruction;

  class ShrInstruction extends BinaryInstruction;

  class RolInstruction extends BinaryInstruction;

  class RorInstruction extends BinaryInstruction;

  class OrInstruction extends BinaryInstruction;

  class AndInstruction extends BinaryInstruction;

  class XorInstruction extends BinaryInstruction;

  class CJumpInstruction extends Instruction {
    ConditionKind getKind();

    ConditionOperand getConditionOperand();

    ConditionJumpTargetOperand getJumpTargetOperand();
  }

  class JumpInstruction extends Instruction {
    JumpTargetOperand getJumpTargetOperand();
  }

  class InstrRefInstruction extends Instruction {
    Instruction getReferencedInstruction();
  }

  class CopyInstruction extends Instruction {
    UnaryOperand getOperand();
  }

  class CallInstruction extends Instruction {
    Function getStaticTarget();
  }

  class LoadInstruction extends Instruction {
    UnaryOperand getOperand();
  }

  class StoreInstruction extends Instruction {
    StoreValueOperand getValueOperand();

    StoreAddressOperand getAddressOperand();
  }

  class ConstInstruction extends Instruction {
    int getValue();
  }

  class ControlFlowNode {
    Instruction asInstruction();

    Operand asOperand();

    Function getEnclosingFunction();

    Location getLocation();
  }
}
