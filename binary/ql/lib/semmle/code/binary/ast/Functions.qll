private import binary
private import semmle.code.binary.controlflow.BasicBlock

class FunctionEntryInstruction extends Instruction {
  FunctionEntryInstruction() {
    this = any(Call call).getTarget()
    or
    this instanceof ProgramEntryInstruction
  }
}

class FunctionEntryBasicBlock extends BasicBlock {
  FunctionEntryBasicBlock() { this.getFirstInstruction() instanceof FunctionEntryInstruction }
}

private newtype TFunction = TMkFunction(FunctionEntryInstruction entry)

class Function extends TFunction {
  FunctionEntryInstruction entry;

  Function() { this = TMkFunction(entry) }

  FunctionEntryBasicBlock getEntryBlock() { result = entry.getBasicBlock() }

  string getName() { result = "Function_" + entry.getIndex() }

  string toString() { result = this.getName() }

  Location getLocation() { result = entry.getLocation() }

  pragma[nomagic]
  BasicBlock getABasicBlock() { result = this.getEntryBlock().getASuccessor*() }
}

class ProgramEntryFunction extends Function {
  ProgramEntryFunction() { this.getEntryBlock() instanceof ProgramEntryBasicBlock }

  final override string getName() { result = "Program_entry_function" }
}
