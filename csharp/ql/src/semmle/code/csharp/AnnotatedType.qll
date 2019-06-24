/**
 * Provides predicates and classes for representing annotations on types, such as nullability information.
 *
 * Use an element's `getType()` predicate to access the standard type of the element, without regard
 * for annotations on the type. Use the corresponding `getAnnotatedType()` predicate to
 * get the annotated type, that includes this additional information.
 */

import csharp

private module Annotations {
  private newtype TAnnotation =
    TNotNullableRefType() or
    TNullableRefType() or
    TReadonlyRefType() or
    TRefType() or
    TOutType()

  /** An annotation on a type. */
  class TypeAnnotation extends TAnnotation {
    /** Holds if this string should prefix the type string. */
    predicate isPrefix() { none() }

    /** Holds if this string should suffix the type string. */
    predicate isSuffix() { none() }

    /** Gets the bit position in the bit-field. */
    abstract int getBit();

    /** Gets a string representation of this type annotation. */
    abstract string toString();
  }

  /** An annotation indicating that the type is not nullable. */
  class NonNullableRefType extends TypeAnnotation, TNotNullableRefType {
    override predicate isSuffix() { any() }

    override string toString() { result = "!" }

    override int getBit() { result = 2 }
  }

  /** An annotation indicating that the type is a nullable reference type. */
  class NullableRefType extends TypeAnnotation, TNullableRefType {
    override predicate isSuffix() { any() }

    override string toString() { result = "?" }

    override int getBit() { result = 3 }
  }

  /** An annotation indicating that the type is a readonly reference. */
  class ReadonlyRefType extends TypeAnnotation, TReadonlyRefType {
    override predicate isPrefix() { any() }

    override string toString() { result = "readonly " }

    override int getBit() { result = 4 }
  }

  /** An annotation indicating that the variable or return is by `ref`. */
  class RefTypeAnnotation extends TypeAnnotation, TRefType {
    override predicate isPrefix() { any() }

    override string toString() { result = "ref " }

    override int getBit() { result = 5 }
  }

  /** An annotation indicating that the parameter is `out`. */
  class OutType extends TypeAnnotation, TOutType {
    override predicate isPrefix() { any() }

    override string toString() { result = "out " }

    override int getBit() { result = 6 }
  }

  newtype TAnnotations =
    TAnnotationFlags(int flags) {
      flags = getElementTypeFlags(_) or
      flags = getTypeArgumentFlags(_, _) or
      flags = getTypeParameterFlags(_, _)
    }

  /** A set of annotations on a type. */
  class TypeAnnotations extends TAnnotations {
    int flags;

    TypeAnnotations() { this = TAnnotationFlags(flags) }

    /** Gets an annotation in this set of annotations. */
    TypeAnnotation getAnAnnotation() { isSet(result.getBit()) }

    private predicate isSet(int bit) {
      isBit(bit) and
      exists(int mask | mask = getBitMask(bit) | flags.bitAnd(mask) = mask)
    }

    /** Gets text to be displayed before the type. */
    string getTypePrefix() {
      result = concat(TypeAnnotation a |
          a = this.getAnAnnotation() and a.isPrefix()
        |
          a.toString(), "" order by a.getBit()
        )
    }

    /** Gets text to be displayed after the type. */
    string getTypeSuffix() {
      result = concat(TypeAnnotation a |
          a = this.getAnAnnotation() and a.isSuffix()
        |
          a.toString(), "" order by a.getBit()
        )
    }

    /** Gets a textual representation of this type annotation. */
    string toString() { result = getTypePrefix() + getTypeSuffix() }
  }

  /** Holds if the type annotations `annotations` apply to type `type` on element `element`. */
  predicate elementTypeAnnotations(
    @has_type_annotation element, Type type, TypeAnnotations annotations
  ) {
    annotations = TAnnotationFlags(getElementTypeFlags(element)) and
    (
      type = element.(Assignable).getType()
      or
      type = element.(Callable).getReturnType()
      or
      type = element.(Expr).getType()
      or
      type = element.(ArrayType).getElementType()
      or
      type = element.(DelegateType).getReturnType()
    )
  }
}

