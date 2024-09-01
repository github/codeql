/**
 * Provides classes for working with Go types.
 */

import go

/** A Go type. */
class Type extends @type {
  /** Gets the name of this type, if it has one. */
  string getName() { typename(this, result) }

  /**
   * Gets the underlying type of this type after any type aliases have been replaced
   * with their definition.
   */
  Type getUnderlyingType() { result = this }

  /**
   * Gets the entity associated with this type.
   */
  TypeEntity getEntity() { type_objects(this, result) }

  /** Gets the package in which this type is declared, if any. */
  Package getPackage() { result = this.getEntity().getPackage() }

  /**
   * Gets the qualified name of this type, if any.
   *
   * Only (defined) named types like `io.Writer` have a qualified name. Basic types like `int`,
   * pointer types like `*io.Writer`, and other composite types do not have a qualified name.
   */
  string getQualifiedName() { result = this.getEntity().getQualifiedName() }

  /**
   * Holds if this type is declared in a package with path `pkg` and has name `name`.
   *
   * Only (defined) named types like `io.Writer` have a qualified name. Basic types like `int`,
   * pointer types like `*io.Writer`, and other composite types do not have a qualified name.
   */
  predicate hasQualifiedName(string pkg, string name) {
    this.getEntity().hasQualifiedName(pkg, name)
  }

  /**
   * Holds if the method set of this type contains a method named `m` of type `t`.
   */
  predicate hasMethod(string m, SignatureType t) { t = this.getMethod(m).getType() }

  /**
   * Gets the method `m` belonging to the method set of this type, if any.
   *
   * Note that this predicate never has a result for struct types. Methods are associated
   * with the corresponding named type instead.
   */
  Method getMethod(string m) {
    result.getReceiverType() = this and
    result.getName() = m
  }

  /**
   * Gets the field `f` of this type.
   *
   * This includes fields promoted from an embedded field.
   */
  Field getField(string f) { result = this.getUnderlyingType().getField(f) }

  /**
   * Holds if this type implements interface `i`, that is, the method set of `i`
   * is contained in the method set of this type and any type restrictions are
   * satisfied.
   */
  pragma[nomagic]
  predicate implements(InterfaceType i) {
    if i = any(ComparableType comparable).getUnderlyingType()
    then this.implementsComparable()
    else this.implementsNotComparable(i)
  }

  /**
   * Holds if this type implements interface `i`, which is not the underlying
   * type of `comparable`. This predicate is needed to avoid non-monotonic
   * recursion.
   */
  private predicate implementsNotComparable(InterfaceType i) {
    (
      forall(TypeSetLiteralType tslit | tslit = i.getAnEmbeddedTypeSetLiteral() |
        tslit.includesType(this)
      ) and
      (
        hasNoMethods(i)
        or
        this.hasMethod(getExampleMethodName(i), _) and
        forall(string m, SignatureType t | interfaceHasMethodWithDeepUnaliasedType(i, m, t) |
          hasMethodWithDeepUnaliasedType(this, m, t)
        )
      )
    )
  }

  /**
   * Holds if this type implements `comparable`. This includes being
   * `comparable` itself, or the underlying type of `comparable`.
   */
  predicate implementsComparable() {
    exists(Type u | u = this.getUnderlyingType() |
      // Note that BasicType includes Invalidtype
      u instanceof BasicType
      or
      u instanceof PointerType
      or
      u instanceof ChanType
      or
      u instanceof StructType and
      forall(Type fieldtp | u.(StructType).hasField(_, fieldtp) | fieldtp.implementsComparable())
      or
      u instanceof ArrayType and u.(ArrayType).getElementType().implementsComparable()
      or
      // As of Go 1.20, any interface type satisfies the `comparable` constraint, even though comparison
      // may panic at runtime depending on the actual object's concrete type.
      // Look at git history here if you need the old definition.
      u instanceof InterfaceType
    )
  }

  /**
   * Holds if this type implements an interface that has the qualified name `pkg.name`,
   * that is, the method set of `pkg.name` is contained in the method set of this type
   * and any type restrictions are satisfied.
   */
  predicate implements(string pkg, string name) {
    exists(Type t | t.hasQualifiedName(pkg, name) | this.implements(t.getUnderlyingType()))
  }

  /**
   * Gets the pointer type that has this type as its base type.
   */
  PointerType getPointerType() { result.getBaseType() = this }

  /**
   * Gets this type with all aliases substituted for their underlying type.
   *
   * Note named types are not substituted.
   */
  Type getDeepUnaliasedType() { result = this }

  /**
   * Gets a pretty-printed representation of this type, including its structure where applicable.
   */
  string pp() { result = this.toString() }

  /**
   * Gets a basic textual representation of this type.
   */
  string toString() { result = this.getName() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getEntity().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    not exists(this.getEntity()) and
    filepath = "" and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }
}

pragma[nomagic]
private predicate hasMethodWithDeepUnaliasedType(Type t, string name, SignatureType unaliasedType) {
  exists(SignatureType methodType |
    t.hasMethod(name, methodType) and
    methodType.getDeepUnaliasedType() = unaliasedType
  )
}

pragma[nomagic]
private predicate interfaceHasMethodWithDeepUnaliasedType(
  InterfaceType i, string name, SignatureType unaliasedType
) {
  exists(SignatureType t | i.hasMethod(name, t) and t.getDeepUnaliasedType() = unaliasedType)
}

/** An invalid type. */
class InvalidType extends @invalidtype, Type {
  override string toString() { result = "invalid type" }
}

/** A basic type. */
class BasicType extends @basictype, Type { }

/** The normal boolean type or the literal boolean type */
class BoolType extends @booltype, BasicType { }

/** The `bool` type of a non-literal expression */
class BoolExprType extends @boolexprtype, BoolType {
  override string getName() { result = "bool" }
}

/** A numeric type such as `int` or `float64`. */
class NumericType extends @numerictype, BasicType {
  /**
   * Gets the implementation-independent size (in bits) of this numeric type.
   *
   * This predicate is not defined for types with an implementation-specific size, that is,
   * `uint`, `int` or `uintptr`.
   */
  int getSize() { none() }

  /**
   * Gets a possible implementation-specific size (in bits) of this numeric type.
   *
   * This predicate is not defined for `uintptr` since the language specification says nothing
   * about its size.
   */
  int getASize() { result = this.getSize() }
}

/** An integer type such as `int` or `uint64`. */
class IntegerType extends @integertype, NumericType { }

/** A signed integer type such as `int`. */
class SignedIntegerType extends @signedintegertype, IntegerType { }

/** The type `int`. */
class IntType extends @inttype, SignedIntegerType {
  override int getASize() { result = 32 or result = 64 }

