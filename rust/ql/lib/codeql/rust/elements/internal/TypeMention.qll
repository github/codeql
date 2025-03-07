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

  /**
   * Like `resolveTypeAt`, but also resolves `Self` mentions to the implicit
   * `Self` type parameter.
   *
   * This is only needed when resolving types for calls to methods; inside the
   * methods themselves, `Self` only resolves to the relevant trait or type
   * being implemented.
   */
  final Type resolveTypeAtInclSelf(TypePath path) {
    result = this.resolveTypeAt(path)
    or
    exists(TypeMention tm, ImplOrTraitItemNode node |
      tm = this.getMentionAt(path) and
      result = TSelfTypeParameter()
    |
      tm = node.getASelfPath()
      or
      tm.(PathTypeRepr).getPath() = node.getASelfPath()
    )
  }
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
}

class PathMention extends TypeMention, Path {
  override TypeMention getTypeArgument(int i) {
    result = this.getPart().getGenericArgList().getTypeArgument(i)
    or
    // `Self` paths inside traits and `impl` blocks have implicit type arguments
    // that are the type parameters of the trait or impl. For example, in
    //
    // ```rust
    // impl Foo<T> {
    //   fn m(self) -> Self {
    //     self
    //   }
    // }
    // ```
    //
    // the `Self` return type is shorthand for `Foo<T>`.
    exists(ImplOrTraitItemNode node | this = node.getASelfPath() |
      result = node.(ImplItemNode).getSelfPath().getPart().getGenericArgList().getTypeArgument(i)
      or
      result = node.(Trait).getGenericParamList().getTypeParam(i)
    )
  }

  override Type resolveType() {
    exists(ItemNode i | i = resolvePath(this) |
      result = TStruct(i)
      or
      result = TEnum(i)
      or
      result = TTrait(i)
      or
      result = TTypeParamTypeParameter(i)
      or
      result = i.(TypeAlias).getTypeRepr().(TypeReprMention).resolveType()
    )
  }
}

// Used to represent implicit `Self` type arguments in traits and `impl` blocks,
// see `PathMention` for details.
class TypeParamMention extends TypeMention, TypeParam {
  override TypeReprMention getTypeArgument(int i) { none() }

  override Type resolveType() { result = TTypeParamTypeParameter(this) }
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
    path = selfPath.getPart().getGenericArgList().getTypeArgument(i).(PathTypeRepr).getPath() and
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
