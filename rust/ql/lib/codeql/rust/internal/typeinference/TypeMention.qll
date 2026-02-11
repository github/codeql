/** Provides classes for representing type mentions, used in type inference. */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.frameworks.stdlib.Stdlib
private import Type
private import TypeAbstraction
private import TypeInference
private import AssociatedType

bindingset[trait, name]
pragma[inline_late]
private TypeAlias getTraitAssocType(TraitItemNode trait, string name) {
  result = trait.getAssocItem(name)
}

private signature Type getAdditionalPathTypeAtSig(Path p, TypePath typePath);

/**
 * Constructing the "type hierarchy" (that is, the trait hierarchy and how types
 * implement traits) in the shared type inference library relies on type
 * mentions.
 *
 * Furthermore, resolving type mentions such as `<Type as Trait>::AssocType`
 * relies on knowing how `Type` implements `Trait`. This makes type mentions and
 * the type hierarchy recursively dependent, which causes non-monotonic
 * recursion.
 *
 * To avoid the recursion, we parameterize the `TypeMention` by a predicate for
 * resolving "additional" types for paths. A first instantiation uses the empty
 * predicate to create `PreTypeMention` which is used to construct the type
 * hierarchy. Afterwards, a second instantiation uses a predicate that can
 * resolve paths that rely on the type hierarchy to create the actual
 * `TypeMention`.
 */
private module MkTypeMention<getAdditionalPathTypeAtSig/2 getAdditionalPathTypeAt> {
  /** An AST node that may mention a type. */
  abstract private class TypeMentionImpl extends AstNode {
    /** Gets the type at `path` that this type mention resolves to, if any. */
    pragma[nomagic]
    abstract Type getTypeAt(TypePath path);

    /** Gets the root type that this type mention resolves to, if any. */
    pragma[nomagic]
    final Type getType() { result = this.getTypeAt(TypePath::nil()) }
  }

  final class TypeMention = TypeMentionImpl;

  class TupleTypeReprMention extends TypeMentionImpl instanceof TupleTypeRepr {
    override Type getTypeAt(TypePath path) {
      path.isEmpty() and
      result.(TupleType).getArity() = super.getNumberOfFields()
      or
      exists(TypePath suffix, int i |
        result = super.getField(i).(TypeMention).getTypeAt(suffix) and
        path = TypePath::cons(getTupleTypeParameter(super.getNumberOfFields(), i), suffix)
      )
    }
  }

  class ParenthesizedArgListMention extends TypeMentionImpl instanceof ParenthesizedArgList {
    override Type getTypeAt(TypePath path) {
      path.isEmpty() and
      result.(TupleType).getArity() = super.getNumberOfTypeArgs()
      or
      exists(TypePath suffix, int index |
        result = super.getTypeArg(index).getTypeRepr().(TypeMention).getTypeAt(suffix) and
        path = TypePath::cons(getTupleTypeParameter(super.getNumberOfTypeArgs(), index), suffix)
      )
    }
  }

  class ArrayTypeReprMention extends TypeMentionImpl instanceof ArrayTypeRepr {
    override Type getTypeAt(TypePath path) {
      path.isEmpty() and
      result instanceof ArrayType
      or
      exists(TypePath suffix |
        result = super.getElementTypeRepr().(TypeMention).getTypeAt(suffix) and
        path = TypePath::cons(getArrayTypeParameter(), suffix)
      )
    }
  }

  class RefTypeReprMention extends TypeMentionImpl instanceof RefTypeRepr {
    private RefType resolveRootType() {
      if super.isMut() then result instanceof RefMutType else result instanceof RefSharedType
    }

    override Type getTypeAt(TypePath path) {
      path.isEmpty() and result = this.resolveRootType()
      or
      exists(TypePath suffix |
        result = super.getTypeRepr().(TypeMention).getTypeAt(suffix) and
        path = TypePath::cons(this.resolveRootType().getPositionalTypeParameter(0), suffix)
      )
    }
  }

  class SliceTypeReprMention extends TypeMentionImpl instanceof SliceTypeRepr {
    override Type getTypeAt(TypePath path) {
      path.isEmpty() and
      result instanceof SliceType
      or
      exists(TypePath suffix |
        result = super.getTypeRepr().(TypeMention).getTypeAt(suffix) and
        path = TypePath::cons(getSliceTypeParameter(), suffix)
      )
    }
  }

  abstract class PathTypeMention extends TypeMentionImpl, Path {
    abstract Type resolvePathTypeAt(TypePath typePath);

