private import binary

class FunctionEntryInstruction extends Instruction {
  FunctionEntryInstruction() {
    this = any(Call call).getTarget()
    or
    this instanceof ProgramEntryInstruction
    or
    this instanceof ExportedEntryInstruction
  }
}

private newtype TFunction = TMkFunction(FunctionEntryInstruction entry)

class Function extends TFunction {
  FunctionEntryInstruction entry;

  Function() { this = TMkFunction(entry) }

  string getName() { result = "Function_" + entry.getIndex() }

  string toString() { result = this.getName() }

  Location getLocation() { result = entry.getLocation() }
}