  override string getName() { result = "int" }
}

/** The type `int8`. */
class Int8Type extends @int8type, SignedIntegerType {
  override int getSize() { result = 8 }

  override string getName() { result = "int8" }
}

/** The type `int16`. */
class Int16Type extends @int16type, SignedIntegerType {
  override int getSize() { result = 16 }

  override string getName() { result = "int16" }
}

/** The type `int32`. */
class Int32Type extends @int32type, SignedIntegerType {
  override int getSize() { result = 32 }

  override string getName() { result = "int32" }
}

/** The type `int64`. */
class Int64Type extends @int64type, SignedIntegerType {
  override int getSize() { result = 64 }

  override string getName() { result = "int64" }
}

/** An unsigned integer type such as `uint`. */
class UnsignedIntegerType extends @unsignedintegertype, IntegerType { }

/** The type `uint`. */
class UintType extends @uinttype, UnsignedIntegerType {
  override int getASize() { result = 32 or result = 64 }

  override string getName() { result = "uint" }
}

/** The type `uint8`. */
class Uint8Type extends @uint8type, UnsignedIntegerType {
  override int getSize() { result = 8 }

  override string getName() { result = "uint8" }
}

/** The type `uint16`. */
class Uint16Type extends @uint16type, UnsignedIntegerType {
  override int getSize() { result = 16 }

  override string getName() { result = "uint16" }
}

/** The type `uint32`. */
class Uint32Type extends @uint32type, UnsignedIntegerType {
  override int getSize() { result = 32 }

  override string getName() { result = "uint32" }
}

/** The type `uint64`. */
class Uint64Type extends @uint64type, UnsignedIntegerType {
  override int getSize() { result = 64 }

  override string getName() { result = "uint64" }
}

/** The type `uintptr`. */
class UintptrType extends @uintptrtype, BasicType {
  override string getName() { result = "uintptr" }
}

/** A floating-point type such as `float64`. */
class FloatType extends @floattype, NumericType { }

/** The type `float32`. */
class Float32Type extends @float32type, FloatType {
  override int getSize() { result = 32 }

  override string getName() { result = "float32" }
}

/** The type `float64`. */
class Float64Type extends @float64type, FloatType {
  override int getSize() { result = 64 }

  override string getName() { result = "float64" }
}

/** A complex-number type such as `complex64`. */
class ComplexType extends @complextype, NumericType { }

/** The type `complex64`. */
class Complex64Type extends @complex64type, ComplexType {
  override int getSize() { result = 64 }

  override string getName() { result = "complex64" }
}

/** The type `complex128`. */
class Complex128Type extends @complex128type, ComplexType {
  override int getSize() { result = 128 }

  override string getName() { result = "complex128" }
}

/** The normal string type or the literal string type */
class StringType extends @stringtype, BasicType { }

/** The `string` type of a non-literal expression */
class StringExprType extends @stringexprtype, StringType {
  override string getName() { result = "string" }
}

/** The type `unsafe.Pointer`. */
class UnsafePointerType extends @unsafepointertype, BasicType {
  override string getName() { result = "unsafe.Pointer" }
}

/** The type of a literal. */
class LiteralType extends @literaltype, BasicType { }

/** The type of a bool literal. */
class BoolLiteralType extends @boolliteraltype, LiteralType, BoolType {
  override string toString() { result = "bool literal" }
}

/** The type of an integer literal. */
class IntLiteralType extends @intliteraltype, LiteralType, SignedIntegerType {
  override string toString() { result = "int literal" }
}

/** The type of a rune literal. */
class RuneLiteralType extends @runeliteraltype, LiteralType, SignedIntegerType {
  override string toString() { result = "rune literal" }
}

/** The type of a float literal. */
class FloatLiteralType extends @floatliteraltype, LiteralType, FloatType {
  override string toString() { result = "float literal" }
}

/** The type of a complex literal. */
class ComplexLiteralType extends @complexliteraltype, LiteralType, ComplexType {
  override string toString() { result = "complex literal" }
}

/** The type of a string literal. */
class StringLiteralType extends @stringliteraltype, LiteralType, StringType {
  override string toString() { result = "string literal" }
}

/** The type of `nil`. */
class NilLiteralType extends @nilliteraltype, LiteralType {
  override string toString() { result = "nil literal" }
}

/** A composite type, that is, not a basic type. */
class CompositeType extends @compositetype, Type { }

/** A type that comes from a type parameter. */
class TypeParamType extends @typeparamtype, CompositeType {
  /** Gets the name of this type parameter type. */
  string getParamName() { typeparam(this, result, _, _, _) }

  /** Gets the constraint of this type parameter type. */
  Type getConstraint() { typeparam(this, _, result, _, _) }

  override InterfaceType getUnderlyingType() { result = this.getConstraint().getUnderlyingType() }

  /** Gets the parent object of this type parameter type. */
  TypeParamParentEntity getParent() { typeparam(this, _, _, result, _) }

  /** Gets the index of this type parameter type. */
  int getIndex() { typeparam(this, _, _, _, result) }

  override string pp() { result = this.getParamName() }

  /**
   * Gets a pretty-printed representation of this type including its constraint.
   */
  string ppWithConstraint() { result = this.getParamName() + " " + this.getConstraint().pp() }

  override string toString() { result = "type parameter type" }
}

/** An array type. */
class ArrayType extends @arraytype, CompositeType {
  /** Gets the element type of this array type. */
  Type getElementType() { element_type(this, result) }

  /** Gets the length of this array type as a string. */
  string getLengthString() { array_length(this, result) }

  /** Gets the length of this array type if it can be represented as a QL integer. */
  int getLength() { result = this.getLengthString().toInt() }

  override Package getPackage() { result = this.getElementType().getPackage() }

  override ArrayType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType() and
    result.getLengthString() = this.getLengthString()
  }

  override string pp() { result = "[" + this.getLength() + "]" + this.getElementType().pp() }

  override string toString() { result = "array type" }
}

/** A slice type. */
class SliceType extends @slicetype, CompositeType {
  /** Gets the element type of this slice type. */
  Type getElementType() { element_type(this, result) }

  override Package getPackage() { result = this.getElementType().getPackage() }

  override SliceType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }

  override string pp() { result = "[]" + this.getElementType().pp() }

  override string toString() { result = "slice type" }
}

/** A byte slice type */
class ByteSliceType extends SliceType {
  ByteSliceType() { this.getElementType() instanceof Uint8Type }
}

// Improve efficiency of matching a struct to its unaliased equivalent
// by unpacking the first 5 fields and tags, allowing a single join
// to strongly constrain the available candidates.
private predicate hasComponentTypeAndTag(StructType s, int i, string name, Type tp, string tag) {
  component_types(s, i, name, tp) and struct_tags(s, i, tag)
}

