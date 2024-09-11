/** Provides the `Attribute` class. */

private import CIL
private import semmle.code.csharp.Location as CS

/** An attribute to a declaration, such as a method, field, type or parameter. */
deprecated class Attribute extends Element, @cil_attribute {
  /** Gets the declaration this attribute is attached to. */
  Declaration getDeclaration() { cil_attribute(this, result, _) }

  /** Gets the constructor used to construct this attribute. */
  Method getConstructor() { cil_attribute(this, _, result) }

  /** Gets the type of this attribute. */
  Type getType() { result = this.getConstructor().getDeclaringType() }

  override string toString() { result = "[" + this.getType().getName() + "(...)]" }

  /** Gets the value of the `i`th argument of this attribute. */
  string getArgument(int i) { cil_attribute_positional_argument(this, i, result) }

  /** Gets the value of the named argument `name`. */
  string getNamedArgument(string name) { cil_attribute_named_argument(this, name, result) }

  /** Gets an argument of this attribute, if any. */
  string getAnArgument() { result = this.getArgument(_) or result = this.getNamedArgument(_) }

  override CS::Location getLocation() { result = this.getDeclaration().getLocation() }
}

/** A generic attribute to a declaration. */
deprecated class GenericAttribute extends Attribute {
  private ConstructedType type;

  GenericAttribute() { type = this.getType() }

  /** Gets the total number of type arguments. */
  int getNumberOfTypeArguments() { result = count(int i | cil_type_argument(type, i, _)) }

  /** Gets the `i`th type argument, if any. */
  Type getTypeArgument(int i) { result = type.getTypeArgument(i) }

  /** Get a type argument. */
  Type getATypeArgument() { result = this.getTypeArgument(_) }
}