/** Holds if `bit` is a valid bit to set in the bitmask. */
private predicate isBit(int bit) { bit = any(Annotations::TypeAnnotation a).getBit() }

private int getBitMask(int bit) {
  isBit(bit) and
  result = 1.bitShiftLeft(bit)
}

private int getElementTypeFlags(@has_type_annotation element) {
  result = sum(int b | type_annotation(element, b) | b)
}

private int getTypeArgumentFlags(ConstructedGeneric generic, int argument) {
  exists(generic.getTypeArgument(argument)) and
  result = sum(int b | type_argument_annotation(generic, argument, b) | b)
}

private int getTypeParameterFlags(TypeParameterConstraints constraints, Type type) {
  specific_type_parameter_annotation(constraints, getTypeRef(type), _) and
  result = sum(int b | specific_type_parameter_annotation(constraints, getTypeRef(type), b) | b)
}

private newtype TAnnotatedType =
  TAnnotatedTypeNullability(Type type, Annotations::TypeAnnotations annotations) {
    Annotations::elementTypeAnnotations(_, type, annotations)
    or
    exists(ConstructedGeneric c, int i |
      type = c.getTypeArgument(i) and
      annotations = Annotations::TAnnotationFlags(getTypeArgumentFlags(c, i))
    )
    or
    annotations = Annotations::TAnnotationFlags(getTypeParameterFlags(_, type))
  }

/** A type with additional information. */
class AnnotatedType extends TAnnotatedType {
  Type underlyingType;

  Annotations::TypeAnnotations annotations;

  AnnotatedType() { this = TAnnotatedTypeNullability(underlyingType, annotations) }

  /** Gets a textual representation of this annotated type. */
  string toString() {
    result = annotations.getTypePrefix() + underlyingType.toString() + annotations.getTypeSuffix()
  }

  /** Gets a textual representation of this annotated type, with full type information. */
  string toStringWithTypes() {
    result = annotations.getTypePrefix() + underlyingType.toStringWithTypes() +
        annotations.getTypeSuffix()
  }

  /** Gets the location of this annotated type, if any. */
  Location getLocation() { result = underlyingType.getLocation() }

  /**
   * Gets the underlying type, for example `string` in `string?`
   * Note that this might itself be a nullable value type (`System.Nullable`).
   */
  Type getUnderlyingType() { result = underlyingType }

  /** Gets the type annotation set of this annotated type. */
  Annotations::TypeAnnotations getAnnotations() { result = annotations }

  /** Gets a type annotation of this annotated type. */
  Annotations::TypeAnnotation getAnAnnotation() { result = getAnnotations().getAnAnnotation() }

  /** Holds if the type is a non-nullable reference. */
  predicate isNonNullableRefType() {
    this.getAnAnnotation() instanceof Annotations::NonNullableRefType
  }

  /** Holds if the type is a nullable reference. */
  predicate isNullableRefType() { this.getAnAnnotation() instanceof Annotations::NullableRefType }

  /** Holds if the type is a `ref`. */
  predicate isRef() { this.getAnAnnotation() instanceof Annotations::RefTypeAnnotation }

  /** Holds if the type is a `readonly ref`. */
  predicate isReadonlyRef() { this.getAnAnnotation() instanceof Annotations::ReadonlyRefType }

  /** Holds if the type is an `out`. */
  predicate isOut() { this.getAnAnnotation() instanceof Annotations::OutType }

  /** Holds if this annotated type applies to element `e`. */
  predicate appliesTo(Element e) {
    Annotations::elementTypeAnnotations(e, this.getUnderlyingType(), annotations)
  }

  /** Holds if this annotated type applies to type parameter constraints `constraints`. */
  predicate appliesToTypeConstraint(TypeParameterConstraints constraints) {
    annotations = Annotations::TAnnotationFlags(getTypeParameterFlags(constraints,
          this.getUnderlyingType()))
  }

  /** Holds if this annotated type applies to the `i`th type argument of constructed generic `g`. */
  predicate appliesToTypeArgument(ConstructedGeneric g, int i) {
    this.getUnderlyingType() = g.getTypeArgument(i) and
    this.getAnnotations() = Annotations::TAnnotationFlags(getTypeArgumentFlags(g, i))
  }
}