private newtype TOptStructComponent =
  MkNoComponent() or
  MkSomeComponent(string name, Type tp, string tag) { hasComponentTypeAndTag(_, _, name, tp, tag) }

private class OptStructComponent extends TOptStructComponent {
  OptStructComponent getWithDeepUnaliasedType() {
    this = MkNoComponent() and result = MkNoComponent()
    or
    exists(string name, Type tp, string tag |
      this = MkSomeComponent(name, tp, tag) and
      result = MkSomeComponent(name, tp.getDeepUnaliasedType(), tag)
    )
  }

  string toString() { result = "struct component" }
}

private class StructComponent extends MkSomeComponent {
  string toString() { result = "struct component" }

  predicate isComponentOf(StructType s, int i) {
    exists(string name, Type tp, string tag |
      hasComponentTypeAndTag(s, i, name, tp, tag) and
      this = MkSomeComponent(name, tp, tag)
    )
  }
}

pragma[nomagic]
predicate unpackStructType(
  StructType s, TOptStructComponent c0, TOptStructComponent c1, TOptStructComponent c2,
  TOptStructComponent c3, TOptStructComponent c4, int nComponents
) {
  nComponents = count(int i | component_types(s, i, _, _)) and
  (
    if nComponents >= 1
    then c0 = any(StructComponent sc | sc.isComponentOf(s, 0))
    else c0 = MkNoComponent()
  ) and
  (
    if nComponents >= 2
    then c1 = any(StructComponent sc | sc.isComponentOf(s, 1))
    else c1 = MkNoComponent()
  ) and
  (
    if nComponents >= 3
    then c2 = any(StructComponent sc | sc.isComponentOf(s, 2))
    else c2 = MkNoComponent()
  ) and
  (
    if nComponents >= 4
    then c3 = any(StructComponent sc | sc.isComponentOf(s, 3))
    else c3 = MkNoComponent()
  ) and
  (
    if nComponents >= 5
    then c4 = any(StructComponent sc | sc.isComponentOf(s, 4))
    else c4 = MkNoComponent()
  )
}

pragma[nomagic]
predicate unpackAndUnaliasStructType(
  StructType s, TOptStructComponent c0, TOptStructComponent c1, TOptStructComponent c2,
  TOptStructComponent c3, TOptStructComponent c4, int nComponents
) {
  exists(
    OptStructComponent c0a, OptStructComponent c1a, OptStructComponent c2a, OptStructComponent c3a,
    OptStructComponent c4a
  |
    unpackStructType(s, c0a, c1a, c2a, c3a, c4a, nComponents) and
    c0 = c0a.getWithDeepUnaliasedType() and
    c1 = c1a.getWithDeepUnaliasedType() and
    c2 = c2a.getWithDeepUnaliasedType() and
    c3 = c3a.getWithDeepUnaliasedType() and
    c4 = c4a.getWithDeepUnaliasedType()
  )
}

/** A struct type. */
class StructType extends @structtype, CompositeType {
  /**
   * Holds if this struct contains a field `name` with type `tp`;
   * `isEmbedded` is true if the field is embedded.
   *
   * Note that this predicate does not take promoted fields into account.
   */
  predicate hasOwnField(int i, string name, Type tp, boolean isEmbedded) {
    exists(string n | component_types(this, i, n, tp) |
      if n = ""
      then (
        isEmbedded = true and
        name = lookThroughPointerType(unalias(tp)).(NamedType).getName()
      ) else (
        isEmbedded = false and
        name = n
      )
    )
  }

  /**
   * Holds if this struct contains a field `name` with type `tp` and tag `tag`;
   * `isEmbedded` is true if the field is embedded.
   *
   * Note that this predicate does not take promoted fields into account.
   */
  predicate hasOwnFieldWithTag(int i, string name, Type tp, boolean isEmbedded, string tag) {
    this.hasOwnField(i, name, tp, isEmbedded) and
    (
      struct_tags(this, i, tag)
      or
      not struct_tags(this, i, _) and tag = ""
    )
  }

  /**
   * Get a field with the name `name`; `isEmbedded` is true if the field is embedded.
   *
   * Note that this does not take promoted fields into account.
   */
  Field getOwnField(string name, boolean isEmbedded) {
    result.getDeclaringType() = this and
    result.getName() = name and
    this.hasOwnField(_, name, _, isEmbedded)
  }

  /**
   * Holds if there is an embedded field at `depth`, with either type `tp` or a pointer to `tp`.
   */
  private predicate hasEmbeddedField(Type tp, int depth) {
    exists(Field f | this.hasFieldCand(_, f, depth, true) |
      tp = f.getType() or
      tp = f.getType().(PointerType).getBaseType()
    )
  }

  /**
   * Gets a field of `embeddedParent`, which is then embedded into this struct type.
   */
  Field getFieldOfEmbedded(Field embeddedParent, string name, int depth, boolean isEmbedded) {
    // embeddedParent is a field of 'this' at depth 'depth - 1'
    this.hasFieldCand(_, embeddedParent, depth - 1, true) and
    // embeddedParent's type has the result field. Note that it is invalid Go
    // to have an embedded field with a named type whose underlying type is a
    // pointer, so we don't have to have
    // `lookThroughPointerType(embeddedParent.getType().getUnderlyingType())`.
    result =
      lookThroughPointerType(embeddedParent.getType())
          .getUnderlyingType()
          .(StructType)
          .getOwnField(name, isEmbedded)
  }

  /**
   * Gets a method of `embeddedParent`, which is then embedded into this struct type.
   */
  Method getMethodOfEmbedded(Field embeddedParent, string name, int depth) {
    // embeddedParent is a field of 'this' at depth 'depth - 1'
    this.hasFieldCand(_, embeddedParent, depth - 1, true) and
    result.getName() = name and
    (
      result.getReceiverBaseType() = lookThroughPointerType(embeddedParent.getType())
      or
      methodhosts(result, embeddedParent.getType())
    )
  }

  private predicate hasFieldCand(string name, Field f, int depth, boolean isEmbedded) {
    f = this.getOwnField(name, isEmbedded) and depth = 0
    or
    f = this.getFieldOfEmbedded(_, name, depth, isEmbedded) and
    // If this is a cyclic field and this is not the first time we see this embedded field
    // then don't include it as a field candidate to avoid non-termination.
    not exists(Type t | lookThroughPointerType(t) = lookThroughPointerType(f.getType()) |
      this.hasOwnField(_, name, t, _)
    )
  }

