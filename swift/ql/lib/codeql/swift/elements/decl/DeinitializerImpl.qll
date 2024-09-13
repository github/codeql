private import codeql.swift.generated.decl.Deinitializer
private import codeql.swift.elements.decl.Method

/**
 * A deinitializer of a class.
 */
class Deinitializer extends Generated::Deinitializer, Method {
  override string toString() { result = this.getSelfParam().getType() + "." + super.toString() }
}
