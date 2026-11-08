private import unified as Unified
private import Type
private import TypeInference
private import TypeInferencePlugin as Plugin
private import codeql.unified.internal.StaticNameBinding
private import codeql.unified.internal.ExprPositions

final class TypeMention = TypeMentionImpl;

/** An AST node that mentions a type. */
abstract private class TypeMentionImpl extends AstNode {
  /**
   * INTERNAL: Do not use; use `getTypeAt` instead.
   *
   * Gets the type mentioned at `path`, where type aliases are not expanded.
   */
  pragma[nomagic]
  abstract Type getUnexpandedTypeAt(TypePath path);

  /**
   * INTERNAL: Do not use; use `getType` instead.
   *
   * Gets the root type mentioned, where type aliases are not expanded.
   *
   * This is the same as `this.getUnexpandedTypeAt(TypePath::nil())`, but does not depend
   * on the full `getUnexpandedTypeAt` relation.
   */
  abstract Type getUnexpandedType();

  /**
   * Holds if an alias is referenced at `prefix`, and the alias declaration
   * mentions a type parameter that is not declared by the alias itself.
   *
   * In this case, the type `t` at `path` may be used to infer that type parameter,
   * because it occurs as a type qualifier.
   */
  pragma[nomagic]
  private predicate aliasRefHasEnclosingType(
    TypePath prefix, ParentTypeParameterType ptp, TypePath path, Type t
  ) {
    exists(AliasType alias, TypeParameter tp |
      alias = this.getUnexpandedTypeAt(prefix) and
      tp = alias.getAlias().getExpandedTypeAt(_) and
      not tp = alias.getATypeParameter()
    ) and
    exists(TypePath cons | cons.isCons(ptp, path) |
      t = this.getExpandedTypeAt(prefix.appendInverse(cons))
      or
      this.aliasRefHasEnclosingType(prefix, _, cons, t)
    )
  }

  pragma[nomagic]
  private predicate aliasRefHasEnclosingTypeInclBases(
    TypePath prefix, ParentTypeParameterType ptp, TypePath path, Type t
  ) {
    this.aliasRefHasEnclosingType(prefix, ptp, path, t)
    or
    exists(ClassLikeDeclarationType sub, TypeMention base |
      this.aliasRefHasEnclosingTypeInclBases(prefix, ptp, TypePath::nil(), sub) and
      base = sub.getClassLikeDeclaration().getABaseType().getType()
    |
      t = base.getExpandedTypeAt(path) and
      not t instanceof TypeParameter
      or
      exists(TypePath pathToTp, TypePath suffix, TypeParameter tp |
        tp = base.getExpandedTypeAt(pathToTp) and
        this.aliasRefHasEnclosingTypeInclBases(prefix, ptp,
          TypePath::singleton(tp).appendInverse(suffix), t) and
        path = pathToTp.append(suffix)
      )
    )
  }

  /**
   * Gets the type mentioned at `path`, including expanding type aliases.
   */
  private Type getExpandedTypeAt(TypePath path) {
    result = this.getUnexpandedTypeAt(path)
    or
    exists(AliasType alias, TypePath prefix, TypePath suffix |
      this.getUnexpandedTypeAt(prefix) = alias
    |
      // expand alias RHS
      result = alias.getAlias().getExpandedTypeAt(suffix) and
      path = prefix.append(suffix) and
      (
        not result instanceof TypeParameter
        or
        result.(TypeParameterType).getDeclaringItem() instanceof Unified::FunctionDeclaration
      )
      or
      // substitute for type parameters in alias RHS
      exists(TypeParameter tp, TypePath pathToTp |
        tp = alias.getAlias().getExpandedTypeAt(pathToTp) and
        path = prefix.append(pathToTp).append(suffix) and
        if tp = alias.getATypeParameter()
        then
          // explicit alias type parameter: `typealias Foo<T> = ...`
          exists(TypePath mid |
            result = this.getExpandedTypeAt(prefix.appendInverse(mid)) and
            mid.isCons(tp, suffix)
          )
        else
          // type parameter belonging to an enclosing type:
          //
          // class Base<T> {
          //   typealias X = T
          // }
          // class Sub : Base<Int>
          // let x : Sub.X // resolves to `Int`
          this.aliasRefHasEnclosingTypeInclBases(prefix, _,
            TypePath::singleton(tp).appendInverse(suffix), result)
      )
    )
  }

