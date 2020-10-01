/**
 * Provides predicates and classes for representing annotations on types, such as nullability information.
 *
 * Use an element's `getType()` predicate to access the standard type of the element, without regard
 * for annotations on the type. Use the corresponding `getAnnotatedType()` predicate to
 * get the annotated type, that includes this additional information.
 */

import csharp
private import TypeRef

private module Annotations {
  newtype TAnnotation =
    TReadonlyRefType() or
    TRefType() or
    TOutType() or
    TNullability(@nullability n)

  /** An annotation on a type. */
  class TypeAnnotation extends TAnnotation {
    /** Gets the bit position in the bit-field, also used to order the annotations in the text format. */
    int getBit() { none() }

    /** Gets the string prefixing the type, if any. */
    string getPrefix() { none() }

    /** Gets the string suffixing the type, if any. */
    string getSuffix() { none() }

    /** Gets a string representation of this type annotation. */
    string toString() { none() }
  }

  /** An annotation indicating that the type is a readonly reference. */
  class ReadonlyRefType extends TypeAnnotation, TReadonlyRefType {
    override string getPrefix() { result = "readonly " }

    override string toString() { result = "readonly ref" }

    override int getBit() { result = 4 }
  }

  /** An annotation indicating that the variable or return is by `ref`. */
  class RefTypeAnnotation extends TypeAnnotation, TRefType {
    override string getPrefix() { result = "ref " }

    override string toString() { result = "ref" }

    override int getBit() { result = 5 }
  }

  /** An annotation indicating that the parameter is `out`. */
  class OutType extends TypeAnnotation, TOutType {
    override string getPrefix() { result = "out " }

    override string toString() { result = "out" }

    override int getBit() { result = 6 }
  }

  /**
   * A structured type annotation representing type nullability.
   * For example, `IDictionary<string!,string?>?` has nullability `<!,?>?`.
   */
  class Nullability extends TypeAnnotation, TNullability {
    @nullability nullability;

    Nullability() { this = TNullability(nullability) }

    override string toString() { result = getMemberString() + getSelfNullability() }

    language[monotonicAggregates]
    private string getMemberString() {
      if nullability_parent(_, _, nullability)
      then
        result =
          "<" +
            concat(int i, Nullability child |
              nullability_parent(getNullability(child), i, nullability)
            |
              child.toString(), "," order by i
            ) + ">"
      else result = ""
    }

    /**
     * Gets a string representing the nullability, disregarding child nullability.
     * For example, `IDictionary<string!,string?>?` has nullability `?`.
     */
    string getSelfNullability() { none() }

    override int getBit() { none() }
  }

  @nullability getNullability(Nullability n) { n = TNullability(result) }

  private newtype TAnnotations =
    TAnnotationFlags(int flags, Nullability n) {
      exists(Element e |
        flags = getElementTypeFlags(e) and
        n = getElementNullability(e)
      )
    } or
    TAnnotationsNoFlags(Nullability n)

  /** A collection of type annotations. */
  class TypeAnnotations extends TAnnotations {
    /** Gets the nullability of this type annotation. */
    Nullability getNullability() {
      this = TAnnotationFlags(_, result)
      or
      this = TAnnotationsNoFlags(result)
    }

    /** Gets text to be displayed before the type. */
    string getTypePrefix() {
      result =
        concat(TypeAnnotation a | a = this.getAnAnnotation() | a.getPrefix(), "" order by a.getBit())
    }

    /** Gets text to be displayed after the type. */
    string getTypeSuffix() {
      result =
        concat(TypeAnnotation a | a = this.getAnAnnotation() | a.getSuffix(), "" order by a.getBit())
    }

    /** Gets a textual representation of this type annotation. */
    string toString() { result = getTypePrefix() + getNullability() + getTypeSuffix() }

    private int getFlags() { this = TAnnotationFlags(result, _) }

    private predicate isSet(int bit) {
      isBit(bit) and
      exists(int mask | mask = getBitMask(bit) | this.getFlags().bitAnd(mask) = mask)
    }

