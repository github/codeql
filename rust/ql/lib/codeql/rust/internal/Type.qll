/** Provides classes representing types without type arguments. */

private import rust
private import PathResolution
private import TypeInference
private import TypeMention
private import codeql.rust.internal.CachedStages

cached
newtype TType =
  TStruct(Struct s) { Stages::TypeInference::ref() } or
  TEnum(Enum e) or
  TTrait(Trait t) or
  TImpl(Impl i) or
  TArrayType() or // todo: add size?
  TRefType() or // todo: add mut?
  TTypeParamTypeParameter(TypeParam t) or
  TRefTypeParameter() or
  TSelfTypeParameter(Trait t)

/**
 * A type without type arguments.
 *
 * Note that this type includes things that, strictly speaking, are not Rust
 * types, such as traits and implementation blocks.
 */
abstract class Type extends TType {
  /** Gets the method `name` belonging to this type, if any. */
  pragma[nomagic]
  abstract Function getMethod(string name);

  /** Gets the struct field `name` belonging to this type, if any. */
  pragma[nomagic]
  abstract StructField getStructField(string name);

  /** Gets the `i`th tuple field belonging to this type, if any. */
  pragma[nomagic]
  abstract TupleField getTupleField(int i);

  /** Gets the `i`th type parameter of this type, if any. */
  abstract TypeParameter getTypeParameter(int i);

  /** Gets a type parameter of this type. */
  final TypeParameter getATypeParameter() { result = this.getTypeParameter(_) }

  /**
   * Gets an AST node that mentions a base type of this type, if any.
   *
   * Although Rust doesn't have traditional OOP-style inheritance, we model trait
   * bounds and `impl` blocks as base types. Example:
   *
   * ```rust
   * trait T1 {}
   *
   * trait T2 {}
   *
   * trait T3 : T1, T2 {}
   * //    ^^ `this`
   * //         ^^ `result`
   * //             ^^ `result`
   * ```
   */
  abstract TypeMention getABaseTypeMention();

  /** Gets a textual representation of this type. */
  abstract string toString();

  /** Gets the location of this type. */
  abstract Location getLocation();
}

abstract private class StructOrEnumType extends Type {
  abstract ItemNode asItemNode();

  final override Function getMethod(string name) {
    result = this.asItemNode().getASuccessor(name) and
    exists(ImplOrTraitItemNode impl | result = impl.getAnAssocItem() |
      impl instanceof Trait
      or
      impl.(ImplItemNode).isFullyParametric()
    )
  }

  /** Gets all of the fully parametric `impl` blocks that target this type. */
  final override ImplMention getABaseTypeMention() {
    this.asItemNode() = result.resolveSelfTy() and
    result.isFullyParametric()
  }
}

/** A struct type. */
class StructType extends StructOrEnumType, TStruct {
  private Struct struct;

  StructType() { this = TStruct(struct) }

  override ItemNode asItemNode() { result = struct }

  override StructField getStructField(string name) { result = struct.getStructField(name) }

  override TupleField getTupleField(int i) { result = struct.getTupleField(i) }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(struct.getGenericParamList().getTypeParam(i))
  }

  override string toString() { result = struct.getName().getText() }

  override Location getLocation() { result = struct.getLocation() }
}

/** An enum type. */
class EnumType extends StructOrEnumType, TEnum {
  private Enum enum;

  EnumType() { this = TEnum(enum) }

  override ItemNode asItemNode() { result = enum }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(enum.getGenericParamList().getTypeParam(i))
  }

  override string toString() { result = enum.getName().getText() }

  override Location getLocation() { result = enum.getLocation() }
}

/** A trait type. */
class TraitType extends Type, TTrait {
  private Trait trait;

  TraitType() { this = TTrait(trait) }

  override Function getMethod(string name) { result = trait.(ItemNode).getASuccessor(name) }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(trait.getGenericParamList().getTypeParam(i))
  }

  pragma[nomagic]
  private TypeReprMention getABoundMention() {
    result = trait.getTypeBoundList().getABound().getTypeRepr()
  }

  /** Gets any of the trait bounds of this trait. */
  override TypeMention getABaseTypeMention() { result = this.getABoundMention() }

  override string toString() { result = trait.toString() }

  override Location getLocation() { result = trait.getLocation() }
}

