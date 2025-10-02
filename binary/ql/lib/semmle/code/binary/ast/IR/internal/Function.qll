private import TranslatedFunction
private import Instruction
private import semmle.code.binary.ast.Location

newtype TFunction = TMkFunction(TranslatedFunction f)

class Function extends TFunction {
  TranslatedFunction f;

  Function() { this = TMkFunction(f) }

  string getName() { result = f.getName() }

  string toString() { result = this.getName() }

  Instruction getEntryInstruction() { result = f.getEntry() }

  Location getLocation() { result = this.getEntryInstruction().getLocation() }

  predicate isProgramEntryPoint() { f.isProgramEntryPoint() }
}