    /** Gets an annotation in this set of annotations. */
    TypeAnnotation getAnAnnotation() {
      isSet(result.getBit())
      or
      result = this.getNullability()
    }
  }

  /** Gets the nullability with no additional flags. */
  Nullability getNoFlagsNullability(TypeAnnotations annotations) {
    annotations = TAnnotationsNoFlags(result)
  }

  /**
   * Gets the `i`th child of type annotations `annotations`.
   * This is used to represent structured datatypes, where the structure
   * of the type annotation mirrors the structure of the annotated type.
   */
  bindingset[i]
  TypeAnnotations getChild(TypeAnnotations annotations, int i) {
    getNoFlagsNullability(result) = getChildNullability(annotations.getNullability(), i)
  }

  /**
   * Gets the `i`th child of nullability `n`.
   * Returns `n` if the nullability is not explicitly
   * stored in the database, since many type annotations will have consistent
   * nullability.
   */
  bindingset[i]
  Nullability getChildNullability(Nullability n, int i) {
    if nullability_parent(_, i, getNullability(n))
    then nullability_parent(getNullability(result), i, getNullability(n))
    else result = n
  }

  /**
   * A type that is "oblivious", either because nullability is not
   * applicable, because the code was not compiled in a nullable context, or
   * because the C# language version is less than 8.
   */
  class ObliviousNullability extends Nullability {
    ObliviousNullability() { nullability instanceof @oblivious }

    override string getSelfNullability() { result = "_" }
  }

  /**
   * A type that is "fully" oblivious. The type itself is oblivious
   * and all type arguments are oblivious.
   */
  class NoNullability extends ObliviousNullability {
    NoNullability() { not nullability_parent(_, _, nullability) }
  }

  /** A type with annotated nullablity, `?`. */
  class AnnotatedNullability extends Nullability {
    AnnotatedNullability() { nullability instanceof @annotated }

    override string getSelfNullability() { result = "?" }

    override int getBit() { result = 3 }

    override string getSuffix() { result = "?" }
  }

  /**
   * A ref type not annotated with `?` in a nullable context.
   */
  class NotAnnotatedNullability extends Nullability {
    NotAnnotatedNullability() { nullability instanceof @not_annotated }

    override string getSelfNullability() { result = "!" }

    override int getBit() { result = 2 }

    override string getSuffix() { result = "!" }
  }

  /** Holds if the type annotations `annotations` apply to type `type` on element `element`. */
  predicate elementTypeAnnotations(
    @has_type_annotation element, Type type, TypeAnnotations annotations
  ) {
    (
      annotations = TAnnotationFlags(getElementTypeFlags(element), getElementNullability(element))
      or
      not exists(getElementTypeFlags(element)) and
      getNoFlagsNullability(annotations) = getElementNullability(element)
    ) and
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
  result = strictsum(int b | type_annotation(element, b) | b)
}

private Annotations::Nullability getTypeParameterNullability(
  TypeParameterConstraints constraints, Type type
) {
  if specific_type_parameter_nullability(constraints, getTypeRef(type), _)
  then
    specific_type_parameter_nullability(constraints, getTypeRef(type),
      Annotations::getNullability(result))
  else (
    specific_type_parameter_constraints(constraints, getTypeRef(type)) and
    result instanceof Annotations::NoNullability
  )
}

private Annotations::Nullability getElementNullability(@has_type_annotation element) {
  if type_nullability(element, _)
  then type_nullability(element, Annotations::getNullability(result))
  else result instanceof Annotations::NoNullability
}

private newtype TAnnotatedType =
  TAnnotatedTypeNullability(Type type, Annotations::TypeAnnotations annotations) {
    Annotations::elementTypeAnnotations(_, type, annotations)
    or
    exists(AnnotatedConstructedType c, int i |
      type = c.getType().(ConstructedType).getTypeArgument(i) and
      annotations = Annotations::getChild(c.getAnnotations(), i)
    )
    or
    Annotations::getNoFlagsNullability(annotations) = getTypeParameterNullability(_, type)
    or
    // All types have at least one annotated type
    Annotations::getNoFlagsNullability(annotations) instanceof Annotations::NoNullability
    or
    exists(AnnotatedArrayType at |
      type = at.getType().(ArrayType).getElementType() and
      annotations = Annotations::getChild(at.getAnnotations(), 0)
    )
  }

/** A type with additional type information. */
class AnnotatedType extends TAnnotatedType {
  Type type;
  Annotations::TypeAnnotations annotations;

