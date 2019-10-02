/**
 * Provides predicates and classes for representing annotations on types, such as nullability information.
 *
 * Use an element's `getType()` predicate to access the standard type of the element, without regard
 * for annotations on the type. Use the corresponding `getAnnotatedType()` predicate to
 * get the annotated type, that includes this additional information.
 */

import csharp

private module Annotations {
  newtype TAnnotation =
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
    TAnnotationFlags(int flags, Nullability n) {
      exists(Element e | flags = getElementTypeFlags(e) and n = getElementNullability(e))
      or
      flags = 0 // n is unbound
    }

  class TypeAnnotations extends TAnnotations {
    int flags;

    Nullability nullability;

    TypeAnnotations() { this = TAnnotationFlags(flags, nullability) }

    /** Gets the flags (as a bitset) of this type annotation. */
    int getFlags() { result = flags }

    /** Gets the nullability of this type annotation. */
    Nullability getNullability() { result = nullability }

    /**
     * Gets the `i`th "child" of this type annotation.
     * This is used to represent structured datatypes, where the structure
     * of the type annotation mirrors the structure of the annotated type.
     */
    bindingset[i]
    TypeAnnotations getChild(int i) {
      result.getFlags() = 0 and result.getNullability() = this.getNullability().getMember(i)
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

    private predicate isSet(int bit) {
      isBit(bit) and
      exists(int mask | mask = getBitMask(bit) | flags.bitAnd(mask) = mask)
    }

    /** Gets an annotation in this set of annotations. */
    TypeAnnotation getAnAnnotation() {
      isSet(result.getBit())
      or
      nullability instanceof AnnotatedNullability and result instanceof NullableRefType
      or
      nullability instanceof NotAnnotatedNullability and result instanceof NonNullableRefType
    }
  }

  /**
   * A structured type annotation representing type nullability.
   * For example, `IDictionary<string!,string?>?` has nullability `<!,?>?`.
   */
  class Nullability extends @nullability {
    string toString() { result = getMemberString() + getSelfNullability() }

    language[monotonicAggregates]
    private string getMemberString() {
      if nullability_member(this, _, _)
      then
        result = "<" +
            concat(int i, Nullability child |
              nullability_member(this, i, child)
            |
              child.toString(), "," order by i
            ) + ">"
      else result = ""
    }

    /**
     * Gets the `i`th member of this annotation.
     * Returns `this` if the nullability is not explicitly
     * stored in the database, since many type annotations will have consistent
     * nullability.
     */
    bindingset[i]
    Nullability getMember(int i) {
      if nullability_member(this, i, _) then nullability_member(this, i, result) else result = this
    }

    /** Gets a string representing the nullability. */
    abstract string getSelfNullability();
  }

  /**
   * A type that is "oblivious", either because nullability is not
   * applicable, because the code was not compiled in a nullable context, or
   * because the C# language version is less than 8.
   */
  class ObliviousNullability extends Nullability, @oblivious {
    override string getSelfNullability() { result = "_" }
  }

  /**
   * A type that is "fully" oblivious. The type itself is oblivious
   * and all type arguments are oblivious.
   */
  class NoNullability extends ObliviousNullability {
    NoNullability() { not nullability_member(this, _, _) }
  }

  /** A type with annotated nullablity, `?`. */
  class AnnotatedNullability extends Nullability, @annotated {
    override string getSelfNullability() { result = "?" }
  }

  /**
   * A ref type not annotated with `?` in a nullable context.
   */
  class NotAnnotatedNullability extends Nullability, @not_annotated {
    override string getSelfNullability() { result = "!" }
  }

