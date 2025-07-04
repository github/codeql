/** Provides classes representing types without type arguments. */

private import rust
private import PathResolution
private import TypeMention
private import codeql.rust.internal.CachedStages
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth

cached
newtype TType =
  TUnit() or
  TStruct(Struct s) { Stages::TypeInferenceStage::ref() } or
  TEnum(Enum e) or
  TTrait(Trait t) or
  TArrayType() or // todo: add size?
  TRefType() or // todo: add mut?
  TImplTraitType(ImplTraitTypeRepr impl) or
  TSliceType() or
  TTypeParamTypeParameter(TypeParam t) or
  TAssociatedTypeTypeParameter(TypeAlias t) { any(TraitItemNode trait).getAnAssocItem() = t } or
  TArrayTypeParameter() or
  TRefTypeParameter() or
  TSelfTypeParameter(Trait t) or
  TSliceTypeParameter()

/**
 * A type without type arguments.
 *
 * Note that this type includes things that, strictly speaking, are not Rust
 * types, such as traits and implementation blocks.
 */
abstract class Type extends TType {
  /** Gets the struct field `name` belonging to this type, if any. */
  pragma[nomagic]
  abstract StructField getStructField(string name);

  /** Gets the `i`th tuple field belonging to this type, if any. */
  pragma[nomagic]
  abstract TupleField getTupleField(int i);

  /** Gets the `i`th type parameter of this type, if any. */
  abstract TypeParameter getTypeParameter(int i);

  /** Gets the default type for the `i`th type parameter, if any. */
  TypeMention getTypeParameterDefault(int i) { none() }

  /** Gets a type parameter of this type. */
  final TypeParameter getATypeParameter() { result = this.getTypeParameter(_) }

  /** Gets a textual representation of this type. */
  abstract string toString();

  /** Gets the location of this type. */
  abstract Location getLocation();
}

/** The unit type `()`. */
class UnitType extends Type, TUnit {
  UnitType() { this = TUnit() }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) { none() }

  override string toString() { result = "()" }

  override Location getLocation() { result instanceof EmptyLocation }
}

abstract private class StructOrEnumType extends Type {
  abstract ItemNode asItemNode();
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

  override TypeMention getTypeParameterDefault(int i) {
    result = struct.getGenericParamList().getTypeParam(i).getDefaultType()
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

  override TypeMention getTypeParameterDefault(int i) {
    result = enum.getGenericParamList().getTypeParam(i).getDefaultType()
  }

  override string toString() { result = enum.getName().getText() }

  override Location getLocation() { result = enum.getLocation() }
}

/** A trait type. */
class TraitType extends Type, TTrait {
  private Trait trait;

  TraitType() { this = TTrait(trait) }

  /** Gets the underlying trait. */
  Trait getTrait() { result = trait }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(trait.getGenericParamList().getTypeParam(i))
  }

  override TypeMention getTypeParameterDefault(int i) {
    result = trait.getGenericParamList().getTypeParam(i).getDefaultType()
  }

  override string toString() { result = trait.toString() }

  override Location getLocation() { result = trait.getLocation() }
}

/**
 * An array type.
 *
 * Array types like `[i64; 5]` are modeled as normal generic types
 * with a single type argument.
 */
class ArrayType extends Type, TArrayType {
  ArrayType() { this = TArrayType() }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TArrayTypeParameter() and
    i = 0
  }

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

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TRefTypeParameter() and
    i = 0
  }

  override string toString() { result = "&" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * An [impl Trait][1] type.
 *
 * Each syntactic `impl Trait` type gives rise to its own type, even if
 * two `impl Trait` types have the same bounds.
 *
 * [1]: https://doc.rust-lang.org/reference/types/impl-trait.html
 */
class ImplTraitType extends Type, TImplTraitType {
  ImplTraitTypeRepr impl;

  ImplTraitType() { this = TImplTraitType(impl) }

  /** Gets the underlying AST node. */
  ImplTraitTypeRepr getImplTraitTypeRepr() { result = impl }

  /** Gets the function that this `impl Trait` belongs to. */
  abstract Function getFunction();

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) { none() }

  override string toString() { result = impl.toString() }

  override Location getLocation() { result = impl.getLocation() }
}

/**
 * An [impl Trait in return position][1] type, for example:
 *
 * ```rust
 * fn foo() -> impl Trait
 * ```
 *
 * [1]: https://doc.rust-lang.org/reference/types/impl-trait.html#r-type.impl-trait.return
 */
class ImplTraitReturnType extends ImplTraitType {
  private Function function;

  ImplTraitReturnType() { impl = function.getRetType().getTypeRepr() }

  override Function getFunction() { result = function }
}

/**
 * A slice type.
 *
 * Slice types like `[i64]` are modeled as normal generic types
 * with a single type argument.
 */