  private Type getExpandedType() { result = this.getExpandedTypeAt(TypePath::nil()) }

  /**
   * Gets the class-like declaration mentioned by this type mention, if any.
   */
  ClassLikeDeclaration getClassLikeDeclaration() {
    result = this.getExpandedType().(ClassLikeDeclarationType).getClassLikeDeclaration()
  }

  /**
   * Gets the type mentioned at `path`.
   */
  final Type getTypeAt(TypePath path) {
    result = this.getExpandedTypeAt(path) and
    // Filter away alias types that are expanded
    not exists(AliasType alias |
      (
        result = alias
        or
        result = alias.getATypeParameter()
      ) and
      // allow for alias types that cannot expand, for example accesses to `Identity`
      // cannot expand when `typealias Identity<T> = T`
      not result = unique( | | this.getExpandedTypeAt(path))
      or
      path.getElement(_) = alias.getATypeParameter()
    )
  }

  /**
   * Gets the type mentioned at the root of this type mention.
   */
  final Type getType() { result = this.getTypeAt(TypePath::nil()) }
}

class ExprTypeMention extends TypeMentionImpl, Expr {
  ExprTypeMention() {
    isInTypeContext(this) and
    not this instanceof GenericTypeExpr and
    not this instanceof ModifiedTypeExpr and
    not this = any(MemberAccessExpr mae).getMemberNameNode()
  }

  final override Type getUnexpandedTypeAt(TypePath path) {
    // recursion guard to check that `getUnexpandedType` does not recursively depend on `getUnexpandedTypeAt`
    (exists(this.getUnexpandedType()) implies any()) and
    result = this.getUnexpandedType() and
    path.isEmpty()
    or
    exists(
      ClassLikeDeclaration c, AssociatedTypeDeclaration a, ClassLikeDeclaration base,
      AssociatedTypeParameterType baseTp, string name
    |
      // protocol Base {
      //   associatedtype BaseTp
      // }
      associatedTypeParameterInherited(c, a, base, this, name) and
      baseTp = TAssociatedTypeParameterType(base, a, _)
    |
      // protocol Sub : Base {
      //                ^^^^ // `BaseTp` is instantiated with `BaseTp (inherited)`
      // }
      path = TypePath::singleton(baseTp) and
      result = TAssociatedTypeParameterType(c, a, true)
      or
      // struct S : Base {
      //            ^^^^ // `BaseTp` is instantiated with `String`
      //   typealias BaseTp = String
      // }
      exists(TypeAliasDeclaration alias, TypePath suffix |
        alias = c.getAMember() and
        alias.getName() = name and
        path = TypePath::cons(baseTp, suffix) and
        result = alias.getType().(TypeMention).getUnexpandedTypeAt(suffix)
      )
    )
    or
    exists(FunctionExpr fe, Type t, TypePath prefix, TypePath suffix |
      this = fe and
      t = Plugin::getFunctionExprType(fe) and
      path = prefix.append(suffix)
    |
      exists(int i |
        prefix = Plugin::getFunctionExprParameterTypePath(t, fe.getNumberOfParameters(), i) and
        result = fe.getParameter(i).getType().(TypeMention).getUnexpandedTypeAt(suffix)
      )
      or
      prefix = Plugin::getFunctionExprReturnTypePath(t) and
      result = fe.getReturnType().(TypeMention).getUnexpandedTypeAt(suffix)
    )
    or
    this =
      any(TupleExpr te |
        exists(Plugin::TupleType tt, int i, TypePath suffix |
          tt.getArity() = te.getNumberOfElements() and
          result = te.getElement(i).getValue().(TypeMention).getUnexpandedTypeAt(suffix) and
          path = TypePath::cons(tt.getPositionalTypeParameter(i), suffix)
        )
      )
    or
    // A mention of a nested type with an explicit qualifier
    exists(TypeMention qualifier, ParentTypeParameterType tp, TypePath suffix |
      qualifier = this.(MemberAccessExpr).getBase() and
      tp = this.getUnexpandedType().getATypeParameter() and
      path = TypePath::cons(tp, suffix) and
      result = qualifier.getUnexpandedTypeAt(suffix)
    )
    or
    // A mention of a nested type with an implicit qualifier (including at the
    // at the identifier that introduces the type)
    exists(Type nested, ParentTypeParameterType tp, TypeMention parent, TypePath suffix |
      nested = this.getUnexpandedType() and
      tp = nested.getATypeParameter() and
      path = TypePath::cons(tp, suffix) and
      result = parent.getUnexpandedTypeAt(suffix)
    |
      exists(ClassLikeDeclaration accessingClass |
        accessingClass = this.(UnqualifiedMemberAccess).getAccessingClass() and
        if accessingClass.getEnclosingClassResolved*() = nested.asClass()
        then parent = nested.asClass().getEnclosingClassResolved().getNameNode()
        else parent = accessingClass.getNameNode()
      )
      or
      this = nested.asClass().getNameNode() and
      parent = nested.asClass().getEnclosingClassResolved().getNameNode()
    )
    or
    // A mention of a generic type without explicit type arguments and within
    // the scope of the type, implicitly mentions all type parameters (including
    // at the identifer that introduces the type):
    //
    // ```swift
    // class Generic<T> {
    //     let x: Generic // short-hand for `Generic<T>
    // }
    // ```
    not this = any(GenericTypeExpr g).getBase() and
    not this instanceof FunctionExpr and
    not this instanceof TupleExpr and
    exists(ClassLikeDeclarationType t |
      t = this.getUnexpandedType() and
      result = t.getATypeParameter() and
      path = TypePath::singleton(result) and
      not result instanceof ParentTypeParameterType
    |
      isInSyntacticTypeContext(this) and
      this.getEnclosingClassResolved+() = t.getClassLikeDeclaration()
      or
      this = t.getNameNode()
    )
  }

