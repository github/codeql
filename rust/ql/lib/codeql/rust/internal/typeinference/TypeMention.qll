/** Provides classes for representing type mentions, used in type inference. */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.frameworks.stdlib.Stdlib
private import Type
private import TypeAbstraction
private import TypeInference

/** An AST node that may mention a type. */
abstract class TypeMention extends AstNode {
  /** Gets the type at `path` that this mention resolves to, if any. */
  pragma[nomagic]
  abstract Type resolveTypeAt(TypePath path);

  /** Gets the type that this node resolves to, if any. */
  pragma[nomagic]
  final Type resolveType() { result = this.resolveTypeAt(TypePath::nil()) }
}

class TupleTypeReprMention extends TypeMention instanceof TupleTypeRepr {
  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result.(TupleType).getArity() = super.getNumberOfFields()
    or
    exists(TypePath suffix, int i |
      result = super.getField(i).(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(getTupleTypeParameter(super.getNumberOfFields(), i), suffix)
    )
  }
}

class ParenthesizedArgListMention extends TypeMention instanceof ParenthesizedArgList {
  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result.(TupleType).getArity() = super.getNumberOfTypeArgs()
    or
    exists(TypePath suffix, int index |
      result = super.getTypeArg(index).getTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(getTupleTypeParameter(super.getNumberOfTypeArgs(), index), suffix)
    )
  }
}

class ArrayTypeReprMention extends TypeMention instanceof ArrayTypeRepr {
  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result instanceof ArrayType
    or
    exists(TypePath suffix |
      result = super.getElementTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(getArrayTypeParameter(), suffix)
    )
  }
}

class RefTypeReprMention extends TypeMention instanceof RefTypeRepr {
  private RefType resolveRootType() {
    if super.isMut() then result instanceof RefMutType else result instanceof RefSharedType
  }

  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and result = this.resolveRootType()
    or
    exists(TypePath suffix |
      result = super.getTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(this.resolveRootType().getPositionalTypeParameter(0), suffix)
    )
  }
}

class SliceTypeReprMention extends TypeMention instanceof SliceTypeRepr {
  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result instanceof SliceType
    or
    exists(TypePath suffix |
      result = super.getTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(getSliceTypeParameter(), suffix)
    )
  }
}

abstract class PathTypeMention extends TypeMention, Path {
  abstract Type resolvePathTypeAt(TypePath typePath);

  final override Type resolveTypeAt(TypePath typePath) {
    result = this.resolvePathTypeAt(typePath) and
    (
      not result instanceof TypeParameter
      or
      // Prevent type parameters from escaping their scope
      this = result.(TypeParameter).getDeclaringItem().getAChild*().getADescendant()
    )
  }
}

class AliasPathTypeMention extends PathTypeMention {
  TypeAlias resolved;
  TypeMention rhs;

  AliasPathTypeMention() {
    resolved = resolvePath(this) and
    rhs = resolved.getTypeRepr()
  }

  TypeItemNode getResolved() { result = resolved }

  /**
   * Holds if this path resolved to a type alias with a rhs. that has the
   * resulting type at `typePath`.
   */
  override Type resolvePathTypeAt(TypePath typePath) {
    result = rhs.resolveTypeAt(typePath) and
    not result = pathGetTypeParameter(resolved, _)
    or
    exists(TypeParameter tp, TypeMention arg, TypePath prefix, TypePath suffix, int i |
      tp = rhs.resolveTypeAt(prefix) and
      tp = pathGetTypeParameter(resolved, pragma[only_bind_into](i)) and
      arg = this.getSegment().getGenericArgList().getTypeArg(pragma[only_bind_into](i)) and
      result = arg.resolveTypeAt(suffix) and
      typePath = prefix.append(suffix)
    )
  }
}

/**
 * Gets the `i`th type argument of `p`.
 *
 * Takes into account that variants can have type arguments applied to both the
 * enum and the variant itself, e.g. `Option::<i32>::Some` is valid in addition
 * to `Option::Some::<i32>`.
 */
TypeMention getPathTypeArgument(Path p, int i) {
  result = p.getSegment().getGenericArgList().getTypeArg(i)
  or
  resolvePath(p) instanceof Variant and
  result = p.getQualifier().getSegment().getGenericArgList().getTypeArg(i)
}