  private predicate hasMethodCand(string name, Method m, int depth) {
    name = m.getName() and
    exists(Type embedded | this.hasEmbeddedField(embedded, depth - 1) |
      m.getReceiverType() = embedded
    )
  }

  /**
   * Holds if this struct contains a field `name` with type `tp`, possibly inside a (nested)
   * embedded field.
   */
  predicate hasField(string name, Type tp) {
    exists(int mindepth |
      mindepth = min(int depth | this.hasFieldCand(name, _, depth, _)) and
      tp = unique(Field f | this.hasFieldCand(name, f, mindepth, _)).getType()
    )
  }

  override Field getField(string name) { result = this.getFieldAtDepth(name, _) }

  /**
   * Gets the field `f` with depth `depth` of this type.
   *
   * This includes fields promoted from an embedded field. It is not possible
   * to access a field that is shadowed by a promoted field with this function.
   * The number of embedded fields traversed to reach `f` is called its depth.
   * The depth of a field `f` declared in this type is zero.
   */
  Field getFieldAtDepth(string name, int depth) {
    depth = min(int depthCand | this.hasFieldCand(name, _, depthCand, _)) and
    this.hasFieldCand(name, result, depth, _) and
    strictcount(Field f | this.hasFieldCand(name, f, depth, _)) = 1
  }

  Method getMethodAtDepth(string name, int depth) {
    depth = min(int depthCand | this.hasMethodCand(name, _, depthCand)) and
    result = unique(Method m | this.hasMethodCand(name, m, depth))
  }

  override predicate hasMethod(string name, SignatureType tp) {
    exists(int mindepth |
      mindepth = min(int depth | this.hasMethodCand(name, _, depth)) and
      tp = unique(Method m | this.hasMethodCand(name, m, mindepth)).getType()
    )
  }

  private StructType getDeepUnaliasedTypeCandidate() {
    exists(
      OptStructComponent c0, OptStructComponent c1, OptStructComponent c2, OptStructComponent c3,
      OptStructComponent c4, int nComponents
    |
      unpackAndUnaliasStructType(this, c0, c1, c2, c3, c4, nComponents) and
      unpackStructType(result, c0, c1, c2, c3, c4, nComponents)
    )
  }

  private predicate isDeepUnaliasedTypeUpTo(StructType unaliased, int i) {
    // Note we must use component_types not hasOwnField here because component_types may specify
    // interface-in-struct embedding, but hasOwnField does not return such members.
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 5 and
    (
      i = 5 or
      this.isDeepUnaliasedTypeUpTo(unaliased, i - 1)
    ) and
    exists(string name, Type tp, string tag | hasComponentTypeAndTag(this, i, name, tp, tag) |
      hasComponentTypeAndTag(unaliased, i, name, tp.getDeepUnaliasedType(), tag)
    )
  }

  override StructType getDeepUnaliasedType() {
    result = this.getDeepUnaliasedTypeCandidate() and
    exists(int nComponents | nComponents = count(int i | component_types(this, i, _, _)) |
      this.isDeepUnaliasedTypeUpTo(result, nComponents - 1)
      or
      nComponents <= 5
    )
  }

  language[monotonicAggregates]
  override string pp() {
    result =
      "struct { " +
        concat(int i, string name, Type tp, string tagToPrint |
          component_types(this, i, name, tp) and
          (
            tagToPrint = " `" + any(string tag | struct_tags(this, i, tag)) + "`"
            or
            tagToPrint = "" and not struct_tags(this, i, _)
          )
        |
          name + " " + tp.pp() + tagToPrint, "; " order by i
        ) + " }"
  }

  override string toString() { result = "struct type" }
}

/** A pointer type. */
class PointerType extends @pointertype, CompositeType {
  /** Gets the base type of this pointer type. */
  Type getBaseType() { base_type(this, result) }

  override Package getPackage() { result = this.getBaseType().getPackage() }

  override Method getMethod(string m) {
    result = CompositeType.super.getMethod(m)
    or
    // https://golang.org/ref/spec#Method_sets: "the method set of a pointer type *T is
    // the set of all methods declared with receiver *T or T"
    result = this.getBaseType().getMethod(m)
    or
    // promoted methods from embedded types
    exists(StructType s, Type embedded |
      s = this.getBaseType().(NamedType).getUnderlyingType() and
      s.hasOwnField(_, _, embedded, true) and
      // ensure that `m` can be promoted
      not s.hasOwnField(_, m, _, _) and
      not exists(Method m2 | m2.getReceiverBaseType() = this.getBaseType() and m2.getName() = m)
    |
      result = embedded.getMethod(m)
      or
      // If S contains an embedded field T, the method set of *S includes promoted methods with receiver T or T*
      not embedded instanceof PointerType and
      result = embedded.getPointerType().getMethod(m)
      or
      // If S contains an embedded field *T, the method set of *S includes promoted methods with receiver T or *T
      result = embedded.(PointerType).getBaseType().getMethod(m)
    )
  }

  override PointerType getDeepUnaliasedType() {
    result.getBaseType() = this.getBaseType().getDeepUnaliasedType()
  }

  override string pp() { result = "* " + this.getBaseType().pp() }

  override string toString() { result = "pointer type" }
}

/**
 * Gets the base type if `t` is a pointer type, otherwise `t` itself.
 */
Type lookThroughPointerType(Type t) {
  not t instanceof PointerType and
  result = t
  or
  result = t.(PointerType).getBaseType()
}

private newtype TTypeSetTerm =
  MkTypeSetTerm(TypeSetLiteralType tslit, int index) { component_types(tslit, index, _, _) }

/**
 * A term in a type set literal.
 *
 * Examples:
 * ```go
 * int
 * ~string
 * ```
 */
class TypeSetTerm extends TTypeSetTerm {
  boolean tilde;
  Type tp;

  TypeSetTerm() {
    exists(TypeSetLiteralType tslit, int index |
      this = MkTypeSetTerm(tslit, index) and
      (
        component_types(tslit, index, "", tp) and
        tilde = false
        or
        component_types(tslit, index, "~", tp) and
        tilde = true
      )
    )
  }

  /**
   * Holds if this term has a tilde in front of it.
   *
   * A tilde is used to indicate that the term refers to all types with a given
   * underlying type.
   */
  predicate hasTilde() { tilde = true }

  /** Gets the type of this term. */
  Type getType() { result = tp }

  /** Holds if `t` is in the type set of this term. */
  predicate includesType(Type t) { if tilde = false then t = tp else t.getUnderlyingType() = tp }

  /** Gets a pretty-printed representation of this term. */
  string pp() {
    exists(string tildeStr | if tilde = true then tildeStr = "~" else tildeStr = "" |
      result = tildeStr + tp.pp()
    )
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "type set term" }
}

