/** Provides classes for representing type mentions, used in type inference. */

private import rust
private import Type
private import PathResolution
private import TypeInference

/** An AST node that may mention a type. */
abstract class TypeMention extends AstNode {
  /** Gets the `i`th type argument mention, if any. */
  abstract TypeMention getTypeArgument(int i);

  /** Gets the type that this node resolves to, if any. */
  abstract Type resolveType();

  /** Gets the sub mention at `path`. */
  pragma[nomagic]
  private TypeMention getMentionAt(TypePath path) {
    path.isEmpty() and
    result = this
    or
    exists(int i, TypeParameter tp, TypeMention arg, TypePath suffix |
      arg = this.getTypeArgument(pragma[only_bind_into](i)) and
      result = arg.getMentionAt(suffix) and
      path = TypePath::cons(tp, suffix) and
      tp = this.resolveType().getTypeParameter(pragma[only_bind_into](i))
    )
  }

  /** Gets the type that the sub mention at `path` resolves to, if any. */
  Type resolveTypeAt(TypePath path) { result = this.getMentionAt(path).resolveType() }
}

class TypeReprMention extends TypeMention, TypeRepr {
  TypeReprMention() { not this instanceof InferTypeRepr }

  override TypeReprMention getTypeArgument(int i) {
    result = this.(ArrayTypeRepr).getElementTypeRepr() and
    i = 0
    or
    result = this.(RefTypeRepr).getTypeRepr() and
    i = 0
    or
    result = this.(PathTypeRepr).getPath().(PathMention).getTypeArgument(i)
  }

  override Type resolveType() {
    this instanceof ArrayTypeRepr and
    result = TArrayType()
    or
    this instanceof RefTypeRepr and
    result = TRefType()
    or
    result = this.(PathTypeRepr).getPath().(PathMention).resolveType()
  }

  override Type resolveTypeAt(TypePath path) {
    result = this.(PathTypeRepr).getPath().(PathMention).resolveTypeAt(path)
    or
    not exists(this.(PathTypeRepr).getPath()) and
    result = super.resolveTypeAt(path)
  }
}

/** Holds if `path` resolves to the type alias `alias` with the definition `rhs`. */
private predicate resolvePathAlias(Path path, TypeAlias alias, TypeReprMention rhs) {
  alias = resolvePath(path) and rhs = alias.getTypeRepr()
}

abstract class PathMention extends TypeMention, Path {
  override TypeMention getTypeArgument(int i) {
    result = this.getSegment().getGenericArgList().getTypeArg(i)
  }
}

class NonAliasPathMention extends PathMention {
  NonAliasPathMention() { not resolvePathAlias(this, _, _) }

  override TypeMention getTypeArgument(int i) {
    result = super.getTypeArgument(i)
    or
    // `Self` paths inside `impl` blocks have implicit type arguments that are
    // the type parameters of the `impl` block. For example, in
    //
    // ```rust
    // impl<T> Foo<T> {
    //   fn m(self) -> Self {
    //     self
    //   }
    // }
    // ```
    //
    // the `Self` return type is shorthand for `Foo<T>`.
    exists(ImplItemNode node |
      this = node.getASelfPath() and
      result = node.(ImplItemNode).getSelfPath().getSegment().getGenericArgList().getTypeArg(i)
    )
    or
    // If `this` is the trait of an `impl` block then any associated types
    // defined in the `impl` block are type arguments to the trait.
    //
    // For instance, for a trait implementation like this
    // ```rust
    // impl MyTrait for MyType {
    //      ^^^^^^^ this
    //   type AssociatedType = i64
    //                         ^^^ result
    //   // ...
    // }
    // ```
    // the rhs. of the type alias is a type argument to the trait.
    exists(ImplItemNode impl, AssociatedTypeTypeParameter param, TypeAlias alias |
      this = impl.getTraitPath() and
      param.getTrait() = resolvePath(this) and
      alias = impl.getASuccessor(param.getTypeAlias().getName().getText()) and
      result = alias.getTypeRepr() and
      param.getIndex() = i
    )
  }