class NonAliasPathTypeMention extends PathTypeMention {
  TypeItemNode resolved;

  NonAliasPathTypeMention() {
    resolved = [resolvePath(this), resolvePath(this).(Variant).getEnum().(TypeItemNode)] and
    not exists(resolved.(TypeAlias).getTypeRepr()) and
    not this = any(ImplItemNode i).getASelfPath() // handled by `ImplSelfMention`
  }

  TypeItemNode getResolved() { result = resolved }

  pragma[nomagic]
  private TypeMention getAssocTypeArg(string name) {
    result = this.getSegment().getGenericArgList().getAssocTypeArg(name)
  }

  /**
   * Gets the type mention that instantiates the implicit `Self` type parameter
   * for this path, if it occurs in the position of a trait bound.
   */
  private TypeMention getSelfTraitBoundArg() {
    exists(ImplItemNode impl | this = impl.getTraitPath() and result = impl.(Impl).getSelfTy())
    or
    exists(Trait subTrait |
      this = subTrait.getATypeBound().getTypeRepr().(PathTypeRepr).getPath() and
      result.(SelfTypeParameterMention).getTrait() = subTrait
    )
    or
    exists(TypeParamItemNode tp | this = tp.getABoundPath() and result = tp)
  }

  private Type getDefaultPositionalTypeArgument(int i, TypePath path) {
    // If a type argument is not given in the path, then we use the default for
    // the type parameter if one exists for the type.
    not exists(getPathTypeArgument(this, i)) and
    // Defaults only apply to type mentions in type annotations
    this = any(PathTypeRepr ptp).getPath().getQualifier*() and
    exists(Type ty, TypePath prefix |
      ty = this.resolveRootType().getTypeParameterDefault(i).resolveTypeAt(prefix) and
      if not ty = TSelfTypeParameter(resolved)
      then result = ty and path = prefix
      else
        // When a default contains an implicit `Self` type parameter, it should
        // be substituted for the type that implements the trait.
        exists(TypePath suffix |
          path = prefix.append(suffix) and
          result = this.getSelfTraitBoundArg().resolveTypeAt(suffix)
        )
    )
  }

  private Type getPositionalTypeArgument(int i, TypePath path) {
    result = getPathTypeArgument(this, i).resolveTypeAt(path)
    or
    result = this.getDefaultPositionalTypeArgument(i, path)
  }

  /**
   * Gets the type for this path for the type parameter `tp` at `path`, when the
   * type parameter does not correspond directly to a type mention.
   */
  private Type getTypeForTypeParameterAt(TypeParameter tp, TypePath path) {
    exists(int i |
      result = this.getPositionalTypeArgument(pragma[only_bind_into](i), path) and
      tp = this.resolveRootType().getPositionalTypeParameter(pragma[only_bind_into](i))
    )
    or
    // Handle the special syntactic sugar for function traits. The syntactic
    // form is detected by the presence of a parenthesized argument list which
    // is a mandatory part of the syntax [1].
    //
    // For now we only support `FnOnce` as we can't support the "inherited"
    // associated types of `Fn` and `FnMut` yet.
    //
    // [1]: https://doc.rust-lang.org/reference/paths.html#grammar-TypePathFn
    exists(AnyFnTrait t, PathSegment s |
      t = resolved and
      s = this.getSegment() and
      s.hasParenthesizedArgList()
    |
      tp = TTypeParamTypeParameter(t.getTypeParam()) and
      result = s.getParenthesizedArgList().(TypeMention).resolveTypeAt(path)
      or
      tp = TAssociatedTypeTypeParameter(t, any(FnOnceTrait tr).getOutputType()) and
      (
        result = s.getRetType().getTypeRepr().(TypeMention).resolveTypeAt(path)
        or
        // When the `-> ...` return type is omitted, it defaults to `()`.
        not s.hasRetType() and
        result instanceof UnitType and
        path.isEmpty()
      )
    )
    or
    // If `path` is the supertrait of a trait block then any associated types
    // of the supertrait should be instantiated with the subtrait's
    // corresponding copies.
    //
    // As an example, for
    // ```rust
    // trait Sub: Super {
    // //         ^^^^^ this
    // ```
    // we do something to the effect of:
    // ```rust
    // trait Sub: Super<Assoc=Assoc[Sub]>
    // ```
    // Where `Assoc` is an associated type of `Super` and `Assoc[Sub]` denotes
    // the copy of the type parameter inherited by `Sub`.
    exists(Trait subtrait, TypeAlias alias |
      subtrait.getATypeBound().getTypeRepr().(PathTypeRepr).getPath() = this and
      result = TAssociatedTypeTypeParameter(subtrait, alias) and
      tp = TAssociatedTypeTypeParameter(resolved, alias) and
      path.isEmpty()
    )
  }

