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
  TypeMention getMentionAt(TypePath path) {
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

class ArrayTypeReprMention extends TypeMention instanceof ArrayTypeRepr {
  override TypeMention getTypeArgument(int i) { result = super.getElementTypeRepr() and i = 0 }

  override Type resolveType() { result = TArrayType() }
}

class RefTypeReprMention extends TypeMention instanceof RefTypeRepr {
  override TypeMention getTypeArgument(int i) { result = super.getTypeRepr() and i = 0 }

  override Type resolveType() { result = TRefType() }
}

class PathTypeReprMention extends TypeMention instanceof PathTypeRepr {
  Path path;
  ItemNode resolved;

  PathTypeReprMention() {
    path = super.getPath() and
    // NOTE: This excludes unresolvable paths which is intentional as these
    // don't add value to the type inference anyway.
    resolved = resolvePath(path)
  }

  ItemNode getResolved() { result = resolved }

  pragma[nomagic]
  private TypeAlias getResolvedTraitAlias(string name) {
    exists(TraitItemNode trait |
      trait = resolvePath(path) and
      result = trait.getAnAssocItem() and
      name = result.getName().getText()
    )
  }

  pragma[nomagic]
  private TypeRepr getAssocTypeArg(string name) {
    result = path.getSegment().getGenericArgList().getAssocTypeArg(name)
  }

  /** Gets the type argument for the associated type `alias`, if any. */
  pragma[nomagic]
  private TypeRepr getAnAssocTypeArgument(TypeAlias alias) {
    exists(string name |
      alias = this.getResolvedTraitAlias(name) and
      result = this.getAssocTypeArg(name)
    )
  }

  override TypeMention getTypeArgument(int i) {
    result = path.getSegment().getGenericArgList().getTypeArg(i)
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
      path = node.getASelfPath() and
      result = node.(ImplItemNode).getSelfPath().getSegment().getGenericArgList().getTypeArg(i)
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
    exists(ImplItemNode impl, AssociatedTypeTypeParameter param, TypeAlias alias |
      path = impl.getTraitPath() and
      param.getTrait() = resolved and
      alias = impl.getASuccessor(param.getTypeAlias().getName().getText()) and
      result = alias.getTypeRepr() and
      param.getIndex() = i
    )
    or
    exists(TypeAlias alias |
      result = this.getAnAssocTypeArgument(alias) and
      traitAliasIndex(_, i, alias)
    )
  }

  /**
   * Holds if this path resolved to a type alias with a rhs. that has the
   * resulting type at `typePath`.
   */
  Type aliasResolveTypeAt(TypePath typePath) {
    exists(TypeAlias alias, TypeMention rhs | alias = resolved and rhs = alias.getTypeRepr() |
      result = rhs.resolveTypeAt(typePath) and
      not result = pathGetTypeParameter(alias, _)
      or
      exists(TypeParameter tp, TypeMention arg, TypePath prefix, TypePath suffix, int i |
        tp = rhs.resolveTypeAt(prefix) and
        tp = pathGetTypeParameter(alias, i) and
        arg = path.getSegment().getGenericArgList().getTypeArg(i) and
        result = arg.resolveTypeAt(suffix) and
        typePath = prefix.append(suffix)
      )
    )
  }

  override Type resolveType() {
    result = this.aliasResolveTypeAt(TypePath::nil())
    or
    not exists(resolved.(TypeAlias).getTypeRepr()) and
    (
      result = TStruct(resolved)
      or
      result = TEnum(resolved)
      or
      exists(TraitItemNode trait | trait = resolved |
        // If this is a `Self` path, then it resolves to the implicit `Self`
        // type parameter, otherwise it is a trait bound.
        if super.getPath() = trait.getASelfPath()
        then result = TSelfTypeParameter(trait)
        else result = TTrait(trait)
      )
      or
      result = TTypeParamTypeParameter(resolved)
      or
      exists(TypeAlias alias | alias = resolved |
        result.(AssociatedTypeTypeParameter).getTypeAlias() = alias
        or
        result = alias.getTypeRepr().(TypeMention).resolveType()
      )
    )
  }

  override Type resolveTypeAt(TypePath typePath) {
    result = this.aliasResolveTypeAt(typePath)
    or
    not exists(resolved.(TypeAlias).getTypeRepr()) and
    result = super.resolveTypeAt(typePath)
  }
}

class ImplTraitTypeReprMention extends TypeMention instanceof ImplTraitTypeRepr {
  override TypeMention getTypeArgument(int i) { none() }

  override ImplTraitType resolveType() { result.getImplTraitTypeRepr() = this }
}

private TypeParameter pathGetTypeParameter(TypeAlias alias, int i) {
  result = TTypeParamTypeParameter(alias.getGenericParamList().getTypeParam(i))
}

// Used to represent implicit `Self` type arguments in traits and `impl` blocks,
// see `PathMention` for details.
class TypeParamMention extends TypeMention instanceof TypeParam {
  override TypeMention getTypeArgument(int i) { none() }

  override Type resolveType() { result = TTypeParamTypeParameter(this) }
}

// Used to represent implicit type arguments for associated types in traits.
class TypeAliasMention extends TypeMention instanceof TypeAlias {
  private Type t;

  TypeAliasMention() { t = TAssociatedTypeTypeParameter(this) }

  override TypeMention getTypeArgument(int i) { none() }

  override Type resolveType() { result = t }
}

class TraitMention extends TypeMention instanceof TraitItemNode {
  override TypeMention getTypeArgument(int i) {
    result = super.getTypeParam(i)
    or
    traitAliasIndex(this, i, result)
  }

  override Type resolveType() { result = TTrait(this) }
}

// NOTE: Since the implicit type parameter for the self type parameter never
// appears in the AST, we (somewhat arbitrarily) choose the name of a trait as a
// type mention. This works because there is a one-to-one correspondence between
// a trait and its name.
class SelfTypeParameterMention extends TypeMention instanceof Name {
  Trait trait;

  SelfTypeParameterMention() { trait.getName() = this }

  Trait getTrait() { result = trait }

  override Type resolveType() { result = TSelfTypeParameter(trait) }

  override TypeMention getTypeArgument(int i) { none() }
}