private TypeSetTerm getIntersection(TypeSetTerm term1, TypeSetTerm term2) {
  term1.getType() = term2.getType() and
  if term1.hasTilde() then result = term2 else result = term1
}

/**
 * Gets a term in the intersection of type-set literals `a` and `b`.
 */
TypeSetTerm getTermInIntersection(TypeSetLiteralType a, TypeSetLiteralType b) {
  result = getIntersection(a.getATerm(), b.getATerm())
}

/**
 * A type set literal type, used when declaring a non-basic interface. May be a
 * single term, consisting of either a type or a tilde followed by a type, or a
 * union of terms.
 *
 *
 * Examples:
 *
 * ```go
 * int
 * ~string
 * int | ~string
 * ```
 */
class TypeSetLiteralType extends @typesetliteraltype, CompositeType {
  /** Gets the `i`th term in this type set literal. */
  TypeSetTerm getTerm(int i) { result = MkTypeSetTerm(this, i) }

  /** Gets a term in this type set literal. */
  TypeSetTerm getATerm() { result = this.getTerm(_) }

  /** Holds if `t` is in the type set of this type set literal. */
  predicate includesType(Type t) { this.getATerm().includesType(t) }

  /**
   * Gets the interface type of which this type-set literal is the only
   * element, if it exists.
   *
   * It exists if it has been explicitly defined, as in
   * `interface { int64 | uint64 }`, or if it has been implicitly created by
   * using the type set literal directly as the bound in a type parameter
   * declaration, as in `[T int64 | uint64]`.
   */
  InterfaceType getInterfaceType() {
    this = result.getDirectlyEmbeddedTypeSetLiteral(0) and
    not exists(result.getDirectlyEmbeddedTypeSetLiteral(1)) and
    hasNoMethods(result) and
    not exists(result.getADirectlyEmbeddedInterface())
  }

  language[monotonicAggregates]
  override string pp() {
    result = concat(TypeSetTerm t, int i | t = this.getTerm(i) | t.pp(), " | " order by i)
  }

  override string toString() { result = "type set literal type" }
}

private newtype TOptInterfaceComponent =
  MkNoIComponent() or
  MkSomeIComponent(string name, Type tp) { component_types(any(InterfaceType i), _, name, tp) }

private class OptInterfaceComponent extends TOptInterfaceComponent {
  OptInterfaceComponent getWithDeepUnaliasedType() {
    this = MkNoIComponent() and result = MkNoIComponent()
    or
    exists(string name, Type tp |
      this = MkSomeIComponent(name, tp) and
      result = MkSomeIComponent(name, tp.getDeepUnaliasedType())
    )
  }

  string toString() { result = "interface component" }
}

private class InterfaceComponent extends MkSomeIComponent {
  string toString() { result = "interface component" }

  predicate isComponentOf(InterfaceType intf, int i) {
    exists(string name, Type tp |
      component_types(intf, i, name, tp) and
      this = MkSomeIComponent(name, tp)
    )
  }
}

pragma[nomagic]
predicate unpackInterfaceType(
  InterfaceType intf, TOptInterfaceComponent c0, TOptInterfaceComponent c1,
  TOptInterfaceComponent c2, TOptInterfaceComponent c3, TOptInterfaceComponent c4,
  TOptInterfaceComponent e1, TOptInterfaceComponent e2, int nComponents, int nEmbeds
) {
  nComponents = count(int i | component_types(intf, i, _, _) and i >= 0) and
  nEmbeds = count(int i | component_types(intf, i, _, _) and i < 0) and
  (
    if nComponents >= 1
    then c0 = any(InterfaceComponent ic | ic.isComponentOf(intf, 0))
    else c0 = MkNoIComponent()
  ) and
  (
    if nComponents >= 2
    then c1 = any(InterfaceComponent ic | ic.isComponentOf(intf, 1))
    else c1 = MkNoIComponent()
  ) and
  (
    if nComponents >= 3
    then c2 = any(InterfaceComponent ic | ic.isComponentOf(intf, 2))
    else c2 = MkNoIComponent()
  ) and
  (
    if nComponents >= 4
    then c3 = any(InterfaceComponent ic | ic.isComponentOf(intf, 3))
    else c3 = MkNoIComponent()
  ) and
  (
    if nComponents >= 5
    then c4 = any(InterfaceComponent ic | ic.isComponentOf(intf, 4))
    else c4 = MkNoIComponent()
  ) and
  (
    if nEmbeds >= 1
    then e1 = any(InterfaceComponent ic | ic.isComponentOf(intf, -1))
    else e1 = MkNoIComponent()
  ) and
  (
    if nEmbeds >= 2
    then e2 = any(InterfaceComponent ic | ic.isComponentOf(intf, -2))
    else e2 = MkNoIComponent()
  )
}

pragma[nomagic]
predicate unpackAndUnaliasInterfaceType(
  InterfaceType intf, TOptInterfaceComponent c0, TOptInterfaceComponent c1,
  TOptInterfaceComponent c2, TOptInterfaceComponent c3, TOptInterfaceComponent c4,
  TOptInterfaceComponent e1, TOptInterfaceComponent e2, int nComponents, int nEmbeds
) {
  exists(
    OptInterfaceComponent c0a, OptInterfaceComponent c1a, OptInterfaceComponent c2a,
    OptInterfaceComponent c3a, OptInterfaceComponent c4a, OptInterfaceComponent e1a,
    OptInterfaceComponent e2a
  |
    unpackInterfaceType(intf, c0a, c1a, c2a, c3a, c4a, e1a, e2a, nComponents, nEmbeds) and
    c0 = c0a.getWithDeepUnaliasedType() and
    c1 = c1a.getWithDeepUnaliasedType() and
    c2 = c2a.getWithDeepUnaliasedType() and
    c3 = c3a.getWithDeepUnaliasedType() and
    c4 = c4a.getWithDeepUnaliasedType() and
    e1 = e1a.getWithDeepUnaliasedType() and
    e2 = e2a.getWithDeepUnaliasedType()
  )
}

/** An interface type. */
class InterfaceType extends @interfacetype, CompositeType {
  /** Gets the type of method `name` of this interface type. */
  Type getMethodType(string name) {
    // Note that negative indices correspond to embedded interfaces and type
    // set literals. Note also that methods coming from embedded interfaces
    // have already been included in `component_types`.
    exists(int i | i >= 0 | component_types(this, i, name, result))
  }

  /**
   * Holds if this interface type has a private method `name`,
   * with qualified name `qname` and type `type`.
   */
  predicate hasPrivateMethodWithQualifiedName(string name, string qname, Type type) {
    exists(int i | i >= 0 |
      component_types(this, i, name, type) and
      interface_private_method_ids(this, i, qname)
    )
  }

