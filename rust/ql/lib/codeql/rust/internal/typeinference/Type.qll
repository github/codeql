/** Provides classes representing types without type arguments. */

private import rust
private import codeql.rust.internal.PathResolution
private import TypeMention
private import codeql.rust.internal.CachedStages
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.frameworks.stdlib.Stdlib
private import codeql.rust.frameworks.stdlib.Builtins as Builtins
private import AssociatedType

/**
 * Holds if a dyn trait type for the trait `trait` should have a type parameter
 * associated with `n`.
 *
 * A dyn trait type inherits the type parameters of the trait it implements.
 * That includes the type parameters corresponding to associated types.
 *
 * For instance in
 * ```rust
 * trait SomeTrait<A> {
 *   type AssociatedType;
 * }
 * ```
 * this predicate holds for the nodes `A` and `type AssociatedType`.
 */
private predicate dynTraitTypeParameter(Trait trait, AstNode n) {
  trait = any(DynTraitTypeRepr dt).getTrait() and
  n = [trait.getGenericParamList().getATypeParam().(AstNode), getTraitAssocType(trait)]
}

cached
newtype TType =
  TDataType(TypeItem ti) { Stages::TypeInferenceStage::ref() } or
  TTrait(Trait t) or
  TImplTraitType(ImplTraitTypeRepr impl) or
  TDynTraitType(Trait t) { t = any(DynTraitTypeRepr dt).getTrait() } or
  TNeverType() or
  TUnknownType() or
  TTypeParamTypeParameter(TypeParam t) or
  TAssociatedTypeTypeParameter(Trait trait, AssocType typeAlias) {
    getTraitAssocType(trait) = typeAlias
  } or
  TTypeParamAssociatedTypeTypeParameter(TypeParam tp, AssocType assoc) {
    tpAssociatedType(tp, assoc, _)
  } or
  TDynTraitTypeParameter(Trait trait, AstNode n) { dynTraitTypeParameter(trait, n) } or
  TImplTraitTypeParameter(ImplTraitTypeRepr implTrait, TypeParam tp) {
    implTraitTypeParam(implTrait, _, tp)
  } or
  TSelfTypeParameter(Trait t)

private predicate implTraitTypeParam(ImplTraitTypeRepr implTrait, int i, TypeParam tp) {
  implTrait.isInReturnPos() and
  tp = implTrait.getFunction().getGenericParamList().getTypeParam(i) and
  // Only include type parameters of the function that occur inside the impl
  // trait type.
  exists(Path path | path.getParentNode*() = implTrait and resolvePath(path) = tp)
}

/**
 * A type without type arguments.
 *
 * Note that this type includes things that, strictly speaking, are not Rust
 * types, such as traits and implementation blocks.
 */
abstract class Type extends TType {
  /**
   * Gets the `i`th positional type parameter of this type, if any.
   *
   * This excludes synthetic type parameters, such as associated types in traits.
   */
  abstract TypeParameter getPositionalTypeParameter(int i);

  /** Gets the default type for the `i`th type parameter, if any. */
  TypeRepr getTypeParameterDefault(int i) { none() }

  /**
   * Gets a type parameter of this type.
   *
   * This includes both positional type parameters and synthetic type parameters,
   * such as associated types in traits.
   */
  TypeParameter getATypeParameter() { result = this.getPositionalTypeParameter(_) }

  /** Gets a textual representation of this type. */
  abstract string toString();

  /** Gets the location of this type. */
  abstract Location getLocation();
}

/** A tuple type `(T, ...)`. */
class TupleType extends StructType {
  private int arity;

  pragma[nomagic]
  TupleType() { arity = this.getTypeItem().(Builtins::TupleType).getArity() }

  /** Gets the arity of this tuple type. */
  int getArity() { result = arity }

  override string toString() { result = "(T_" + arity + ")" }
}

pragma[nomagic]
TypeParamTypeParameter getTupleTypeParameter(int arity, int i) {
  result = any(TupleType t | t.getArity() = arity).getPositionalTypeParameter(i)
}

/** The unit type `()`. */
class UnitType extends TupleType {
  UnitType() { this.getArity() = 0 }

  override string toString() { result = "()" }
}

class DataType extends Type, TDataType {
  private TypeItem typeItem;

  DataType() { this = TDataType(typeItem) }

