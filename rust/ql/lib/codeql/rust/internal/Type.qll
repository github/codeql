/** Provides classes representing types without type arguments. */

private import rust
private import PathResolution
private import TypeMention
private import codeql.rust.internal.CachedStages
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.frameworks.stdlib.Stdlib

/**
 * Holds if a dyn trait type should have a type parameter associated with `n`. A
 * dyn trait type inherits the type parameters of the trait it implements. That
 * includes the type parameters corresponding to associated types.
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
  (
    n = trait.getGenericParamList().getATypeParam() or
    n = trait.(TraitItemNode).getAnAssocItem().(TypeAlias)
  )
}

cached
newtype TType =
  TTuple(int arity) {
    arity =
      [
        any(TupleTypeRepr t).getNumberOfFields(),
        any(TupleExpr e).getNumberOfFields(),
        any(TuplePat p).getNumberOfFields()
      ] and
    Stages::TypeInferenceStage::ref()
  } or
  TStruct(Struct s) or
  TEnum(Enum e) or
  TTrait(Trait t) or
  TUnion(Union u) or
  TArrayType() or // todo: add size?
  TRefType() or // todo: add mut?
  TImplTraitType(ImplTraitTypeRepr impl) or
  TDynTraitType(Trait t) { t = any(DynTraitTypeRepr dt).getTrait() } or
  TSliceType() or
  TNeverType() or
  TPtrType() or
  TContextType() or
  TTupleTypeParameter(int arity, int i) { exists(TTuple(arity)) and i in [0 .. arity - 1] } or
  TTypeParamTypeParameter(TypeParam t) or
  TAssociatedTypeTypeParameter(TypeAlias t) { any(TraitItemNode trait).getAnAssocItem() = t } or
  TArrayTypeParameter() or
  TDynTraitTypeParameter(AstNode n) { dynTraitTypeParameter(_, n) } or
  TImplTraitTypeParameter(ImplTraitTypeRepr implTrait, TypeParam tp) {
    implTraitTypeParam(implTrait, _, tp)
  } or
  TRefTypeParameter() or
  TSelfTypeParameter(Trait t) or
  TSliceTypeParameter() or
  TPtrTypeParameter()

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
  TypeMention getTypeParameterDefault(int i) { none() }

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
class TupleType extends Type, TTuple {
  private int arity;

  TupleType() { this = TTuple(arity) }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTupleTypeParameter(arity, i)
  }

  /** Gets the arity of this tuple type. */
  int getArity() { result = arity }

  override string toString() { result = "(T_" + arity + ")" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** The unit type `()`. */
class UnitType extends TupleType {
  UnitType() { this = TTuple(0) }

  override string toString() { result = "()" }
}

/** A struct type. */
class StructType extends Type, TStruct {
  private Struct struct;

  StructType() { this = TStruct(struct) }

  /** Gets the struct that this struct type represents. */
  Struct getStruct() { result = struct }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTypeParamTypeParameter(struct.getGenericParamList().getTypeParam(i))
  }

  override TypeMention getTypeParameterDefault(int i) {
    result = struct.getGenericParamList().getTypeParam(i).getDefaultType()
  }

  override string toString() { result = struct.getName().getText() }

  override Location getLocation() { result = struct.getLocation() }
}

/** An enum type. */
class EnumType extends Type, TEnum {
  private Enum enum;

  EnumType() { this = TEnum(enum) }

  override TypeParameter getPositionalTypeParameter(int i) {
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

  override TypeMention getTypeParameterDefault(int i) {
    result = trait.getGenericParamList().getTypeParam(i).getDefaultType()
  }

  override string toString() { result = trait.toString() }

  override Location getLocation() { result = trait.getLocation() }
}

/** A union type. */
class UnionType extends Type, TUnion {
  private Union union;

  UnionType() { this = TUnion(union) }

  /** Gets the union that this union type represents. */
  Union getUnion() { result = union }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTypeParamTypeParameter(union.getGenericParamList().getTypeParam(i))
  }

  override TypeMention getTypeParameterDefault(int i) {
    result = union.getGenericParamList().getTypeParam(i).getDefaultType()
  }

  override string toString() { result = union.getName().getText() }

  override Location getLocation() { result = union.getLocation() }
}

/**
 * An array type.
 *
 * Array types like `[i64; 5]` are modeled as normal generic types
 * with a single type argument.
 */
class ArrayType extends Type, TArrayType {
  ArrayType() { this = TArrayType() }

