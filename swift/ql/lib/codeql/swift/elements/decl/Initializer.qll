private import codeql.swift.generated.decl.Initializer
private import codeql.swift.elements.decl.Method
private import codeql.swift.elements.type.FunctionType
private import codeql.swift.elements.type.OptionalType

/**
 * An initializer of a class, struct, enum or protocol.
 */
class Initializer extends Generated::Initializer, Method {
  override string toString() { result = this.getSelfParam().getType() + "." + super.toString() }

  /** Holds if this initializer returns an optional type. Failable initializers are written as `init?`. */
  predicate isFailable() {
    this.getInterfaceType().(FunctionType).getResult().(FunctionType).getResult() instanceof
      OptionalType
  }
}