  bindingset[name]
  private TypeAlias getResolvedAlias(string name) {
    result = resolved.(TraitItemNode).getAssocItem(name)
  }

  bindingset[name]
  private TypeAlias getResolvedTraitAssocType(string name) {
    result = resolved.(TraitItemNode).getASuccessor(name)
  }

  /** Gets the type mention in this path for the type parameter `tp`, if any. */
  pragma[nomagic]
  private TypeMention getTypeMentionForTypeParameter(TypeParameter tp) {
    exists(TypeAlias alias, string name |
      result = this.getAssocTypeArg(name) and
      tp = TAssociatedTypeTypeParameter(resolved, alias) and
      alias = this.getResolvedTraitAssocType(name)
    )
    or
    // If `path` is the trait of an `impl` block then any associated types
    // defined in the `impl` block are type arguments to the trait.
    //
    // For instance, for a trait implementation like this
    // ```rust
    // impl MyTrait for MyType {
    //      ^^^^^^^ path
    //   type AssociatedType = i64
    //                         ^^^ result
    //   // ...
    // }
    // ```
    // the rhs. of the type alias is a type argument to the trait.
    exists(ImplItemNode impl, TypeAlias alias, string name |
      this = impl.getTraitPath() and
      alias = impl.getASuccessor(name) and
      result = alias.getTypeRepr() and
      tp = TAssociatedTypeTypeParameter(resolved, this.getResolvedAlias(name))
    )
  }

  pragma[nomagic]
  private Type resolveRootType() {
    result = TDataType(resolved)
    or
    exists(TraitItemNode trait | trait = resolved |
      // If this is a `Self` path, then it resolves to the implicit `Self`
      // type parameter, otherwise it is a trait bound.
      if this = trait.getASelfPath()
      then result = TSelfTypeParameter(trait)
      else result = TTrait(trait)
    )
    or
    result = TTypeParamTypeParameter(resolved)
    or
    result = TAssociatedTypeTypeParameter(resolvePath(this.getQualifier()), resolved)
  }

  override Type resolvePathTypeAt(TypePath typePath) {
    typePath.isEmpty() and
    result = this.resolveRootType()
    or
    exists(TypeParameter tp, TypePath suffix | typePath = TypePath::cons(tp, suffix) |
      result = this.getTypeForTypeParameterAt(tp, suffix)
      or
      result = this.getTypeMentionForTypeParameter(tp).resolveTypeAt(suffix)
    )
    or
    // When the path refers to a trait, then the implicit `Self` type parameter
    // should be instantiated from the context.
    exists(TypePath suffix |
      result = this.getSelfTraitBoundArg().resolveTypeAt(suffix) and
      typePath = TypePath::cons(TSelfTypeParameter(resolved), suffix)
    )
    or
    not this.getSegment().hasTraitTypeRepr() and
    result = this.getSegment().getTypeRepr().(TypeMention).resolveTypeAt(typePath)
  }
}

pragma[nomagic]
Type resolveImplSelfTypeAt(Impl i, TypePath path) {
  result = i.getSelfTy().(TypeMention).resolveTypeAt(path)
}

class ImplSelfMention extends PathTypeMention {
  private ImplItemNode impl;

  ImplSelfMention() { this = impl.getASelfPath() }

  override Type resolvePathTypeAt(TypePath typePath) {
    result = resolveImplSelfTypeAt(impl, typePath)
  }
}

class PathTypeReprMention extends TypeMention, PathTypeRepr {
  private PathTypeMention path;

  PathTypeReprMention() { path = this.getPath() }

  override Type resolveTypeAt(TypePath typePath) { result = path.resolveTypeAt(typePath) }
}

