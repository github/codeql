/**
 * INTERNAL: Do not use.
 *
 * Provides support for type-references.
 */

import csharp

/** A typeref is a reference to a type in some assembly. */
private class TypeRef extends @typeref {
  string getName() { typerefs(this, result) }

  string toString() { result = this.getName() }

  Type getReferencedType() {
    typeref_type(this, result)
    or
    not typeref_type(this, _) and
    result instanceof UnknownType
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Gets a type reference for a given type `type`.
 * This is used for extensionals that can be supplied
 * as either type references or types.
 */
@type_or_ref getTypeRef(Type type) {
  result = type
  or
  result.(TypeRef).getReferencedType() = type
}
