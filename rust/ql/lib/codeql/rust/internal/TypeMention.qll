/** Provides classes for representing type mentions, used in type inference. */

private import rust
private import Type
private import PathResolution
private import TypeInference

/** An AST node that may mention a type. */
abstract class TypeMention extends AstNode {
  /** Gets the type at `path` that this mention resolves to, if any. */
  abstract Type resolveTypeAt(TypePath path);

  /** Gets the type that this node resolves to, if any. */
  final Type resolveType() { result = this.resolveTypeAt(TypePath::nil()) }
}

class ArrayTypeReprMention extends TypeMention instanceof ArrayTypeRepr {
  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result = TArrayType()
    or
    exists(TypePath suffix |
      result = super.getElementTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(TArrayTypeParameter(), suffix)
    )
  }
}

class RefTypeReprMention extends TypeMention instanceof RefTypeRepr {
  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result = TRefType()
    or
    exists(TypePath suffix |
      result = super.getTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(TRefTypeParameter(), suffix)
    )
  }
}

class SliceTypeReprMention extends TypeMention instanceof SliceTypeRepr {
  override Type resolveTypeAt(TypePath path) {
    path.isEmpty() and
    result = TSliceType()
    or
    exists(TypePath suffix |
      result = super.getTypeRepr().(TypeMention).resolveTypeAt(suffix) and
      path = TypePath::cons(TSliceTypeParameter(), suffix)
    )
  }
}

/** Holds if `path` is used as a type mention during type inference. */
predicate relevantPathTypeMention(Path path) {
  path =
    [
      any(PathTypeRepr r).getPath(),
      any(StructExpr s).getPath().getQualifier*(),
      any(CallExpr ce).getFunction().(PathExpr).getPath().getQualifier*(),
      any(StructPat p).getPath(),
      any(TupleStructPat p).getPath()
    ]
}

abstract class PathTypeMention extends TypeMention, Path {
  PathTypeMention() { relevantPathTypeMention(this) }
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
  pragma[nomagic]
  override Type resolveTypeAt(TypePath typePath) {
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

class NonAliasPathTypeMention extends PathTypeMention {
  TypeItemNode resolved;

  NonAliasPathTypeMention() {
    resolved = [resolvePath(this), resolvePath(this).(Variant).getEnum().(TypeItemNode)] and
    not exists(resolved.(TypeAlias).getTypeRepr())
  }

  TypeItemNode getResolved() { result = resolved }

  /**
   * Gets a type alias with the name `name` of the trait that this path resolves
   * to, if any.
   */
  pragma[nomagic]
  private TypeAlias getResolvedTraitAlias(string name) {
    result = resolved.(TraitItemNode).getAnAssocItem() and
    name = result.getName().getText()
  }

  pragma[nomagic]
  private TypeRepr getAssocTypeArg(string name) {
    result = this.getSegment().getGenericArgList().getAssocTypeArg(name)
  }

  /** Gets the type argument for the associated type `alias`, if any. */
  pragma[nomagic]
  private TypeRepr getAnAssocTypeArgument(TypeAlias alias) {
    exists(string name |
      alias = this.getResolvedTraitAlias(name) and
      result = this.getAssocTypeArg(name)
    )
  }

  private TypeMention getPositionalTypeArgument0(int i) {
    result = this.getSegment().getGenericArgList().getTypeArg(i)
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
    // `Option::<i32>::Some` is valid in addition to `Option::Some::<i32>`
    resolvePath(this) instanceof Variant and
    result = this.getQualifier().getSegment().getGenericArgList().getTypeArg(i)
  }

  private TypeMention getPositionalTypeArgument(int i) {
    result = this.getPositionalTypeArgument0(i)
    or
    // If a type argument is not given in the path, then we use the default for
    // the type parameter if one exists for the type.
    not exists(this.getPositionalTypeArgument0(i)) and
    result = this.resolveRootType().getTypeParameterDefault(i) and
    // Defaults only apply to type mentions in type annotations
    this = any(PathTypeRepr ptp).getPath().getQualifier*()
  }

  /** Gets the type mention in this path for the type parameter `tp`, if any. */
  pragma[nomagic]
  private TypeMention getTypeMentionForTypeParameter(TypeParameter tp) {
    exists(int i |
      result = this.getPositionalTypeArgument(pragma[only_bind_into](i)) and
      tp = this.resolveRootType().getTypeParameter(pragma[only_bind_into](i))
    )
    or
    exists(TypeAlias alias |
      result = this.getAnAssocTypeArgument(alias) and
      tp = TAssociatedTypeTypeParameter(alias)
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
    exists(ImplItemNode impl, AssociatedTypeTypeParameter param, TypeAlias alias, string name |
      this = impl.getTraitPath() and
      param.getTrait() = resolved and
      name = param.getTypeAlias().getName().getText() and
      alias = impl.getASuccessor(pragma[only_bind_into](name)) and
      result = alias.getTypeRepr() and
      tp =
        TAssociatedTypeTypeParameter(resolved
              .(TraitItemNode)
              .getAssocItem(pragma[only_bind_into](name)))
    )
  }

  Type resolveRootType() {
    result = TStruct(resolved)
    or
    result = TEnum(resolved)
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
    result = TAssociatedTypeTypeParameter(resolved)
  }

  override Type resolveTypeAt(TypePath typePath) {
    typePath.isEmpty() and
    result = this.resolveRootType()
    or
    exists(TypeParameter tp, TypePath suffix |
      result = this.getTypeMentionForTypeParameter(tp).resolveTypeAt(suffix) and
      typePath = TypePath::cons(tp, suffix)
    )
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
    exists(TypeAlias alias |
      alias = super.getAnAssocItem() and
      typePath = TypePath::singleton(result) and
      result = TAssociatedTypeTypeParameter(alias)
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