class ImplTraitTypeReprMention extends TypeMention instanceof ImplTraitTypeRepr {
  override Type resolveTypeAt(TypePath typePath) {
    typePath.isEmpty() and
    result.(ImplTraitType).getImplTraitTypeRepr() = this
    or
    exists(ImplTraitTypeParameter tp |
      this = tp.getImplTraitTypeRepr() and
      typePath = TypePath::singleton(tp) and
      result = TTypeParamTypeParameter(tp.getTypeParam())
    )
  }
}

private TypeParameter pathGetTypeParameter(TypeAlias alias, int i) {
  result = TTypeParamTypeParameter(alias.getGenericParamList().getTypeParam(i))
}

// Used to represent implicit `Self` type arguments in traits and `impl` blocks,
// see `PathMention` for details.
class TypeParamMention extends TypeMention instanceof TypeParam {
  override Type resolveTypeAt(TypePath typePath) {
    typePath.isEmpty() and
    result = TTypeParamTypeParameter(this)
  }
}

class TraitMention extends TypeMention instanceof TraitItemNode {
  override Type resolveTypeAt(TypePath typePath) {
    typePath.isEmpty() and
    result = TTrait(this)
    or
    // The implicit `Self` type parameter occurs at the `Self` type parameter
    // position.
    typePath = TypePath::singleton(TSelfTypeParameter(this)) and
    result = TSelfTypeParameter(this)
    or
    exists(TypeAlias alias |
      typePath = TypePath::singleton(result) and
      result = TAssociatedTypeTypeParameter(this, alias)
    )
    or
    exists(TypeParam tp |
      tp = super.getTypeParam(_) and
      typePath = TypePath::singleton(result) and
      result = TTypeParamTypeParameter(tp)
    )
  }
}

// NOTE: Since the implicit type parameter for the self type parameter never
// appears in the AST, we (somewhat arbitrarily) choose the name of a trait as a
// type mention. This works because there is a one-to-one correspondence between
// a trait and its name.
class SelfTypeParameterMention extends TypeMention instanceof Name {
  Trait trait;

  SelfTypeParameterMention() { trait.getName() = this }

  Trait getTrait() { result = trait }

  override Type resolveTypeAt(TypePath typePath) {
    typePath.isEmpty() and
    result = TSelfTypeParameter(trait)
  }
}

/**
 * Gets the type at `path` of the type being implemented in `i`, when
 * `i` is an `impl` block, or the synthetic `Self` type parameter when
 * `i` is a trait.
 */
pragma[nomagic]
Type resolveImplOrTraitType(ImplOrTraitItemNode i, TypePath path) {
  result = resolveImplSelfTypeAt(i, path)
  or
  result = TSelfTypeParameter(i) and path.isEmpty()
}

pragma[nomagic]
private ImplOrTraitItemNode getSelfParamEnclosingImplOrTrait(SelfParam self) {
  self = result.getAnAssocItem().(Function).getSelfParam()
}

/**
 * An element used to represent the type of a `self` parameter that uses [shorthand
 * syntax][1], which is sugar for an explicit annotation.
 *
 * [1]: https://doc.rust-lang.org/stable/reference/items/associated-items.html#r-associated.fn.method.self-pat-shorthands
 */
class ShorthandSelfParameterMention extends TypeMention instanceof SelfParam {
  private ImplOrTraitItemNode encl;

  ShorthandSelfParameterMention() {
    not super.hasTypeRepr() and
    encl = getSelfParamEnclosingImplOrTrait(this) and
    (
      not encl instanceof Impl
      or
      // avoid generating a type mention if the type being implemented does not have a type mention
      encl.(Impl).getSelfTy() instanceof TypeMention
    )
  }

  private Type resolveSelfType(TypePath path) { result = resolveImplOrTraitType(encl, path) }

  private RefType resolveSelfRefRootType() {
    super.isRef() and
    if super.isMut() then result instanceof RefMutType else result instanceof RefSharedType
  }

  override Type resolveTypeAt(TypePath typePath) {
    // `fn f(&self, ...)`
    typePath.isEmpty() and
    result = this.resolveSelfRefRootType()
    or
    exists(TypePath suffix |
      result = this.resolveSelfType(suffix) and
      typePath = TypePath::cons(this.resolveSelfRefRootType().getPositionalTypeParameter(0), suffix)
    )
    or
    // `fn f(self, ...)`
    not super.isRef() and
    result = this.resolveSelfType(typePath)
  }
}

