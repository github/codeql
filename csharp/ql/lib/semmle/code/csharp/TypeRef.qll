/**
 * INTERNAL: Do not use.
 *
 * Provides support for type-references.
 */

import csharp

/** A typeref is a reference to a type in some assembly. */
private class TypeRef extends @typeref {
  /** Gets the name of type being referenced. */
  string getName() { typerefs(this, result) }

  /** Gets a textual representation of this type reference. */
  string toString() { result = this.getName() }

  /** Gets the type being referenced. */
  Type getReferencedType() {
    typeref_type(this, result)
    or
    not typeref_type(this, _) and
    result.(UnknownType).isCanonical()
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Gets a type reference for a given type `type`.
 * This is used for extensionals that can be supplied
 * as either type references or types.
 */
TypeRef getTypeRef(Type type) { result.getReferencedType() = type }