  /** Gets the type item that this data type represents. */
  TypeItem getTypeItem() { result = typeItem }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTypeParamTypeParameter(typeItem.getGenericParamList().getTypeParam(i))
  }

  override TypeRepr getTypeParameterDefault(int i) {
    result = typeItem.getGenericParamList().getTypeParam(i).getDefaultType()
  }

  override string toString() { result = typeItem.getName().getText() }

  override Location getLocation() { result = typeItem.getLocation() }
}

/** A struct type. */
class StructType extends DataType {
  private Struct struct;

  StructType() { struct = super.getTypeItem() }

  /** Gets the struct that this struct type represents. */
  override Struct getTypeItem() { result = struct }
}

/** An enum type. */
class EnumType extends DataType {
  private Enum enum;

  EnumType() { enum = super.getTypeItem() }

  /** Gets the enum that this enum type represents. */
  override Enum getTypeItem() { result = enum }
}

/** A union type. */
class UnionType extends DataType {
  private Union union;

  UnionType() { union = super.getTypeItem() }

  /** Gets the union that this union type represents. */
  override Union getTypeItem() { result = union }
}

/** A trait type. */
class TraitType extends Type, TTrait {
  private Trait trait;

  TraitType() { this = TTrait(trait) }

  /** Gets the underlying trait. */
  Trait getTrait() { result = trait }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTypeParamTypeParameter(trait.getGenericParamList().getTypeParam(i))
  }

  override TypeParameter getATypeParameter() {
    result = super.getATypeParameter()
    or
    result.(AssociatedTypeTypeParameter).getTrait() = trait
    or
    result.(SelfTypeParameter).getTrait() = trait
  }

  override TypeRepr getTypeParameterDefault(int i) {
    result = trait.getGenericParamList().getTypeParam(i).getDefaultType()
  }

  override string toString() { result = trait.toString() }

  override Location getLocation() { result = trait.getLocation() }
}

/**
 * An array type.
 *
 * Array types like `[i64; 5]` are modeled as normal generic types.
 */
class ArrayType extends StructType {
  pragma[nomagic]
  ArrayType() { this.getTypeItem() instanceof Builtins::ArrayType }

  override string toString() { result = "[;]" }
}

pragma[nomagic]
TypeParamTypeParameter getArrayTypeParameter() {
  result = any(ArrayType t).getPositionalTypeParameter(0)
}

abstract class RefType extends StructType { }

class RefMutType extends RefType {
  pragma[nomagic]
  RefMutType() { this.getTypeItem() instanceof Builtins::RefMutType }

  override string toString() { result = "&mut" }
}

class RefSharedType extends RefType {
  pragma[nomagic]
  RefSharedType() { this.getTypeItem() instanceof Builtins::RefSharedType }

  override string toString() { result = "&" }
}

pragma[nomagic]
RefType getRefType(boolean isMutable) {
  isMutable = true and result instanceof RefMutType
  or
  isMutable = false and result instanceof RefSharedType
}

pragma[nomagic]
TypeParamTypeParameter getRefTypeParameter(boolean isMutable) {
  result = getRefType(isMutable).getPositionalTypeParameter(0)
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

  override TypeParameter getPositionalTypeParameter(int i) {
    exists(TypeParam tp |
      implTraitTypeParam(impl, i, tp) and
      result = TImplTraitTypeParameter(impl, tp)
    )
  }

  override string toString() { result = impl.toString() }

  override Location getLocation() { result = impl.getLocation() }
}

class DynTraitType extends Type, TDynTraitType {
  Trait trait;

  DynTraitType() { this = TDynTraitType(trait) }

  override DynTraitTypeParameter getPositionalTypeParameter(int i) {
    result.getTypeParam() = trait.getGenericParamList().getTypeParam(i)
  }

  override DynTraitTypeParameter getATypeParameter() { result.getTrait() = trait }

  Trait getTrait() { result = trait }

  override string toString() { result = "dyn " + trait.getName().toString() }

  override Location getLocation() { result = trait.getLocation() }
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

  ImplTraitReturnType() { impl.isInReturnPos() and function = impl.getFunction() }

  override Function getFunction() { result = function }
}

/**
 * A slice type.
 *
 * Slice types like `[i64]` are modeled as normal generic types
 * with a single type argument.
 */
class SliceType extends StructType {
  pragma[nomagic]
  SliceType() { this.getTypeItem() instanceof Builtins::SliceType }