  private Type getUnexpandedType0() {
    exists(Identifier i | i = getTypeFromRef(this) |
      result.getNameNode() = i and
      (
        not result instanceof AssociatedTypeParameterType
        or
        result = TAssociatedTypeParameterType(this.getEnclosingClass().resolve(), _, _)
      )
    )
    or
    result = Plugin::getFunctionExprType(this)
    or
    result.(Plugin::TupleType).getArity() = this.(TupleExpr).getNumberOfElements()
  }

  override Type getUnexpandedType() {
    result = this.getUnexpandedType0()
    or
    not exists(this.getUnexpandedType0()) and
    result instanceof UnknownType
  }

  pragma[nomagic]
  TypePath getTypeArgumentPath(int i) {
    result = TypePath::singleton(this.getUnexpandedType().getPositionalTypeParameter(i))
    or
    // `typealias Alias = Generic`
    this.getUnexpandedType() =
      any(AliasType alias |
        not exists(alias.getPositionalTypeParameter(_)) and
        not alias.getAlias() instanceof GenericTypeExpr and
        result = alias.getAlias().(ExprTypeMention).getTypeArgumentPath(i)
      )
  }
}

private class GenericTypeExprTypeMention extends TypeMentionImpl, GenericTypeExpr {
  private TypeMention base;

  GenericTypeExprTypeMention() { base = this.getBase() }

  pragma[nomagic]
  private Type getTypeArgumentAt(int i, TypePath path) {
    result = this.getTypeArgument(i).(TypeMention).getUnexpandedTypeAt(path)
  }

  override Type getUnexpandedTypeAt(TypePath path) {
    result = base.getUnexpandedTypeAt(path)
    or
    exists(int i, TypePath prefix, TypePath suffix |
      prefix = base.(ExprTypeMention).getTypeArgumentPath(i) and
      result = this.getTypeArgumentAt(i, suffix) and
      path = prefix.append(suffix)
    )
  }

  override Type getUnexpandedType() { result = base.getUnexpandedType() }
}

private class ModifiedTypeExprMention extends TypeMentionImpl instanceof ModifiedTypeExpr {
  private TypeMention base;

  ModifiedTypeExprMention() { base = ModifiedTypeExpr.super.getType() }

  override Type getUnexpandedType() { result = base.getUnexpandedType() }

  override Type getUnexpandedTypeAt(TypePath path) { result = base.getUnexpandedTypeAt(path) }
}

TypeMention getClassLikeDeclarationTypeMention(ClassLikeDeclaration c) {
  result = c.getNameNode()
  or
  result = c.getExtensionTarget()
}