  override TypeParameter getPositionalTypeParameter(int i) {
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

  override TypeParameter getPositionalTypeParameter(int i) {
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
    result = TDynTraitTypeParameter(trait.getGenericParamList().getTypeParam(i))
  }

  override TypeParameter getATypeParameter() {
    result = super.getATypeParameter()
    or
    exists(AstNode n |
      dynTraitTypeParameter(trait, n) and
      result = TDynTraitTypeParameter(n)
    )
  }

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
class SliceType extends Type, TSliceType {
  SliceType() { this = TSliceType() }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TSliceTypeParameter() and
    i = 0
  }

  override string toString() { result = "[]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class NeverType extends Type, TNeverType {
  override TypeParameter getPositionalTypeParameter(int i) { none() }

  override string toString() { result = "!" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class PtrType extends Type, TPtrType {
  override TypeParameter getPositionalTypeParameter(int i) {
    i = 0 and
    result = TPtrTypeParameter()
  }

  override string toString() { result = "*" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A special pseudo type used to indicate that the actual type may have to be
 * inferred from a context.
 *
 * For example, a call like `Default::default()` is assigned this type, which
 * means that the actual type is to be inferred from the context in which the call
 * occurs.
 *
 * Context types are not restricted to root types, for example in a call like
 * `Vec::new()` we assign this type at the type path corresponding to the type
 * parameter of `Vec`.
 *
 * Context types are used to restrict when type information is allowed to flow
 * into call arguments (including method call receivers), in order to avoid
 * combinatorial explosions.
 */
class ContextType extends Type, TContextType {
  override TypeParameter getPositionalTypeParameter(int i) { none() }

  override string toString() { result = "(context typed)" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A type parameter. */
abstract class TypeParameter extends Type {
  override TypeParameter getPositionalTypeParameter(int i) { none() }
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

/**
 * A tuple type parameter. For instance the `T` in `(T, U)`.
 *
 * Since tuples are structural their type parameters can be represented as their
 * positional index. The type inference library requires that type parameters
 * belong to a single type, so we also include the arity of the tuple type.
 */
class TupleTypeParameter extends TypeParameter, TTupleTypeParameter {
  private int arity;
  private int index;

  TupleTypeParameter() { this = TTupleTypeParameter(arity, index) }

  override string toString() { result = index.toString() + "(" + arity + ")" }

  override Location getLocation() { result instanceof EmptyLocation }

  /** Gets the index of this tuple type parameter. */
  int getIndex() { result = index }

  /** Gets the tuple type that corresponds to this tuple type parameter. */
  TupleType getTupleType() { result = TTuple(arity) }
}

/** An implicit array type parameter. */
class ArrayTypeParameter extends TypeParameter, TArrayTypeParameter {
  override string toString() { result = "[T;...]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class DynTraitTypeParameter extends TypeParameter, TDynTraitTypeParameter {
  private AstNode n;

  DynTraitTypeParameter() { this = TDynTraitTypeParameter(n) }

  Trait getTrait() { dynTraitTypeParameter(result, n) }

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
    result.(AssociatedTypeTypeParameter).getTypeAlias() = n
  }

  private string toStringInner() {
    result = [this.getTypeParam().toString(), this.getTypeAlias().getName().toString()]
  }

  override string toString() { result = "dyn(" + this.toStringInner() + ")" }

  override Location getLocation() { result = n.getLocation() }
}

class ImplTraitTypeParameter extends TypeParameter, TImplTraitTypeParameter {
  private TypeParam typeParam;
  private ImplTraitTypeRepr implTrait;

  ImplTraitTypeParameter() { this = TImplTraitTypeParameter(implTrait, typeParam) }

  TypeParam getTypeParam() { result = typeParam }

  ImplTraitTypeRepr getImplTraitTypeRepr() { result = implTrait }

  override string toString() { result = "impl(" + typeParam.toString() + ")" }

  override Location getLocation() { result = typeParam.getLocation() }
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

class PtrTypeParameter extends TypeParameter, TPtrTypeParameter {
  override string toString() { result = "*T" }

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

  override TypeParameter getPositionalTypeParameter(int i) { none() }
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

final class DynTypeAbstraction extends TypeAbstraction, DynTraitTypeRepr {
  override TypeParameter getATypeParameter() {
    result = any(DynTraitTypeParameter tp | tp.getTrait() = this.getTrait()).getTraitTypeParameter()
  }
}

final class TraitTypeAbstraction extends TypeAbstraction, Trait {
  override TypeParameter getATypeParameter() {
    result.(TypeParamTypeParameter).getTypeParam() = this.getGenericParamList().getATypeParam()
    or
    result.(AssociatedTypeTypeParameter).getTrait() = this
    or
    result.(SelfTypeParameter).getTrait() = this
  }
}

final class TypeBoundTypeAbstraction extends TypeAbstraction, TypeBound {
  override TypeParameter getATypeParameter() { none() }
}

final class SelfTypeBoundTypeAbstraction extends TypeAbstraction, Name {
  SelfTypeBoundTypeAbstraction() { any(TraitTypeAbstraction trait).getName() = this }

  override TypeParameter getATypeParameter() { none() }
}

final class ImplTraitTypeReprAbstraction extends TypeAbstraction, ImplTraitTypeRepr {
  override TypeParameter getATypeParameter() {
    implTraitTypeParam(this, _, result.(TypeParamTypeParameter).getTypeParam())
  }
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
  exists(Struct s | t = TStruct(s) |
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