  override string toString() { result = "[]" }
}

pragma[nomagic]
TypeParamTypeParameter getSliceTypeParameter() {
  result = any(SliceType t).getPositionalTypeParameter(0)
}

class NeverType extends Type, TNeverType {
  override TypeParameter getPositionalTypeParameter(int i) { none() }

  override string toString() { result = "!" }

  override Location getLocation() { result instanceof EmptyLocation }
}

abstract class PtrType extends StructType { }

pragma[nomagic]
TypeParamTypeParameter getPtrTypeParameter() {
  result = any(PtrType t).getPositionalTypeParameter(0)
}

class PtrMutType extends PtrType {
  pragma[nomagic]
  PtrMutType() { this.getTypeItem() instanceof Builtins::PtrMutType }

  override string toString() { result = "*mut" }
}

class PtrConstType extends PtrType {
  pragma[nomagic]
  PtrConstType() { this.getTypeItem() instanceof Builtins::PtrConstType }

  override string toString() { result = "*const" }
}

/**
 * A special pseudo type used to indicate that the actual type may have to be
 * inferred by propagating type information back into call arguments.
 *
 * For example, in
 *
 * ```rust
 * let x = Default::default();
 * foo(x);
 * ```
 *
 * `Default::default()` is assigned this type, which allows us to infer the actual
 * type from the type of `foo`'s first parameter.
 *
 * Unknown types are not restricted to root types, for example in a call like
 * `Vec::new()` we assign this type at the type path corresponding to the type
 * parameter of `Vec`.
 *
 * Unknown types are used to restrict when type information is allowed to flow
 * into call arguments (including method call receivers), in order to avoid
 * combinatorial explosions.
 */
class UnknownType extends Type, TUnknownType {
  override TypeParameter getPositionalTypeParameter(int i) { none() }