  /** Holds if the type annotations `annotations` apply to type `type` on element `element`. */
  predicate elementTypeAnnotations(
    @has_type_annotation element, Type type, TypeAnnotations annotations
  ) {
    annotations = TAnnotationFlags(getElementTypeFlags(element), getElementNullability(element)) and
    (
      type = element.(Assignable).getType()
      or
      type = element.(Callable).getReturnType()
      or
      type = element.(Expr).getType()
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

private Annotations::Nullability getTypeParameterNullability(
  TypeParameterConstraints constraints, Type type
) {
  if specific_type_parameter_nullability(constraints, getTypeRef(type), _)
  then specific_type_parameter_nullability(constraints, getTypeRef(type), result)
  else (
    specific_type_parameter_constraints(constraints, type) and
    result instanceof Annotations::NoNullability
  )
}

private Annotations::Nullability getElementNullability(@has_type_annotation element) {
  if type_nullability(element, _)
  then type_nullability(element, result)
  else result instanceof Annotations::NoNullability
}

private newtype TAnnotatedType =
  TAnnotatedTypeNullability(Type type, Annotations::TypeAnnotations annotations) {
    Annotations::elementTypeAnnotations(_, type, annotations)
    or
    exists(AnnotatedConstructedType c, int i |
      type = c.getType().(ConstructedType).getTypeArgument(i) and
      annotations = c.getAnnotations().getChild(i)
    )
    or
    annotations.getFlags() = 0 and
    annotations.getNullability() = getTypeParameterNullability(_, type)
    or
    // All types exist as AnnotatedTypes with NoNullability.
    annotations.getFlags() = 0 and
    annotations.getNullability() instanceof Annotations::NoNullability
    or
    exists(AnnotatedArrayType at |
      type = at.getType().(ArrayType).getElementType() and
      annotations = at.getAnnotations().getChild(0)
    )
  }

/** A type with additional type information. */
class AnnotatedType extends TAnnotatedType {
  Type type;

  Annotations::TypeAnnotations annotations;

  AnnotatedType() { this = TAnnotatedTypeNullability(type, annotations) }

  /** Gets a textual representation of this annotated type. */
  string toString() {
    result = annotations.getTypePrefix() + getUnderlyingType().toStringWithTypes() +
        annotations.getTypeSuffix()
  }

  /** Gets the location of this annotated type. */
  Location getLocation() { result = type.getLocation() }

  /**
   * Gets the unannotated type, for example `string` in `string?`.
   * Note that this might be a nullable value type (`System.Nullable`).
   */
  Type getType() { result = type }

  /**
   * Gets the underlying type, for example `string` in `string?`
   * or `int` in `int?`. This also gets the underlying type of
   * nullable value types (`System.Nullable`).
   */
  final Type getUnderlyingType() {
    if type instanceof NullableType
    then result = type.(NullableType).getUnderlyingType()
    else result = type
  }

  /** Gets the type annotation set of this annotated type. */
  Annotations::TypeAnnotations getAnnotations() { result = annotations }

  /** Gets a type annotation of this annotated type. */
  private Annotations::TypeAnnotation getAnAnnotation() {
    result = getAnnotations().getAnAnnotation()
  }

  /** Holds if the type is a non-nullable reference, for example, `string` in a nullable-enabled context. */
  predicate isNonNullableRefType() {
    this.getAnAnnotation() instanceof Annotations::NonNullableRefType
  }

  /** Holds if the type is a nullable reference, for example `string?`. */
  predicate isNullableRefType() { this.getAnAnnotation() instanceof Annotations::NullableRefType }

  /** Holds if the type is a `ref`, for example the return type of `ref int F()`. */
  predicate isRef() { this.getAnAnnotation() instanceof Annotations::RefTypeAnnotation }

  /** Holds if the type is a `ref readonly`, for example the return type of `ref readonly int F()`. */
  predicate isReadonlyRef() { this.getAnAnnotation() instanceof Annotations::ReadonlyRefType }

  /** Holds if the type is an `out`, for example parameter `p` in `void F(out int p)`. */
  predicate isOut() { this.getAnAnnotation() instanceof Annotations::OutType }

  /** Holds if this annotated type applies to element `e`. */
  predicate appliesTo(Element e) { Annotations::elementTypeAnnotations(e, type, annotations) }

  /** Holds if this annotated type is the type argument 'i' of constructed generic 'g'. */
  predicate appliesToTypeArgument(ConstructedGeneric g, int i) {
    this.getAnnotations().getFlags() = 0 and
    this.getAnnotations().getNullability() = getElementNullability(g).getMember(i) and
    this.getType() = g.getTypeArgument(i)
  }

  /** Holds if this annotated type applies to type parameter constraints `constraints`. */
  predicate appliesToTypeConstraint(TypeParameterConstraints constraints) {
    this.getAnnotations().getFlags() = 0 and
    this.getAnnotations().getNullability() = getTypeParameterNullability(constraints, type)
  }
}

/** An array type with additional type information. */
class AnnotatedArrayType extends AnnotatedType {
  override ArrayType type;

  /** Gets the annotated element type of this array, for example `int?` in `int?[]`. */
  final AnnotatedType getElementType() {
    result.getType() = type.getElementType() and
    result.getAnnotations() = this.getAnnotations().getChild(0)
  }

  private string getDimensionString(AnnotatedType elementType) {
    exists(AnnotatedType et, string res |
      et = getElementType() and
      res = "[" + type.getRankString(0) + "]" and
      if et.getUnderlyingType() instanceof ArrayType and not et.isNullableRefType()
      then result = res + et.(AnnotatedArrayType).getDimensionString(elementType)
      else (
        result = res and elementType = et
      )
    )
  }

  override string toString() {
    exists(AnnotatedType elementType |
      result = annotations.getTypePrefix() + elementType.toString() +
          this.getDimensionString(elementType) + annotations.getTypeSuffix()
    )
  }
}

/** A constructed type with additional type information. */
class AnnotatedConstructedType extends AnnotatedType {
  override ConstructedType type;

  /** Gets the `i`th type argument of this constructed type. */
  AnnotatedType getTypeArgument(int i) {
    result.getType() = type.getTypeArgument(i) and
    result.getAnnotations() = this.getAnnotations().getChild(i)
  }

  override string toString() {
    result = annotations.getTypePrefix() + type.getUnboundGeneric().getNameWithoutBrackets() + "<" +
        this.getTypeArgumentsString() + ">" + annotations.getTypeSuffix()
  }

  language[monotonicAggregates]
  private string getTypeArgumentsString() {
    result = concat(int i |
        exists(this.getTypeArgument(i))
      |
        this.getTypeArgument(i).toString(), ", " order by i
      )
  }
}
