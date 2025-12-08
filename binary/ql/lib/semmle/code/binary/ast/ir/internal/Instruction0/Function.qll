private import TranslatedFunction
private import Instruction
private import semmle.code.binary.ast.Location
private import BasicBlock
private import Type

newtype TFunction = TMkFunction(TranslatedFunction f)

class Function extends TFunction {
  TranslatedFunction f;

  Function() { this = TMkFunction(f) }

  string getName() { result = f.getName() }

  string toString() { result = this.getName() }

  FunEntryInstruction getEntryInstruction() { result = f.getEntry() }

  BasicBlock getEntryBlock() { result = f.getEntry().getBasicBlock() }

  Location getLocation() { result = this.getEntryInstruction().getLocation() }

  predicate isProgramEntryPoint() { f.isProgramEntryPoint() }

  predicate isPublic() { f.isPublic() }

  Type getDeclaringType() { result.getAFunction() = this }
}