  override predicate hasMethod(string m, SignatureType t) { t = this.getMethodType(m) }

  /**
   * Holds if `tp` is a directly embedded type with index `index`.
   *
   * `tp` (or its underlying type) is either a type set literal type or an
   * interface type.
   */
  private predicate hasDirectlyEmbeddedType(int index, Type tp) {
    index >= 0 and component_types(this, -(index + 1), _, tp)
  }

  /**
   * Gets a type whose underlying type is an interface that is directly
   * embedded into this interface.
   *
   * Note that the methods of the embedded interface are already considered
   * as part of the method set of this interface.
   */
  Type getADirectlyEmbeddedInterface() {
    this.hasDirectlyEmbeddedType(_, result) and result.getUnderlyingType() instanceof InterfaceType
  }

  /**
   * Gets a type whose underlying type is an interface that is embedded into
   * this interface.
   *
   * Note that the methods of the embedded interface are already considered
   * as part of the method set of this interface.
   */
  Type getAnEmbeddedInterface() {
    result = this.getADirectlyEmbeddedInterface() or
    result =
      this.getADirectlyEmbeddedInterface()
          .getUnderlyingType()
          .(InterfaceType)
          .getAnEmbeddedInterface()
  }

  /**
   * Holds if this interface type is (the underlying type of) `comparable`, or
   * it embeds `comparable`.
   */
  predicate isOrEmbedsComparable() {
    this.getAnEmbeddedInterface() instanceof ComparableType or
    this = any(ComparableType comparable).getUnderlyingType()
  }

  /**
   * Gets the type set literal with index `index` from the definition of this
   * interface type.
   *
   * Note that the indexes are not contiguous.
   */
  TypeSetLiteralType getDirectlyEmbeddedTypeSetLiteral(int index) {
    this.hasDirectlyEmbeddedType(index, result)
  }

  /**
   * Gets a type set literal of this interface type.
   *
   * This includes type set literals of embedded interfaces.
   */
  TypeSetLiteralType getAnEmbeddedTypeSetLiteral() {
    result = this.getDirectlyEmbeddedTypeSetLiteral(_) or
    result =
      this.getADirectlyEmbeddedInterface()
          .getUnderlyingType()
          .(InterfaceType)
          .getAnEmbeddedTypeSetLiteral()
  }

  private InterfaceType getDeepUnaliasedTypeCandidate() {
    exists(
      OptInterfaceComponent c0, OptInterfaceComponent c1, OptInterfaceComponent c2,
      OptInterfaceComponent c3, OptInterfaceComponent c4, OptInterfaceComponent e1,
      OptInterfaceComponent e2, int nComponents, int nEmbeds
    |
      unpackAndUnaliasInterfaceType(this, c0, c1, c2, c3, c4, e1, e2, nComponents, nEmbeds) and
      unpackInterfaceType(result, c0, c1, c2, c3, c4, e1, e2, nComponents, nEmbeds)
    )
  }

  private predicate hasDeepUnaliasedComponentTypesUpTo(InterfaceType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 5 and
    (
      i = 5 or
      this.hasDeepUnaliasedComponentTypesUpTo(unaliased, i - 1)
    ) and
    exists(string name, Type tp | component_types(this, i, name, tp) |
      component_types(unaliased, i, name, tp.getDeepUnaliasedType())
    )
  }

  private predicate hasDeepUnaliasedEmbeddedTypesUpTo(InterfaceType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 3 and
    (
      i = 3 or
      this.hasDeepUnaliasedEmbeddedTypesUpTo(unaliased, i - 1)
    ) and
    exists(string name, Type tp | component_types(this, -i, name, tp) |
      component_types(unaliased, -i, name, tp.getDeepUnaliasedType())
    )
  }

  override InterfaceType getDeepUnaliasedType() {
    result = this.getDeepUnaliasedTypeCandidate() and
    exists(int nComponents |
      nComponents = count(int i | component_types(this, i, _, _) and i >= 0)
    |
      this.hasDeepUnaliasedComponentTypesUpTo(result, nComponents - 1)
      or
      nComponents <= 5
    ) and
    exists(int nEmbeds | nEmbeds = count(int i | component_types(this, i, _, _) and i < 0) |
      // Note no -1 here, because the first embedded type is at -1
      this.hasDeepUnaliasedEmbeddedTypesUpTo(result, nEmbeds)
      or
      nEmbeds <= 2
    )
  }

  language[monotonicAggregates]
  override string pp() {
    exists(string comp, string sep1, string ts, string sep2, string meth |
      // Note that the interface type underlying `comparable` will be printed
      // as `interface { comparable }`, which is not entirely accurate, but
      // also better than anything else I can think of.
      (if this.isOrEmbedsComparable() then comp = " comparable" else comp = "") and
      ts =
        concat(TypeSetLiteralType tslit |
          tslit = this.getAnEmbeddedTypeSetLiteral()
        |
          " " + tslit.pp(), ";"
        ) and
      meth =
        concat(string name, Type tp |
          tp = this.getMethodType(name)
        |
          " " + name + " " + tp.pp(), ";" order by name
        ) and
      (if comp != "" and ts != "" then sep1 = ";" else sep1 = "") and
      if
        (comp != "" or ts != "") and
        meth != ""
      then sep2 = ";"
      else sep2 = ""
    |
      result = "interface {" + comp + sep1 + ts + sep2 + meth + " }"
    )
  }

  override string toString() { result = "interface type" }
}

// This predicate is needed for performance reasons.
pragma[noinline]
private predicate hasNoMethods(InterfaceType i) { not i.hasMethod(_, _) }

/**
 * A basic interface type.
 *
 * A basic interface is an interface that does not specify any type set
 * literals, and which does not embed any non-basic interfaces. The special
 * interface `comparable` is not a basic interface.
 */
class BasicInterfaceType extends InterfaceType {
  BasicInterfaceType() {
    not exists(this.getAnEmbeddedTypeSetLiteral()) and
    not this.isOrEmbedsComparable()
  }

  override string toString() { result = "basic interface type" }
}

/**
 * An empty interface type.
 *
 * Note that by we have to be careful to exclude the underlying type of
 * `comparable`. This is done by extending `BasicInterfaceType`.
 */
class EmptyInterfaceType extends BasicInterfaceType {
  EmptyInterfaceType() { hasNoMethods(this) }
}

/**
 * The predeclared `comparable` type.
 */
class ComparableType extends NamedType {
  ComparableType() { this.getName() = "comparable" }
}

