private import unified as Unified
private import Type
private import TypeInference
private import TypeInferencePlugin as Plugin
private import codeql.unified.internal.StaticNameBinding
private import codeql.unified.internal.ExprPositions

/**
 * Holds if `alias` is an alias at `pathToNested` for nested type `nested` with
 * enclosing type `parent`, where the alias itself is also enclosed by `parent`:
 *
 * ```swift
 * class Parent {
 *   class Nested {}
 *   typealias Alias = Nested       // example
 *   class MoreNested {
 *      typealias Alias = Nested    // example
 *   }
 * }
 * typealias Alias = Parent.Nested  // non-example
 * ```
 *
 * The type path `pathParents` is any valid sequence of `ParentTypeParameterType`s starting
 * from the alias declaration and not escaping `parent`, while `encl` is the enclosing
 * class of the last element of `path`.
 *
 * Restricted to aliases without a qualifier for `nested`.
 */
private predicate isInnerUnqualifiedAlias(
  TypeAliasDeclaration alias, TypePath pathToNested, ClassLikeDeclaration nested,
  ClassLikeDeclaration parent, TypePath pathParents, ClassLikeDeclaration encl
) {
  nested = alias.getType().(TypeMention).getSimpleExpandedTypeAt(pathToNested).asClass() and
  // if the alias already has a qualifier that mentions the parent type, then we assume
  // it applies
  not exists(ParentTypeParameterType ptp |
    ptp.getParent() = parent and
    exists(
      alias
          .getType()
          .(TypeMention)
          .getSimpleExpandedTypeAt(pathToNested.append(TypePath::singleton(ptp)))
    )
  ) and
  parent = nested.getEnclosingClassResolved() and
  alias.getEnclosingClassResolved+() = parent and
  pathParents = TypePath::singleton(TParentTypeParameterType(alias)) and
  encl = alias.getEnclosingClassResolved()
  or
  exists(TypePath mid, ClassLikeDeclaration enclMid |
    isInnerUnqualifiedAlias(alias, pathToNested, nested, parent, mid, enclMid) and
    not enclMid = parent and
    pathParents = mid.append(TypePath::singleton(TParentTypeParameterType(enclMid))) and
    encl = enclMid.getEnclosingClassResolved()
  )
}

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
   * INTERNAL: Do not use; use `getType` instead.
   *
   * Gets the type mentioned at `path`, including expanding type aliases, but without
   * expanding inner unqualified aliases with qualifiers provided at the use sites.
   */
  Type getSimpleExpandedTypeAt(TypePath path) {
    result = this.getUnexpandedTypeAt(path)
    or
    exists(AliasType alias, TypePath prefix, TypePath suffix |
      this.getSimpleExpandedTypeAt(prefix) = alias
    |
      // expand alias RHS
      result = alias.getAlias().getSimpleExpandedTypeAt(suffix) and
      path = prefix.append(suffix) and
      not result = alias.getATypeParameter()
      or
      // substitute for type parameters in alias RHS
      exists(TypeParameter tp, TypePath mid |
        tp = alias.getATypeParameter() and
        tp = alias.getAlias().getSimpleExpandedTypeAt(mid) and
        result =
          this.getSimpleExpandedTypeAt(prefix
                .appendInverse(any(TypePath cons | cons.isCons(tp, suffix)))) and
        path = prefix.append(mid).append(suffix)
      )
    )
  }

  /**
   * Same as `getSimpleExpandedTypeAt`, but also handles inner unqualified aliases where
   * the qualifier is provided at the use site:
   *
   * ```swift
   * class Parent<TParent> {
   *   class Nested {}
   *   class MoreNested {
   *      typealias Alias = Nested
   *   }
   * }
   *
   * // this will expand to `Parent<String>.Nested`
   * let x : Parent<String>.MoreNested.Alias = ...
   * ```
   */
  private Type getExpandedTypeAt(TypePath path) {
    result = this.getSimpleExpandedTypeAt(path)
    or
    exists(
      AliasType alias, TypePath prefix, TypePath pathToNested, ClassLikeDeclaration nested,
      ClassLikeDeclaration parent, TypePath pathParents, TypePath suffix
    |
      this.getExpandedTypeAt(prefix) = alias and
      isInnerUnqualifiedAlias(alias.getTypeAliasDeclaration(), pathToNested, nested, parent,
        pathParents, _) and
      this.getExpandedTypeAt(prefix.append(pathParents)).asClass().getABaseClass*() = parent and
      result = this.getExpandedTypeAt(prefix.append(pathParents).appendInverse(suffix)) and
      path =
        prefix.append(pathToNested.append(TypePath::cons(TParentTypeParameterType(nested), suffix)))
    )
  }

  private Type getExpandedType() { result = this.getExpandedTypeAt(TypePath::nil()) }

  /**
   * Gets the class-like declaration mentioned by this type mention, if any.
   */
  ClassLikeDeclaration getClassLikeDeclaration() {
    result = this.getExpandedType().(ClassLikeDeclarationType).getClassLikeDeclaration()
  }

  pragma[nomagic]
  private ClassLikeDeclaration getImplicitQualifierCand(TypePath path, ParentTypeParameterType tp) {
    exists(Type t |
      tp = t.getATypeParameter() and
      t = this.getTypeAt(path) and
      not exists(this.getExpandedTypeAt(path.append(TypePath::singleton(tp)))) and
      result = this.getEnclosingClassResolved+()
    )
  }

  /**
   * Gets the type mentioned at `path`.
   */
  final Type getTypeAt(TypePath path) {
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
    ) and
    (
      result = this.getExpandedTypeAt(path)
      or
      // A mention of a nested type without an explicit qualifier implicitly mentions
      // the parent type (including at the identifer that introduces the type)
      //
      // ```swift
      // class Outer {
      //     class Inner {
      //         let y: Inner // short-hand for `Outer.Inner`
      //     }
      // }
      // ```
      exists(
        TypePath prefix, ClassLikeDeclaration parent, ParentTypeParameterType tp, TypePath suffix,
        ClassLikeDeclaration encl
      |
        encl = this.getImplicitQualifierCand(prefix, tp) and
        parent = tp.getParent() and
        result = encl.getNameNode().(TypeMention).getTypeAt(suffix) and
        path = prefix.append(TypePath::cons(tp, suffix))
      |
        encl = parent
        or
        not parent = this.getEnclosingClassResolved+() and
        encl.getABaseClass+() = parent
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
      exists(TypePath prefix, ClassLikeDeclarationType t |
        t = this.getTypeAt(prefix) and
        forex(TypeParameter tp |
          tp = t.getATypeParameter() and not tp instanceof ParentTypeParameterType
        |
          not exists(this.getExpandedTypeAt(prefix.append(TypePath::singleton(tp))))
        ) and
        t.getClassLikeDeclaration() = this.getEnclosingClassResolved+() and
        result = t.getATypeParameter() and
        path = prefix.append(TypePath::singleton(result)) and
        not result instanceof ParentTypeParameterType
      |
        isInSyntacticTypeContext(this) or this = t.getNameNode()
      )
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
    base = this.getBase() and
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
