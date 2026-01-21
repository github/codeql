private import Function
private import semmle.code.binary.ast.Location
private import TranslatedType

newtype TType = TMkType(TranslatedType t)

class Type extends TType {
  TranslatedType t;

  Type() { this = TMkType(t) }

  Function getAFunction() { result = TMkFunction(t.getAFunction()) }

  string toString() { result = this.getName() }

  string getFullName() { result = this.getNamespace() + "." + this.getName() }

  string getNamespace() { result = t.getNamespace() }

  string getName() { result = t.getName() }

  Location getLocation() { result = t.getLocation() }
}
