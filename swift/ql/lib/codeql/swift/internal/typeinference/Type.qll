/** Provides classes representing types without type arguments. */

import swift
private import swift as Swift
private import codeql.swift.generated.Raw
private import codeql.swift.generated.Synth

cached
newtype TType =
  TTypeDeclType(TypeDecl decl) {
    not decl instanceof AssociatedTypeDecl and
    // handled in `TSelfTypeParameter`
    not decl = any(GenericTypeParamDecl g | decl.getName() = "Self")
  } or
  TTupleType(int arity) { arity = [0 .. any(Swift::TupleType tt).getNumberOfTypes()] } or
  TAssociatedTypeTypeParameter(ProtocolDecl protocol, AssociatedTypeDecl associatedType) {
    associatedType.getDeclaringDecl().(ProtocolDecl).getABaseTypeDecl*() = protocol
  } or
  TSelfTypeParameter(ProtocolDecl protocol) or
  TTupleTypeTypeParameter(int arity, int index) {
    // todo: distinguish between tuple types with different element names?
    arity = [0 .. any(Swift::TupleType tt).getNumberOfTypes()] and
    index = [0 .. arity - 1]
  } or
  TUnknownType()

/**
 * A type without type arguments.
 */
abstract class Type extends TType {
  /**
   * Gets the `i`th positional type parameter of this type, if any.
   *
   * This excludes synthetic type parameters, such as associated types in protocols.
   */
  abstract TypeParameter getPositionalTypeParameter(int i);

  /** Gets the default type for the `i`th type parameter, if any. */
  TypeRepr getTypeParameterDefault(int i) { none() }

  /**
   * Gets a type parameter of this type.
   *
   * This includes both positional type parameters and synthetic type parameters,
   * such as associated types in protocols.
   */
  TypeParameter getATypeParameter() { result = this.getPositionalTypeParameter(_) }

  /** Gets a textual representation of this type. */
  abstract string toString();

  /** Gets the location of this type. */
  abstract Location getLocation();
}

class TypeDeclType extends Type, TTypeDeclType {
  TypeDecl decl;

  TypeDeclType() { this = TTypeDeclType(decl) }

  /** Gets the type declaration that this data type represents. */
  TypeDecl getDecl() { result = decl }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTypeDeclType(decl.(GenericTypeDecl).getGenericTypeParam(i))
  }

  override TypeParameter getATypeParameter() {
    result = super.getATypeParameter()
    or
    result = TAssociatedTypeTypeParameter(decl, _)
  }

  override TypeRepr getTypeParameterDefault(int i) {
    // todo: it appears Swift does support this
    none()
  }

  override string toString() { result = decl.getName() }

  override Location getLocation() { result = decl.getLocation() }
}

class StringType extends TypeDeclType {
  StringType() { decl.getName() = "String" }
}

class IntType extends TypeDeclType {
  IntType() { decl.getName() = "Int" }
}

class ArrayType extends TypeDeclType {
  ArrayType() { decl.getName() = "Array" }
}

class TupleType extends Type, TTupleType {
  int arity;

  TupleType() { this = TTupleType(arity) }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTupleTypeTypeParameter(arity, i)
  }

  override string toString() { result = "(T_" + arity + ")" }

  override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
}

class VoidType extends TupleType {
  VoidType() { arity = 0 }
}

/** A type parameter. */
abstract class TypeParameter extends Type {
  override TypeParameter getPositionalTypeParameter(int i) { none() }
}

class GenericTypeParamDeclTypeParameter extends TypeParameter, TypeDeclType {
  override GenericTypeParamDecl decl;

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TypeParameter.super.getPositionalTypeParameter(i)
  }
}

/**
 * A type parameter corresponding to an associated type in a protocol.
 *
 * We treat associated type declarations in protocols as type parameters. E.g., a
 * protocol such as
 *
 * ```swift
 * protocol Protocol {
 *   associatedtype AssociatedType
 *   // ...
 * }
 * ```
 *
 * is treated as if it was
 *
 * ```swift
 * protocol Protocol<AssociatedType> {
 *   // ...
 * }
 * ```
 *
 * Furthermore, associated types of a super protocol induce a corresponding type
 * parameter in any subprotocols. E.g., if we have a protocol `SubProtocol: AProtocol`
 * then `SubProtocol` also has a type parameter for the associated type
 * `AssociatedType`.
 */
class AssociatedTypeTypeParameter extends TypeParameter, TAssociatedTypeTypeParameter {
  ProtocolDecl protocol;
  AssociatedTypeDecl associatedType;

  AssociatedTypeTypeParameter() { this = TAssociatedTypeTypeParameter(protocol, associatedType) }

  AssociatedTypeDecl getAssociatedType() { result = associatedType }

  /** Gets the protocol that contains this associated type declaration. */
  ProtocolDecl getProtocol() { result = protocol }

  /**
   * Holds if this associated type type parameter corresponds directly its
   * protocol, that is, it is not inherited from a superprotocol.
   */
  predicate isDirect() { protocol = associatedType.getDeclaringDecl() }

  override string toString() {
    exists(string fromString, ProtocolDecl protocol2 |
      result = associatedType.getName() + "[" + protocol.getName() + fromString + "]" and
      protocol2 = associatedType.getDeclaringDecl() and
      if protocol = protocol2
      then fromString = ""
      else fromString = " (inherited from " + protocol2.getName() + ")"
    )
  }

  override Location getLocation() { result = associatedType.getLocation() }

  override TypeParameter getPositionalTypeParameter(int i) {
    // todo: it appears that associated types can also have type parameters
    none()
  }
}

/**
 * The implicit `Self` type parameter of a protocol that refers to the
 * implementing type of the protocol.
 */
class SelfTypeParameter extends TypeParameter, TSelfTypeParameter {
  private ProtocolDecl protocol;

  SelfTypeParameter() { this = TSelfTypeParameter(protocol) }

  ProtocolDecl getProtocol() { result = protocol }

  override string toString() { result = "Self [" + protocol.getName() + "]" }

  override Location getLocation() { result = protocol.getLocation() }
}

class TupleTypeTypeParameter extends TypeParameter, TTupleTypeTypeParameter {
  int arity;
  int index;

  TupleTypeTypeParameter() { this = TTupleTypeTypeParameter(arity, index) }

  override string toString() { result = "element " + index + " of tuple of arity " + arity }

  override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
}

/**
 * A special pseudo type used to indicate that the actual type may have to be
 * inferred by propagating type information top-down.
 *
 * For example, in
 *
 * ```swift
 * let numbers = [1, 2, 3]
 *
 * let strings = numbers.map { x in
 *     String(x)
 * }
 * ```
 *
 * `x` is assigned this type, which allows us to infer the actual type from the
 * type of `numbers` and the signature of `map`.
 *
 * Unknown types are used to restrict when type information is allowed to flow
 * top-down (including method call receivers), in order to avoid combinatorial
 * explosions.
 */
class UnknownType extends Type, TUnknownType {
  override TypeParameter getPositionalTypeParameter(int i) { none() }

  override string toString() { result = "(context typed)" }

  override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
}

private class RawTypeParameter =
  @generic_type_param_decl or @associated_type_decl or @protocol_decl;

private predicate id(RawTypeParameter x, RawTypeParameter y) { x = y }

private predicate idOfRaw(RawTypeParameter x, int y) = equivalenceRelation(id/2)(x, y)

int idOfTypeParameterAstNode(AstNode node) { idOfRaw(Synth::convertAstNodeToRaw(node), result) }