    final override Type getTypeAt(TypePath typePath) {
      result = this.resolvePathTypeAt(typePath) and
      (
        not result instanceof TypeParameter
        or
        // Prevent type parameters from escaping their scope
        this = result.(TypeParameter).getDeclaringItem().getAChild*().getADescendant()
      )
    }
  }

  class AdditionalPathTypeMention extends PathTypeMention {
    AdditionalPathTypeMention() { exists(getAdditionalPathTypeAt(this, _)) }

    override Type resolvePathTypeAt(TypePath typePath) {
      result = getAdditionalPathTypeAt(this, typePath)
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
      result = rhs.getTypeAt(typePath) and
      not result = pathGetTypeParameter(resolved, _)
      or
      exists(TypeParameter tp, TypeMention arg, TypePath prefix, TypePath suffix, int i |
        tp = rhs.getTypeAt(prefix) and
        tp = pathGetTypeParameter(resolved, pragma[only_bind_into](i)) and
        arg = this.getSegment().getGenericArgList().getTypeArg(pragma[only_bind_into](i)) and
        result = arg.getTypeAt(suffix) and
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
      not exists(getAdditionalPathTypeAt(this, _)) and // handled by `AdditionalPathTypeMention`
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

    pragma[nomagic]
    private Type getDefaultPositionalTypeArgument(int i, TypePath path) {
      // If a type argument is not given in the path, then we use the default for
      // the type parameter if one exists for the type.
      not exists(getPathTypeArgument(this, i)) and
      exists(Type ty, TypePath prefix |
        ty = this.resolveRootType().getTypeParameterDefault(i).(TypeMention).getTypeAt(prefix) and
        if not ty = TSelfTypeParameter(resolved)
        then result = ty and path = prefix
        else
          // When a default contains an implicit `Self` type parameter, it should
          // be substituted for the type that implements the trait.
          exists(TypePath suffix |
            path = prefix.append(suffix) and
            result = this.getSelfTraitBoundArg().getTypeAt(suffix)
          )
      )
    }

    private predicate isInTypeAnnotation() {
      this = any(PathTypeRepr ptp).getPath().getQualifier*()
    }

    pragma[nomagic]
    private TypeParameter getPositionalTypeParameter(int i) {
      result = this.resolveRootType().getPositionalTypeParameter(i)
    }

    /**
     * Gets the default type for the type parameter `tp` at `path`, if any.
     *
     * This predicate is restricted to mentions that are _not_ part of a type
     * annotation, such as a qualifier in a call, `Vec::new()`, where the
     * default type for type parameter `A` of `Vec` is `Global`.
     *
     * In these cases, whether or not the default type actually applies may
     * depend on the types of arguments.
     */
    pragma[nomagic]
    Type getDefaultTypeForTypeParameterInNonAnnotationAt(TypeParameter tp, TypePath path) {
      not this.isInTypeAnnotation() and
      exists(int i |
        result = this.getDefaultPositionalTypeArgument(i, path) and
        tp = this.getPositionalTypeParameter(i)
      )
    }

    pragma[nomagic]
    private Type getPositionalTypeArgument(int i, TypePath path) {
      result = getPathTypeArgument(this, i).getTypeAt(path)
    }

    /**
     * Gets the type for this path for the type parameter `tp` at `path`, when the
     * type parameter does not correspond directly to a type mention.
     */
    private Type getTypeForTypeParameterAt(TypeParameter tp, TypePath path) {
      exists(int i | tp = this.getPositionalTypeParameter(i) |
        result = this.getPositionalTypeArgument(i, path)
        or
        // Defaults only apply to type mentions in type annotations
        this.isInTypeAnnotation() and
        result = this.getDefaultPositionalTypeArgument(i, path)
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
        result = s.getParenthesizedArgList().(TypeMention).getTypeAt(path)
        or
        tp = TAssociatedTypeTypeParameter(t, any(FnOnceTrait tr).getOutputType()) and
        (
          result = s.getRetType().getTypeRepr().(TypeMention).getTypeAt(path)
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
      or
      // If this path is a type parameter bound, then any associated types
      // accessed on the type parameter, which originate from this bound, should
      // be instantiated into the bound, as explained in the comment for
      // `TypeParamAssociatedTypeTypeParameter`.
      // ```rust
      // fn foo<T: SomeTrait<Assoc = T_Assoc>, T_Assoc>(arg: T_Assoc) { }
      //           ^^^^^^^^^ ^^^^^   ^^^^^^^
      //           this      path    result
      // ```
      exists(TypeParam typeParam, Trait trait, AssocType assoc |
        tpBoundAssociatedType(typeParam, _, this, trait, assoc) and
        tp = TAssociatedTypeTypeParameter(resolved, assoc) and
        result = TTypeParamAssociatedTypeTypeParameter(typeParam, assoc) and
        path.isEmpty()
      )
    }

    bindingset[name]
    private TypeAlias getResolvedTraitAssocType(string name) {
      result = resolved.(TraitItemNode).getASuccessor(name)
    }

    /** Gets the type mention in this path for the type parameter `tp`, if any. */
    pragma[nomagic]
    private TypeMention getTypeMentionForAssociatedTypeTypeParameter(AssociatedTypeTypeParameter tp) {
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
        tp = TAssociatedTypeTypeParameter(resolved, resolved.(TraitItemNode).getAssocItem(name))
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
      // Handles paths of the form `Self::AssocType` within a trait block
      result = TAssociatedTypeTypeParameter(resolvePath(this.getQualifier()), resolved)
      or
      result.(TypeParamAssociatedTypeTypeParameter).getAPath() = this
    }

    override Type resolvePathTypeAt(TypePath typePath) {
      typePath.isEmpty() and
      result = this.resolveRootType()
      or
      exists(TypeParameter tp, TypePath suffix | typePath = TypePath::cons(tp, suffix) |
        result = this.getTypeForTypeParameterAt(tp, suffix)
        or
        result = this.getTypeMentionForAssociatedTypeTypeParameter(tp).getTypeAt(suffix)
      )
      or
      // When the path refers to a trait, then the implicit `Self` type parameter
      // should be instantiated from the context.
      exists(TypePath suffix |
        result = this.getSelfTraitBoundArg().getTypeAt(suffix) and
        typePath = TypePath::cons(TSelfTypeParameter(resolved), suffix)
      )
      or
      not this.getSegment().hasTraitTypeRepr() and
      result = this.getSegment().getTypeRepr().(TypeMention).getTypeAt(typePath)
    }
  }

  pragma[nomagic]
  Type resolveImplSelfTypeAt(Impl i, TypePath path) {
    result = i.getSelfTy().(TypeMention).getTypeAt(path)
  }

  class ImplSelfMention extends PathTypeMention {
    private ImplItemNode impl;

    ImplSelfMention() { this = impl.getASelfPath() }

    override Type resolvePathTypeAt(TypePath typePath) {
      result = resolveImplSelfTypeAt(impl, typePath)
    }
  }

  class PathTypeReprMention extends TypeMentionImpl, PathTypeRepr {
    private PathTypeMention path;

    PathTypeReprMention() { path = this.getPath() }

    override Type getTypeAt(TypePath typePath) { result = path.getTypeAt(typePath) }
  }

  class ImplTraitTypeReprMention extends TypeMentionImpl instanceof ImplTraitTypeRepr {
    override Type getTypeAt(TypePath typePath) {
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
  class TypeParamMention extends TypeMentionImpl instanceof TypeParam {
    override Type getTypeAt(TypePath typePath) {
      typePath.isEmpty() and
      result = TTypeParamTypeParameter(this)
    }
  }

  class TraitMention extends TypeMentionImpl instanceof TraitItemNode {
    override Type getTypeAt(TypePath typePath) {
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
  class SelfTypeParameterMention extends TypeMentionImpl instanceof Name {
    Trait trait;

    SelfTypeParameterMention() { trait.getName() = this }

    Trait getTrait() { result = trait }

    override Type getTypeAt(TypePath typePath) {
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
  class ShorthandSelfParameterMention extends TypeMentionImpl instanceof SelfParam {
    private ImplOrTraitItemNode encl;

    ShorthandSelfParameterMention() {
      not super.hasTypeRepr() and
      encl = getSelfParamEnclosingImplOrTrait(this) and
      (
        not encl instanceof Impl
        or
        // avoid generating a type mention if the type being implemented does not have a type mention
        encl.(Impl).getSelfTy() instanceof TypeMentionImpl
      )
    }

    private Type resolveSelfType(TypePath path) { result = resolveImplOrTraitType(encl, path) }

    private RefType resolveSelfRefRootType() {
      super.isRef() and
      if super.isMut() then result instanceof RefMutType else result instanceof RefSharedType
    }

    override Type getTypeAt(TypePath typePath) {
      // `fn f(&self, ...)`
      typePath.isEmpty() and
      result = this.resolveSelfRefRootType()
      or
      exists(TypePath suffix |
        result = this.resolveSelfType(suffix) and
        typePath =
          TypePath::cons(this.resolveSelfRefRootType().getPositionalTypeParameter(0), suffix)
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
  class ShorthandReturnTypeMention extends TypeMentionImpl instanceof Name {
    private Function f;

    ShorthandReturnTypeMention() {
      this = f.getName() and
      not f.getRetType().hasTypeRepr()
    }

    override Type getTypeAt(TypePath typePath) {
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

  class DynTraitTypeReprMention extends TypeMentionImpl instanceof DynTraitTypeRepr {
    private DynTraitType dynType;

    DynTraitTypeReprMention() {
      // This excludes `DynTraitTypeRepr` elements where `getTrait` is not
      // defined, i.e., where path resolution can't find a trait.
      dynType.getTrait() = super.getTrait()
    }

    override Type getTypeAt(TypePath path) {
      path.isEmpty() and
      result = dynType
      or
      exists(DynTraitTypeParameter tp, TypePath path0, TypePath suffix |
        dynType = tp.getDynTraitType() and
        path = TypePath::cons(tp, suffix) and
        result = super.getTypeBoundList().getBound(0).getTypeRepr().(TypeMention).getTypeAt(path0) and
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
  class DynTypeBoundListMention extends TypeMentionImpl instanceof TypeBoundList {
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

    override Type getTypeAt(TypePath path) {
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

  class NeverTypeReprMention extends TypeMentionImpl, NeverTypeRepr {
    override Type getTypeAt(TypePath path) { result = TNeverType() and path.isEmpty() }
  }

  class PtrTypeReprMention extends TypeMentionImpl instanceof PtrTypeRepr {
    private PtrType resolveRootType() {
      super.isConst() and result instanceof PtrConstType
      or
      super.isMut() and result instanceof PtrMutType
    }

    override Type getTypeAt(TypePath path) {
      path.isEmpty() and result = this.resolveRootType()
      or
      exists(TypePath suffix |
        result = super.getTypeRepr().(TypeMention).getTypeAt(suffix) and
        path = TypePath::cons(this.resolveRootType().getPositionalTypeParameter(0), suffix)
      )
    }
  }
}

private Type preGetAdditionalPathTypeAt(Path p, TypePath typePath) { none() }

private module PreTypeMention = MkTypeMention<preGetAdditionalPathTypeAt/2>;

class PreTypeMention = PreTypeMention::TypeMention;

/**
 * Holds if `path` accesses an associated type `alias` from `trait` on a
 * concrete type given by `tm`.
 */
private predicate pathConcreteTypeAssocType(
  Path path, PreTypeMention tm, Trait trait, TypeAlias alias
) {
  exists(Path qualifier |
    qualifier = path.getQualifier() and
    not resolvePath(tm.(PathTypeRepr).getPath()) instanceof TypeParam
  |
    // path of the form `<Type as Trait>::AssocType`
    //                    ^^^ tm          ^^^^^^^^^ name
    exists(string name, Path traitPath |
      pathTypeAsTraitAssoc(path, tm, traitPath, name) and
      trait = resolvePath(traitPath) and
      getTraitAssocType(trait, name) = alias
    )
    or
    // path of the form `Self::AssocType` within an `impl` block
    //                tm ^^^^  ^^^^^^^^^ name
    exists(ImplItemNode impl |
      alias = resolvePath(path) and
      qualifier = impl.getASelfPath() and
      tm = impl.(Impl).getSelfTy() and
      trait.(TraitItemNode).getAnAssocItem() = alias
    )
  )
}

private module PathSatisfiesConstraintInput implements SatisfiesConstraintInputSig<PreTypeMention> {
  predicate relevantConstraint(PreTypeMention tm, Type constraint) {
    pathConcreteTypeAssocType(_, tm, constraint.(TraitType).getTrait(), _)
  }
}

private module PathSatisfiesConstraint =
  SatisfiesConstraint<PreTypeMention, PathSatisfiesConstraintInput>;

/**
 * Gets the type of `path` at `typePath` when `path` accesses an associated type
 * on a concrete type.
 */
private Type getPathConcreteAssocTypeAt(Path path, TypePath typePath) {
  exists(PreTypeMention tm, TraitItemNode t, TypeAlias alias, TypePath path0 |
    pathConcreteTypeAssocType(path, tm, t, alias) and
    PathSatisfiesConstraint::satisfiesConstraintType(tm, TTrait(t), path0, result) and
    path0.isCons(TAssociatedTypeTypeParameter(t, alias), typePath)
  )
}

import MkTypeMention<getPathConcreteAssocTypeAt/2>
