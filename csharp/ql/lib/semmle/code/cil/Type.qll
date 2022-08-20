/**
 * Provides classes for types and associated classes.
 */

import CIL
private import dotnet

/**
 * Something that contains other types.
 *
 * Either a type (`Type`), a method(`Method`), or a namespace (`Namespace`).
 */
class TypeContainer extends DotNet::NamedElement, @cil_type_container {
  /** Gets the parent of this type container, if any. */
  TypeContainer getParent() { none() }

  override string toStringWithTypes() { result = this.getLabel() }
}

/** A namespace. */
class Namespace extends DotNet::Namespace, TypeContainer, @namespace {
  override string toString() { result = this.getQualifiedName() }

  override Namespace getParent() { result = this.getParentNamespace() }

  override Namespace getParentNamespace() { parent_namespace(this, result) }

  override Location getLocation() { none() }
}

/**
 * A type.
 */
class Type extends DotNet::Type, Declaration, TypeContainer, @cil_type {
  override TypeContainer getParent() { cil_type(this, _, _, result, _) }

  override string getName() { cil_type(this, result, _, _, _) }

  override string toString() { result = this.getName() }

  /** Gets the containing type of this type, if any. */
  override Type getDeclaringType() { result = this.getParent() }

  /** Gets a member of this type, if any. */
  Member getAMember() { result.getDeclaringType() = this }

  /**
   * Gets the unbound generic type of this type, or `this` if the type
   * is already unbound.
   */
  Type getUnboundType() { cil_type(this, _, _, _, result) }

  override predicate hasQualifiedName(string qualifier, string name) {
    name = this.getName() and
    qualifier = this.getParent().getQualifiedName()
  }

  override Location getALocation() { cil_type_location(this.getUnboundDeclaration(), result) }

  /** Holds if this type is a class. */
  predicate isClass() { cil_class(this) }

  /** Holds if this type is an interface. */
  predicate isInterface() { cil_interface(this) }

  /**
   * Holds if this type is a member of the `System` namespace and has the name
   * `name`. This is the same as `getQualifiedName() = "System.<name>"`, but is
   * faster to compute.
   */
  predicate isSystemType(string name) {
    exists(Namespace system | this.getParent() = system |
      system.getName() = "System" and
      system.getParentNamespace().getName() = "" and
      name = this.getName()
    )
  }

  /** Holds if this type is an `enum`. */
  predicate isEnum() { this.getBaseClass().isSystemType("Enum") }

  /** Holds if this type is public. */
  predicate isPublic() { cil_public(this) }

  /** Holds if this type is private. */
  predicate isPrivate() { cil_private(this) }

  /** Gets the machine type used to store this type. */
  Type getUnderlyingType() { result = this }

  // Class hierarchy
  /** Gets the immediate base class of this class, if any. */
  Type getBaseClass() { cil_base_class(this, result) }

  /** Gets an immediate base interface of this class, if any. */
  Type getABaseInterface() { cil_base_interface(this, result) }

  /** Gets an immediate base type of this type, if any. */
  Type getABaseType() { result = this.getBaseClass() or result = this.getABaseInterface() }

  /** Gets an immediate subtype of this type, if any. */
  Type getASubtype() { result.getABaseType() = this }

  /** Gets the namespace directly containing this type, if any. */
  Namespace getNamespace() { result = this.getParent() }

  /**
   * Gets an index for implicit conversions. A type can be converted to another numeric type
   * of a higher index.
   */
  int getConversionIndex() { result = 0 }

  override Type getUnboundDeclaration() { cil_type(this, _, _, _, result) }
}