/**
 * An `impl` block type.
 *
 * Although `impl` blocks are not really types, we treat them as such in order
 * to be able to match type parameters from structs (or enums) with type
 * parameters from `impl` blocks. For example, in
 *
 * ```rust
 * struct S<T1>(T1);
 *
 * impl<T2> S<T2> {
 *   fn id(self) -> S<T2> { self }
 * }
 *
 * let x : S(i64) = S(42);
 * x.id();
 * ```
 *
 * we pretend that the `impl` block is a base type mention of the struct `S`,
 * with type argument `T1`. This means that from knowing that `x` has type
 * `S(i64)`, we can first match `i64` with `T1`, and then by matching `T1` with
 * `T2`, we can match `i64` with `T2`.
 *
 * `impl` blocks can also have base type mentions, namely the trait that they
 * implement (if any). Example:
 *
 * ```rust
 * struct S<T1>(T1);
 *
 * trait Trait<T2> {
 *   fn f(self) -> T2;
 *
 *   fn g(self) -> T2 { self.f() }
 * }
 *
 * impl<T3> Trait<T3> for S<T3> { // `Trait<T3>` is a base type mention of this `impl` block
 *   fn f(self) -> T3 {
 *     match self {
 *       S(x) => x
 *     }
 *   }
 * }
 *
 * let x : S(i64) = S(42);
 * x.g();
 * ```
 *
 * In this case we can match `i64` with `T1`, `T1` with `T3`, and `T3` with `T2`,
 * allowing us match `i64` with `T2`, and hence infer that the return type of `g`
 * is `i64`.
 */
class ImplType extends Type, TImpl {
  private Impl impl;

  ImplType() { this = TImpl(impl) }

  override Function getMethod(string name) { result = impl.(ItemNode).getASuccessor(name) }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(impl.getGenericParamList().getTypeParam(i))
  }

  /** Get the trait implemented by this `impl` block, if any. */
  override TypeMention getABaseTypeMention() { result = impl.getTrait() }

  override string toString() { result = impl.toString() }

  override Location getLocation() { result = impl.getLocation() }
}

/**
 * An array type.
 *
 * Array types like `[i64; 5]` are modeled as normal generic types
 * with a single type argument.
 */
class ArrayType extends Type, TArrayType {
  ArrayType() { this = TArrayType() }

  override Function getMethod(string name) { none() }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    none() // todo
  }

  override TypeMention getABaseTypeMention() { none() }

  override string toString() { result = "[]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A reference type.
 *
 * Reference types like `& i64` are modeled as normal generic types
 * with a single type argument.
 */
class RefType extends Type, TRefType {
  RefType() { this = TRefType() }

  override Function getMethod(string name) { none() }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TRefTypeParameter() and
    i = 0
  }

  override TypeMention getABaseTypeMention() { none() }

  override string toString() { result = "&" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A type parameter. */
abstract class TypeParameter extends Type {
  override TypeMention getABaseTypeMention() { none() }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) { none() }
}

/** A type parameter from source code. */
class TypeParamTypeParameter extends TypeParameter, TTypeParamTypeParameter {
  private TypeParam typeParam;

  TypeParamTypeParameter() { this = TTypeParamTypeParameter(typeParam) }

  TypeParam getTypeParam() { result = typeParam }

  override Function getMethod(string name) {
    // NOTE: If the type parameter has trait bounds, then this finds methods
    // on the bounding traits.
    result = typeParam.(ItemNode).getASuccessor(name)
  }

  override string toString() { result = typeParam.toString() }

  override Location getLocation() { result = typeParam.getLocation() }

  final override TypeMention getABaseTypeMention() {
    result = typeParam.getTypeBoundList().getABound().getTypeRepr()
  }
}

/** An implicit reference type parameter. */
class RefTypeParameter extends TypeParameter, TRefTypeParameter {
  override Function getMethod(string name) { none() }

  override string toString() { result = "&T" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * The implicit `Self` type parameter of a trait, that refers to the
 * implementing type of the trait.
 *
 * The Rust Reference on the implicit `Self` parameter:
 * https://doc.rust-lang.org/reference/items/traits.html#r-items.traits.self-param
 */
class SelfTypeParameter extends TypeParameter, TSelfTypeParameter {
  private Trait trait;

  SelfTypeParameter() { this = TSelfTypeParameter(trait) }

  Trait getTrait() { result = trait }

  override TypeMention getABaseTypeMention() { result = trait }

  override Function getMethod(string name) {
    // The `Self` type parameter is an implementation of the trait, so it has
    // all the trait's methods.
    result = trait.(ItemNode).getASuccessor(name)
  }

  override string toString() { result = "Self [" + trait.toString() + "]" }

  override Location getLocation() { result = trait.getLocation() }
}