class SliceType extends Type, TSliceType {
  SliceType() { this = TSliceType() }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) {
    result = TSliceTypeParameter() and
    i = 0
  }

  override string toString() { result = "[]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A type parameter. */
abstract class TypeParameter extends Type {
  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) { none() }
}

private class RawTypeParameter = @type_param or @trait or @type_alias or @impl_trait_type_repr;

private predicate id(RawTypeParameter x, RawTypeParameter y) { x = y }

private predicate idOfRaw(RawTypeParameter x, int y) = equivalenceRelation(id/2)(x, y)

int idOfTypeParameterAstNode(AstNode node) { idOfRaw(Synth::convertAstNodeToRaw(node), result) }

/** A type parameter from source code. */
class TypeParamTypeParameter extends TypeParameter, TTypeParamTypeParameter {
  private TypeParam typeParam;

  TypeParamTypeParameter() { this = TTypeParamTypeParameter(typeParam) }

  TypeParam getTypeParam() { result = typeParam }

  override string toString() { result = typeParam.toString() }

  override Location getLocation() { result = typeParam.getLocation() }
}

/**
 * A type parameter corresponding to an associated type in a trait.
 *
 * We treat associated type declarations in traits as type parameters. E.g., a
 * trait such as
 * ```rust
 * trait ATrait {
 *   type AssociatedType;
 *   // ...
 * }
 * ```
 * is treated as if it was
 * ```rust
 * trait ATrait<AssociatedType> {
 *   // ...
 * }
 * ```
 */
class AssociatedTypeTypeParameter extends TypeParameter, TAssociatedTypeTypeParameter {
  private TypeAlias typeAlias;

  AssociatedTypeTypeParameter() { this = TAssociatedTypeTypeParameter(typeAlias) }

  TypeAlias getTypeAlias() { result = typeAlias }

  /** Gets the trait that contains this associated type declaration. */
  TraitItemNode getTrait() { result.getAnAssocItem() = typeAlias }

  override string toString() { result = typeAlias.getName().getText() }

  override Location getLocation() { result = typeAlias.getLocation() }
}

/** An implicit array type parameter. */
class ArrayTypeParameter extends TypeParameter, TArrayTypeParameter {
  override string toString() { result = "[T;...]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** An implicit reference type parameter. */
class RefTypeParameter extends TypeParameter, TRefTypeParameter {
  override string toString() { result = "&T" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** An implicit slice type parameter. */
class SliceTypeParameter extends TypeParameter, TSliceTypeParameter {
  override string toString() { result = "[T]" }

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

  override string toString() { result = "Self [" + trait.toString() + "]" }

  override Location getLocation() { result = trait.getLocation() }
}

/**
 * An [impl Trait in argument position][1] type, for example:
 *
 * ```rust
 * fn foo(arg: impl Trait)
 * ```
 *
 * Such types are syntactic sugar for type parameters, that is
 *
 * ```rust
 * fn foo<T: Trait>(arg: T)
 * ```
 *
 * so we model them as type parameters.
 *
 * [1]: https://doc.rust-lang.org/reference/types/impl-trait.html#r-type.impl-trait.param
 */
class ImplTraitTypeTypeParameter extends ImplTraitType, TypeParameter {
  private Function function;

  ImplTraitTypeTypeParameter() { impl = function.getAParam().getTypeRepr() }

  override Function getFunction() { result = function }

  override StructField getStructField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override TypeParameter getTypeParameter(int i) { none() }
}

/**
 * A type abstraction. I.e., a place in the program where type variables are
 * introduced.
 *
 * Example:
 * ```rust
 * impl<A, B> Foo<A, B> { }
 * //  ^^^^^^ a type abstraction
 * ```
 */
abstract class TypeAbstraction extends AstNode {
  abstract TypeParameter getATypeParameter();
}

final class ImplTypeAbstraction extends TypeAbstraction, Impl {
  override TypeParamTypeParameter getATypeParameter() {
    result.getTypeParam() = this.getGenericParamList().getATypeParam()
  }
}

final class TraitTypeAbstraction extends TypeAbstraction, Trait {
  override TypeParamTypeParameter getATypeParameter() {
    result.getTypeParam() = this.getGenericParamList().getATypeParam()
  }
}

final class TypeBoundTypeAbstraction extends TypeAbstraction, TypeBound {
  override TypeParamTypeParameter getATypeParameter() { none() }
}

final class SelfTypeBoundTypeAbstraction extends TypeAbstraction, Name {
  SelfTypeBoundTypeAbstraction() { any(Trait trait).getName() = this }

  override TypeParamTypeParameter getATypeParameter() { none() }
}

final class ImplTraitTypeReprAbstraction extends TypeAbstraction, ImplTraitTypeRepr {
  override TypeParamTypeParameter getATypeParameter() { none() }
}
