/**
 * INTERNAL: Do not use.
 * Provides support for type-references.
 */

import csharp

/**
 * INTERNAL: Do not use.
 * Gets a type reference for a given type `type`.
 * This is used for extensionals that can be supplied
 * as either type references or types.
 */
@type_or_ref getTypeRef(@type type) {
  result = type
  or
  type = result.(TypeRefs::TypeRef).getCanonicalType()
}

private module TypeRefs {
  /**
   * A typeref is a reference to a type in some assembly.
   * Often, a type can be present in multiple assemblies.
   */
  class TypeRef extends @typeref {
    string getName() { typerefs(this, result) }

    string toString() { result = getName() }

    Type getAType() { typeref_type(this, result) }

    /**
     * Gets the "canonical type" represented by a typeref.
     * This is because a typeref can reference multiple types, or a type with the same
     * fully qualified name can exist in multiple assemblies.
     * The canonical type is an arbitrarily chosen type from the list of candidate types.
     */
    Type getCanonicalType() {
      result = this.getAType() and
      isCanonicalType(result)
    }
  }

  /** Gets a location of a type. */
  private Location typeLocation(Type t) {
    type_location(t, result)
    or
    exists(Type decl | constructed_generic(decl, t) and result = typeLocation(decl))
  }

  /** Gets the "canonical location" for a type. A type has only one canonical location. */
  private Location canonicalTypeLocation(Type t) {
    result = typeLocation(t) and
    not locationIsBetter(result, typeLocation(t))
  }

  pragma[inline]
  private predicate locationIsBetter(Location typeLocation, Location betterLocation) {
    typeLocation.(Assembly).getFullName() < betterLocation.(Assembly).getFullName()
    or
    typeLocation instanceof Assembly and betterLocation instanceof SourceLocation
    or
    typeLocation.(SourceLocation).getFile().getAbsolutePath() <
      betterLocation.(SourceLocation).getFile().getAbsolutePath()
  }

  private predicate isCanonicalType(Type type) {
    not exists(TypeRef tr |
      type = tr.getAType() and
      locationIsBetter(canonicalTypeLocation(type), canonicalTypeLocation(tr.getAType()))
    )
  }
}