  AnnotatedType() { this = TAnnotatedTypeNullability(type, annotations) }

  /** Gets a textual representation of this annotated type. */
  string toString() {
    result =
      annotations.getTypePrefix() + getUnderlyingType().toStringWithTypes() +
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
  predicate isNonNullableRefType() { this.getAnAnnotation() instanceof Annotations::NoNullability }

  /** Holds if the type is a nullable reference, for example `string?`. */
  predicate isNullableRefType() {
    this.getAnAnnotation() instanceof Annotations::AnnotatedNullability
  }

  /** Holds if the type is a `ref`, for example the return type of `ref int F()`. */
  predicate isRef() { this.getAnAnnotation() instanceof Annotations::RefTypeAnnotation }

  /** Holds if the type is a `ref readonly`, for example the return type of `ref readonly int F()`. */
  predicate isReadonlyRef() { this.getAnAnnotation() instanceof Annotations::ReadonlyRefType }

  /** Holds if the type is an `out`, for example parameter `p` in `void F(out int p)`. */
  predicate isOut() { this.getAnAnnotation() instanceof Annotations::OutType }

  /** Holds if this annotated type applies to element `e`. */
  predicate appliesTo(Element e) { Annotations::elementTypeAnnotations(e, type, annotations) }

  /** Holds if this annotated type is the `i`th type argument of constructed generic 'g'. */
  predicate appliesToTypeArgument(ConstructedGeneric g, int i) {
    Annotations::getNoFlagsNullability(this.getAnnotations()) =
      Annotations::getChildNullability(getElementNullability(g), i) and
    this.getType() = g.getTypeArgument(i)
  }

  /** Holds if this annotated type applies to type parameter constraints `constraints`. */
  predicate appliesToTypeConstraint(TypeParameterConstraints constraints) {
    Annotations::getNoFlagsNullability(this.getAnnotations()) =
      getTypeParameterNullability(constraints, type)
  }
}

/** An array type with additional type information. */
class AnnotatedArrayType extends AnnotatedType {
  override ArrayType type;

  /** Gets the annotated element type of this array, for example `int?` in `int?[]`. */
  final AnnotatedType getElementType() {
    result.getType() = type.getElementType() and
    result.getAnnotations() = Annotations::getChild(this.getAnnotations(), 0)
  }

  private string getDimensionString(AnnotatedType elementType) {
    exists(AnnotatedType et, string res |
      et = getElementType() and
      res = type.getArraySuffix() and
      if et.getUnderlyingType() instanceof ArrayType and not et.isNullableRefType()
      then result = res + et.(AnnotatedArrayType).getDimensionString(elementType)
      else (
        result = res and elementType = et
      )
    )
  }

  override string toString() {
    exists(AnnotatedType elementType |
      result =
        annotations.getTypePrefix() + elementType.toString() + this.getDimensionString(elementType) +
          annotations.getTypeSuffix()
    )
  }
}

/** A constructed type with additional type information. */
class AnnotatedConstructedType extends AnnotatedType {
  override ConstructedType type;

  /** Gets the `i`th type argument of this constructed type. */
  AnnotatedType getTypeArgument(int i) {
    result.getType() = type.getTypeArgument(i) and
    result.getAnnotations() = Annotations::getChild(this.getAnnotations(), i)
  }

  override string toString() {
    result =
      annotations.getTypePrefix() + type.getUnboundGeneric().getNameWithoutBrackets() + "<" +
        this.getTypeArgumentsString() + ">" + annotations.getTypeSuffix()
  }

  language[monotonicAggregates]
  private string getTypeArgumentsString() {
    result =
      concat(int i |
        exists(this.getTypeArgument(i))
      |
        this.getTypeArgument(i).toString(), ", " order by i
      )
  }
}