  override string toString() { result = "(context typed)" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A type parameter. */
abstract class TypeParameter extends Type {
  override TypeParameter getPositionalTypeParameter(int i) { none() }

  abstract ItemNode getDeclaringItem();
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

  override ItemNode getDeclaringItem() { result.getTypeParam(_) = typeParam }

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
 * Furthermore, associated types of a supertrait induce a corresponding type
 * parameter in any subtraits. E.g., if we have a trait `SubTrait: ATrait` then
 * `SubTrait` also has a type parameter for the associated type
 * `AssociatedType`.
 */
class AssociatedTypeTypeParameter extends TypeParameter, TAssociatedTypeTypeParameter {
  private Trait trait;
  private TypeAlias typeAlias;

  AssociatedTypeTypeParameter() { this = TAssociatedTypeTypeParameter(trait, typeAlias) }

  TypeAlias getTypeAlias() { result = typeAlias }

  /** Gets the trait that contains this associated type declaration. */
  TraitItemNode getTrait() { result = trait }

  /**
   * Holds if this associated type type parameter corresponds directly its
   * trait, that is, it is not inherited from a supertrait.
   */
  predicate isDirect() { trait.(TraitItemNode).getAnAssocItem() = typeAlias }

  override ItemNode getDeclaringItem() { result = trait }

  override string toString() {
    result = typeAlias.getName().getText() + "[" + trait.getName().toString() + "]"
  }

  override Location getLocation() { result = typeAlias.getLocation() }
}

/**
 * A type parameter corresponding to an associated type accessed on a type
 * parameter, for example `T::AssociatedType` where `T` is a type parameter.
 *
 * These type parameters are created when a function signature accesses an
 * associated type on a type parameter. For example, in
 * ```rust
 * fn foo<T: SomeTrait>(arg: T::Assoc) { }
 * ```
 * we create a `TypeParamAssociatedTypeTypeParameter` for `Assoc` on `T` and the
 * mention `T::Assoc` resolves to this type parameter. If denoting the type
 * parameter by `T_Assoc` then the above function is treated as if it was
 * ```rust
 * fn foo<T: SomeTrait<Assoc = T_Assoc>, T_Assoc>(arg: T_Assoc) { }
 * ```
 */
class TypeParamAssociatedTypeTypeParameter extends TypeParameter,
  TTypeParamAssociatedTypeTypeParameter
{
  private TypeParam typeParam;
  private AssocType assoc;

  TypeParamAssociatedTypeTypeParameter() {
    this = TTypeParamAssociatedTypeTypeParameter(typeParam, assoc)
  }

  /** Gets the type parameter that this associated type is accessed on. */
  TypeParam getTypeParam() { result = typeParam }

  /** Gets the associated type alias. */
  AssocType getTypeAlias() { result = assoc }

  /** Gets a path that accesses this type parameter. */
  Path getAPath() { tpAssociatedType(typeParam, assoc, result) }

  override ItemNode getDeclaringItem() { result.getTypeParam(_) = typeParam }

  override string toString() {
    result =
      typeParam.toString() + "::" + assoc.getName().getText() + "[" +
        assoc.getTrait().getName().getText() + "]"
  }

  override Location getLocation() { result = typeParam.getLocation() }
}

/** Gets the associated type type-parameter corresponding directly to `typeAlias`. */
AssociatedTypeTypeParameter getAssociatedTypeTypeParameter(TypeAlias typeAlias) {
  result.isDirect() and result.getTypeAlias() = typeAlias
}

/** Gets the dyn type type-parameter corresponding directly to `typeAlias`. */
DynTraitTypeParameter getDynTraitTypeParameter(TypeAlias typeAlias) {
  result.getTraitTypeParameter() = getAssociatedTypeTypeParameter(typeAlias)
}

class DynTraitTypeParameter extends TypeParameter, TDynTraitTypeParameter {
  private Trait trait;
  private AstNode n;

  DynTraitTypeParameter() { this = TDynTraitTypeParameter(trait, n) }

  Trait getTrait() { result = trait }

  /** Gets the dyn trait type that this type parameter belongs to. */
  DynTraitType getDynTraitType() { result.getTrait() = this.getTrait() }

  /** Gets the `TypeParam` of this dyn trait type parameter, if any. */
  TypeParam getTypeParam() { result = n }

  /** Gets the `TypeAlias` of this dyn trait type parameter, if any. */
  TypeAlias getTypeAlias() { result = n }

  /** Gets the trait type parameter that this dyn trait type parameter corresponds to. */
  TypeParameter getTraitTypeParameter() {
    result.(TypeParamTypeParameter).getTypeParam() = n
    or
    result = TAssociatedTypeTypeParameter(trait, n)
  }

  private string toStringInner() {
    result = [this.getTypeParam().toString(), this.getTypeAlias().getName().toString()]
  }

  override ItemNode getDeclaringItem() { none() }

  override string toString() { result = "dyn(" + this.toStringInner() + ")" }

  override Location getLocation() { result = n.getLocation() }
}

class ImplTraitTypeParameter extends TypeParameter, TImplTraitTypeParameter {
  private TypeParam typeParam;
  private ImplTraitTypeRepr implTrait;

  ImplTraitTypeParameter() { this = TImplTraitTypeParameter(implTrait, typeParam) }

  TypeParam getTypeParam() { result = typeParam }

  ImplTraitTypeRepr getImplTraitTypeRepr() { result = implTrait }

  override ItemNode getDeclaringItem() { none() }

  override string toString() { result = "impl(" + typeParam.toString() + ")" }

  override Location getLocation() { result = typeParam.getLocation() }
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

  override ItemNode getDeclaringItem() { result = trait }

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

  override ItemNode getDeclaringItem() { none() }

  override Function getFunction() { result = function }

  override TypeParameter getPositionalTypeParameter(int i) { none() }
}

/**
 * Holds if `t` is a valid complex [`self` root type][1].
 *
 * [1]: https://doc.rust-lang.org/stable/reference/items/associated-items.html#r-items.associated.fn.method.self-ty
 */
pragma[nomagic]
predicate validSelfType(Type t) {
  t instanceof RefType
  or
  exists(Struct s | t = TDataType(s) |
    s instanceof BoxStruct or
    s instanceof RcStruct or
    s instanceof ArcStruct or
    s instanceof PinStruct
  )
}

/**
 * Holds if `root` is a valid complex [`self` root type][1], with type
 * parameter `tp`.
 *
 * [1]: https://doc.rust-lang.org/stable/reference/items/associated-items.html#r-items.associated.fn.method.self-ty
 */
pragma[nomagic]
predicate complexSelfRoot(Type root, TypeParameter tp) {
  validSelfType(root) and
  tp = root.getPositionalTypeParameter(0)
}