pragma[nomagic]
private predicate unpackTupleType(TupleType tt, TOptType c0, TOptType c1, TOptType c2, int nComponents) {
  nComponents = count(int i | component_types(tt, i, _, _)) and
  (
    if nComponents >= 1
    then c0 = MkSomeType(tt.getComponentType(0))
    else c0 = MkNoType()
  ) and
  (
    if nComponents >= 2
    then c1 = MkSomeType(tt.getComponentType(1))
    else c1 = MkNoType()
  ) and
  (
    if nComponents >= 3
    then c2 = MkSomeType(tt.getComponentType(2))
    else c2 = MkNoType()
  )
}

pragma[nomagic]
private predicate unpackAndUnaliasTupleType(TupleType tt, TOptType c0, TOptType c1, TOptType c2, int nComponents) {
  exists(
    OptType c0a, OptType c1a, OptType c2a
  |
    unpackTupleType(tt, c0a, c1a, c2a, nComponents) and
    c0 = c0a.getDeepUnaliasedType() and
    c1 = c1a.getDeepUnaliasedType() and
    c2 = c2a.getDeepUnaliasedType()
  )
}

/** A tuple type. */
class TupleType extends @tupletype, CompositeType {
  /** Gets the `i`th component type of this tuple type. */
  Type getComponentType(int i) { component_types(this, i, _, result) }

  private TupleType getCandidateDeepUnaliasedType() {
    exists(
      OptType c0, OptType c1, OptType c2, int nComponents
    |
      unpackAndUnaliasTupleType(this, c0, c1, c2, nComponents) and
      unpackTupleType(result, c0, c1, c2, nComponents)
    )
  }

  private predicate isDeepUnaliasedTypeUpTo(TupleType tt, int i) {
    tt = this.getCandidateDeepUnaliasedType() and
    i >= 3 and
    (
      i = 3
      or
      this.isDeepUnaliasedTypeUpTo(tt, i - 1)
    ) and
    exists(Type tp | component_types(this, i, _, tp) |
      component_types(tt, i, _, tp.getDeepUnaliasedType())
    )
  }

  override TupleType getDeepUnaliasedType() {
    result = this.getCandidateDeepUnaliasedType() and
    exists(int nComponents | nComponents = count(int i | component_types(this, i, _, _)) |
      this.isDeepUnaliasedTypeUpTo(result, nComponents - 1)
      or
      nComponents <= 3
    )
  }

  language[monotonicAggregates]
  override string pp() {
    result =
      "(" + concat(int i, Type tp | tp = this.getComponentType(i) | tp.pp(), ", " order by i) + ")"
  }

  override string toString() { result = "tuple type" }
}

// Reasonably efficiently map from a signature type to its
// deep-unaliased equivalent, by using a single join for the leading 5 parameters
// and/or 3 results.
private newtype TOptType =
  MkNoType() or
  MkSomeType(Type tp)

private class OptType extends TOptType {
  OptType getDeepUnaliasedType() {
    exists(Type t | this = MkSomeType(t) | result = MkSomeType(t.getDeepUnaliasedType()))
    or
    this = MkNoType() and result = MkNoType()
  }

  string toString() {
    exists(Type t | this = MkSomeType(t) | result = t.toString())
    or
    this = MkNoType() and result = "no type"
  }
}

pragma[nomagic]
private predicate unpackSignatureType(
  SignatureType sig, OptType param0, OptType param1, OptType param2, OptType param3, OptType param4,
  int nParams, OptType result0, OptType result1, OptType result2, int nResults, boolean isVariadic
) {
  nParams = sig.getNumParameter() and
  nResults = sig.getNumResult() and
  (if nParams >= 1 then param0 = MkSomeType(sig.getParameterType(0)) else param0 = MkNoType()) and
  (if nParams >= 2 then param1 = MkSomeType(sig.getParameterType(1)) else param1 = MkNoType()) and
  (if nParams >= 3 then param2 = MkSomeType(sig.getParameterType(2)) else param2 = MkNoType()) and
  (if nParams >= 4 then param3 = MkSomeType(sig.getParameterType(3)) else param3 = MkNoType()) and
  (if nParams >= 5 then param4 = MkSomeType(sig.getParameterType(4)) else param4 = MkNoType()) and
  (if nResults >= 1 then result0 = MkSomeType(sig.getResultType(0)) else result0 = MkNoType()) and
  (if nResults >= 2 then result1 = MkSomeType(sig.getResultType(1)) else result1 = MkNoType()) and
  (if nResults >= 3 then result2 = MkSomeType(sig.getResultType(2)) else result2 = MkNoType()) and
  (if sig.isVariadic() then isVariadic = true else isVariadic = false)
}

pragma[nomagic]
private predicate unpackAndUnaliasSignatureType(
  SignatureType sig, OptType param0, OptType param1, OptType param2, OptType param3, OptType param4,
  int nParams, OptType result0, OptType result1, OptType result2, int nResults, boolean isVariadic
) {
  exists(
    OptType param0a, OptType param1a, OptType param2a, OptType param3a, OptType param4a,
    OptType result0a, OptType result1a, OptType result2a
  |
    unpackSignatureType(sig, param0a, param1a, param2a, param3a, param4a, nParams, result0a,
      result1a, result2a, nResults, isVariadic)
  |
    param0 = param0a.getDeepUnaliasedType() and
    param1 = param1a.getDeepUnaliasedType() and
    param2 = param2a.getDeepUnaliasedType() and
    param3 = param3a.getDeepUnaliasedType() and
    param4 = param4a.getDeepUnaliasedType() and
    result0 = result0a.getDeepUnaliasedType() and
    result1 = result1a.getDeepUnaliasedType() and
    result2 = result2a.getDeepUnaliasedType()
  )
}

/** A signature type. */
class SignatureType extends @signaturetype, CompositeType {
  /** Gets the `i`th parameter type of this signature type. */
  Type getParameterType(int i) { i >= 0 and component_types(this, i + 1, _, result) }

  /** Gets the `i`th result type of this signature type. */
  Type getResultType(int i) { i >= 0 and component_types(this, -(i + 1), _, result) }

  /** Gets the number of parameters specified by this signature. */
  int getNumParameter() { result = count(int i | exists(this.getParameterType(i))) }

  /** Gets the number of results specified by this signature. */
  int getNumResult() { result = count(int i | exists(this.getResultType(i))) }

  /** Holds if this signature type is variadic. */
  predicate isVariadic() { variadic(this) }

  private SignatureType getDeepUnaliasedTypeCandidate() {
    exists(
      OptType param0, OptType param1, OptType param2, OptType param3, OptType param4, int nParams,
      OptType result0, OptType result1, OptType result2, int nResults, boolean isVariadic
    |
      unpackAndUnaliasSignatureType(this, param0, param1, param2, param3, param4, nParams, result0,
        result1, result2, nResults, isVariadic) and
      unpackSignatureType(result, param0, param1, param2, param3, param4, nParams, result0, result1,
        result2, nResults, isVariadic)
    )
  }