  override Type resolveType() {
    exists(ItemNode i | i = resolvePath(this) |
      result = TStruct(i)
      or
      result = TEnum(i)
      or
      exists(TraitItemNode trait | trait = i |
        // If this is a `Self` path, then it resolves to the implicit `Self`
        // type parameter, otherwise it is a trait bound.
        if this = trait.getASelfPath()
        then result = TSelfTypeParameter(trait)
        else result = TTrait(trait)
      )
      or
      result = TTypeParamTypeParameter(i)
      or
      exists(TypeAlias alias | alias = i |
        result.(AssociatedTypeTypeParameter).getTypeAlias() = alias
        or
        result = alias.getTypeRepr().(TypeReprMention).resolveType()
      )
    )
  }
}

class AliasPathMention extends PathMention {
  TypeAlias alias;
  TypeReprMention rhs;

  AliasPathMention() { resolvePathAlias(this, alias, rhs) }

  /** Get the `i`th type parameter of the alias itself. */
  private TypeParameter getTypeParameter(int i) {
    result = TTypeParamTypeParameter(alias.getGenericParamList().getTypeParam(i))
  }

  override Type resolveType() { result = rhs.resolveType() }

  override Type resolveTypeAt(TypePath path) {
    result = rhs.resolveTypeAt(path) and
    not result = this.getTypeParameter(_)
    or
    exists(TypeParameter tp, TypeMention arg, TypePath prefix, TypePath suffix, int i |
      tp = rhs.resolveTypeAt(prefix) and
      tp = this.getTypeParameter(i) and
      arg = this.getTypeArgument(i) and
      result = arg.resolveTypeAt(suffix) and
      path = prefix.append(suffix)
    )
  }
}

// Used to represent implicit `Self` type arguments in traits and `impl` blocks,
// see `PathMention` for details.
class TypeParamMention extends TypeMention, TypeParam {
  override TypeReprMention getTypeArgument(int i) { none() }

  override Type resolveType() { result = TTypeParamTypeParameter(this) }
}

// Used to represent implicit type arguments for associated types in traits.
class TypeAliasMention extends TypeMention, TypeAlias {
  private Type t;

  TypeAliasMention() { t = TAssociatedTypeTypeParameter(this) }

  override TypeReprMention getTypeArgument(int i) { none() }

  override Type resolveType() { result = t }
}

/**
 * Holds if the `i`th type argument of `selfPath`, belonging to `impl`, resolves
 * to type parameter `tp`.
 *
 * Example:
 *
 * ```rust
 * impl<T> Foo<T> for Bar<T> { ... }
 * //      ^^^^^^ selfPath
 * //   ^         tp
 * ```
 */
pragma[nomagic]
private predicate isImplSelfTypeParam(
  ImplItemNode impl, PathMention selfPath, int i, TypeParameter tp
) {
  exists(PathMention path |
    selfPath = impl.getSelfPath() and
    path = selfPath.getSegment().getGenericArgList().getTypeArg(i).(PathTypeRepr).getPath() and
    tp = path.resolveType()
  )
}

class ImplMention extends TypeMention, ImplItemNode {
  override TypeReprMention getTypeArgument(int i) { none() }

  override Type resolveType() { result = TImpl(this) }

  override Type resolveTypeAt(TypePath path) {
    result = TImpl(this) and
    path.isEmpty()
    or
    // For example, in
    //
    // ```rust
    // struct S<T1>(T1);
    //
    // impl<T2> S<T2> { ... }
    // ```
    //
    // We get that the type path "0" resolves to `T1` for the `impl` block,
    // which is considered a base type mention of `S`.
    exists(PathMention selfPath, TypeParameter tp, int i |
      isImplSelfTypeParam(this, selfPath, pragma[only_bind_into](i), tp) and
      result = selfPath.resolveType().getTypeParameter(pragma[only_bind_into](i)) and
      path = TypePath::singleton(tp)
    )
  }
}

class TraitMention extends TypeMention, TraitItemNode {
  override TypeMention getTypeArgument(int i) {
    result = this.getTypeParam(i)
    or
    traitAliasIndex(this, i, result)
  }

  override Type resolveType() { result = TTrait(this) }
}

// NOTE: Since the implicit type parameter for the self type parameter never
// appears in the AST, we (somewhat arbitrarily) choose the name of a trait as a
// type mention. This works because there is a one-to-one correspondence between
// a trait and its name.
class SelfTypeParameterMention extends TypeMention, Name {
  Trait trait;

  SelfTypeParameterMention() { trait.getName() = this }

  Trait getTrait() { result = trait }

  override Type resolveType() { result = TSelfTypeParameter(trait) }

  override TypeReprMention getTypeArgument(int i) { none() }
}