pragma[nomagic]
TypeMention getSelfParamTypeMention(SelfParam self) {
  result = self.(ShorthandSelfParameterMention)
  or
  result = self.getTypeRepr()
}

/**
 * An element used to represent the implicit `()` return type of a function.
 *
 * Since the implicit type does not appear in the AST, we (somewhat arbitrarily)
 * choose the name of the function as a type mention. This works because there
 * is a one-to-one correspondence between a function and its name.
 */
class ShorthandReturnTypeMention extends TypeMention instanceof Name {
  private Function f;

  ShorthandReturnTypeMention() {
    this = f.getName() and
    not f.getRetType().hasTypeRepr()
  }

  override Type resolveTypeAt(TypePath typePath) {
    typePath.isEmpty() and
    result instanceof UnitType
  }
}

pragma[nomagic]
TypeMention getReturnTypeMention(Function f) {
  result.(ShorthandReturnTypeMention) = f.getName()
  or
  result = f.getRetType().getTypeRepr()
}

class DynTraitTypeReprMention extends TypeMention instanceof DynTraitTypeRepr {
  private DynTraitType dynType;

  DynTraitTypeReprMention() {
    // This excludes `DynTraitTypeRepr` elements where `getTrait` is not
    // defined, i.e., where path resolution can't find a trait.
    dynType.getTrait() = super.getTrait()
  }

  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result = dynType
    or
    exists(DynTraitTypeParameter tp, TypePath path0, TypePath suffix |
      dynType = tp.getDynTraitType() and
      path = TypePath::cons(tp, suffix) and
      result = super.getTypeBoundList().getBound(0).getTypeRepr().(TypeMention).resolveTypeAt(path0) and
      path0.isCons(tp.getTraitTypeParameter(), suffix)
    )
  }
}

// We want a type of the form `dyn Trait` to implement `Trait`. If `Trait` has
// type parameters then `dyn Trait` has equivalent type parameters and the
// implementation should be abstracted over them.
//
// Intuitively we want something to the effect of:
// ```
// impl<A, B, ..> Trait<A, B, ..> for (dyn Trait)<A, B, ..>
// ```
// To achieve this:
// - `DynTypeAbstraction` is an abstraction over the type parameters of the trait.
// - `DynTypeBoundListMention` (this class) is a type mention which has `dyn
//   Trait` at the root and which for every type parameter of `dyn Trait` has the
//   corresponding type parameter of the trait.
// - `TraitMention` (which is used for other things as well) is a type mention
//    for the trait applied to its own type parameters.
//
// We arbitrarily use the `TypeBoundList` inside `DynTraitTypeRepr` to encode
// this type mention, since it doesn't syntactically appear in the AST. This
// works because there is a one-to-one correspondence between a trait object and
// its list of type bounds.
class DynTypeBoundListMention extends TypeMention instanceof TypeBoundList {
  private Trait trait;

  DynTypeBoundListMention() {
    exists(DynTraitTypeRepr dyn |
      // We only need this type mention when the `dyn Trait` is a type
      // abstraction, that is, when it's "canonical" and used in
      // `conditionSatisfiesConstraint`.
      dyn instanceof DynTypeAbstraction and
      this = dyn.getTypeBoundList() and
      trait = dyn.getTrait()
    )
  }

  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result.(DynTraitType).getTrait() = trait
    or
    exists(DynTraitTypeParameter tp |
      trait = tp.getTrait() and
      path = TypePath::singleton(tp) and
      result = tp.getTraitTypeParameter()
    )
  }
}

class NeverTypeReprMention extends TypeMention, NeverTypeRepr {
  override Type resolveTypeAt(TypePath path) { result = TNeverType() and path.isEmpty() }
}

class PtrTypeReprMention extends TypeMention instanceof PtrTypeRepr {
  private PtrType resolveRootType() {
    super.isConst() and result instanceof PtrConstType
    or
    super.isMut() and result instanceof PtrMutType
  }

  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and result = this.resolveRootType()
    or
    exists(TypePath suffix |
      result = super.getTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(this.resolveRootType().getPositionalTypeParameter(0), suffix)
    )
  }
}