  // These incremental recursive implementations only apply from parameter 5 or result 3
  // upwards to avoid constructing large squares of candidates -- the initial parameters
  // and results are taken care of by the candidate predicate.
  private predicate hasDeepUnaliasedParameterTypesUpTo(SignatureType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 5 and
    (i = 5 or this.hasDeepUnaliasedParameterTypesUpTo(unaliased, i - 1)) and
    unaliased.getParameterType(i) = this.getParameterType(i).getDeepUnaliasedType()
  }

  private predicate hasDeepUnaliasedResultTypesUpTo(SignatureType unaliased, int i) {
    unaliased = this.getDeepUnaliasedTypeCandidate() and
    i >= 3 and
    (i = 3 or this.hasDeepUnaliasedResultTypesUpTo(unaliased, i - 1)) and
    unaliased.getResultType(i) = this.getResultType(i).getDeepUnaliasedType()
  }

  override SignatureType getDeepUnaliasedType() {
    result = this.getDeepUnaliasedTypeCandidate() and
    exists(int nParams, int nResults |
      this.getNumParameter() = nParams and this.getNumResult() = nResults
    |
      (
        nParams <= 5
        or
        this.hasDeepUnaliasedParameterTypesUpTo(result, nParams - 1)
      ) and
      (
        nResults <= 3
        or
        this.hasDeepUnaliasedResultTypesUpTo(result, nResults - 1)
      )
    )
  }

  language[monotonicAggregates]
  override string pp() {
    result =
      "func(" +
        concat(int i, Type tp, string prefix |
          if i = this.getNumParameter() - 1 and this.isVariadic()
          then
            tp = this.getParameterType(i).(SliceType).getElementType() and
            prefix = "..."
          else (
            tp = this.getParameterType(i) and
            prefix = ""
          )
        |
          prefix + tp.pp(), ", " order by i
        ) + ") " + concat(int i, Type tp | tp = this.getResultType(i) | tp.pp(), ", " order by i)
  }

  override string toString() { result = "signature type" }
}

/** A map type. */
class MapType extends @maptype, CompositeType {
  /** Gets the key type of this map type. */
  Type getKeyType() { key_type(this, result) }

  /** Gets the value type of this map type. */
  Type getValueType() { element_type(this, result) }

  override MapType getDeepUnaliasedType() {
    result.getKeyType() = this.getKeyType().getDeepUnaliasedType() and
    result.getValueType() = this.getValueType().getDeepUnaliasedType()
  }

  override string pp() { result = "[" + this.getKeyType().pp() + "]" + this.getValueType().pp() }

  override string toString() { result = "map type" }
}

/** A channel type. */
class ChanType extends @chantype, CompositeType {
  /** Gets the element type of this channel type. */
  Type getElementType() { element_type(this, result) }

  /** Holds if this channel can send data. */
  predicate canSend() { none() }

  /** Holds if this channel can receive data. */
  predicate canReceive() { none() }
}

/** A channel type that can only send. */
class SendChanType extends @sendchantype, ChanType {
  override predicate canSend() { any() }

  override string pp() { result = "chan<- " + this.getElementType().pp() }

  override string toString() { result = "send-channel type" }

  override SendChanType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }
}

/** A channel type that can only receive. */
class RecvChanType extends @recvchantype, ChanType {
  override predicate canReceive() { any() }

  override string pp() { result = "<-chan " + this.getElementType().pp() }

  override string toString() { result = "receive-channel type" }

  override RecvChanType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }
}

/** A channel type that can both send and receive. */
class SendRecvChanType extends @sendrcvchantype, ChanType {
  override predicate canSend() { any() }

  override predicate canReceive() { any() }

  override string pp() { result = "chan " + this.getElementType().pp() }

  override string toString() { result = "send-receive-channel type" }

  override SendRecvChanType getDeepUnaliasedType() {
    result.getElementType() = this.getElementType().getDeepUnaliasedType()
  }
}

/** A named type. */
class NamedType extends @namedtype, CompositeType {
  /** Gets the type which this type is defined to be. */
  Type getBaseType() { underlying_type(this, result) }

  override Method getMethod(string m) {
    result = CompositeType.super.getMethod(m)
    or
    methodhosts(result, this) and
    result.getName() = m
    or
    // handle promoted methods
    exists(StructType s, Type embedded |
      s = this.getBaseType() and
      s.hasOwnField(_, _, embedded, true) and
      // ensure `m` can be promoted
      not s.hasOwnField(_, m, _, _) and
      not exists(Method m2 | m2.getReceiverBaseType() = this and m2.getName() = m)
    |
      // If S contains an embedded field T, the method set of S includes promoted methods with receiver T
      result = embedded.getMethod(m)
      or
      // If S contains an embedded field *T, the method set of S includes promoted methods with receiver T or *T
      result = embedded.(PointerType).getBaseType().getMethod(m)
    )
  }

  override Type getUnderlyingType() { result = this.getBaseType().getUnderlyingType() }
}

/** An alias type. */
class AliasType extends @typealias, CompositeType {
  /** Gets the aliased type (i.e. that appears on the RHS of the alias definition). */
  Type getRhs() { alias_rhs(this, result) }

  override Type getUnderlyingType() { result = unalias(this).getUnderlyingType() }

  override Type getDeepUnaliasedType() { result = unalias(this).getDeepUnaliasedType() }
}

/**
 * Gets the non-alias type at the end of the alias chain starting at `t`.
 *
 * If `t` is not an alias type then `result` is `t`.
 */
Type unalias(Type t) {
  not t instanceof AliasType and result = t
  or
  result = unalias(t.(AliasType).getRhs())
}

/**
 * A type that implements the builtin interface `error`.
 */
class ErrorType extends Type {
  ErrorType() { this.implements(Builtin::error().getType().getUnderlyingType()) }
}

/**
 * Gets the number of types with method `name`.
 */
bindingset[name]
int numberOfTypesWithMethodName(string name) { result = count(Type t | t.hasMethod(name, _)) }

/**
 * Gets the name of a method in the method set of `i`.
 *
 * This is used to restrict the set of interfaces to consider in the definition of `implements`,
 * so it does not matter which method name is chosen (we use the most unusual name the interface
 * requires; this is the most discriminating and so shrinks the search space the most).
 */
private string getExampleMethodName(InterfaceType i) {
  result = min(string m | i.hasMethod(m, _) | m order by numberOfTypesWithMethodName(m))
}
