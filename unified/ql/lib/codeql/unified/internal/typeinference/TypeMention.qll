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
   * Gets the type mentioned at the root of this type mention.
   *
   * This is the same as `this.getTypeAt(TypePath::nil())`, but does not depend
   * on the full `getTypeAt` relation.
   */
  abstract Type getType();

  /**
   * Gets the type mentioned at `path`.
   */
  pragma[nomagic]
  abstract Type getTypeAt(TypePath path);

  /** Gets the explicit qualifier of this type mention, if any. */
  abstract TypeMention getQualifier();

  /** Holds if this type mention has an explicit qualifier. */
  abstract predicate hasQualifier();
}

final class ExprTypeMention = ExprTypeMentionImpl;

abstract private class ExprTypeMentionImpl extends TypeMentionImpl, Expr {
  ExprTypeMentionImpl() {
    isInTypeContext(this) and
    not this instanceof GenericTypeExpr and
    not this = any(MemberAccessExpr mae).getMemberNameNode()
  }

  pragma[nomagic]
  abstract TypePath getTypeArgumentPath(int i);

  abstract Type getTypeAtImpl(TypePath path);

  final override Type getTypeAt(TypePath path) {
    // recursion guard to check that `getType` does not recursively depend on `getTypeAt`
    (exists(this.getType()) implies any()) and
    result = this.getTypeAtImpl(path)
    or
    exists(TypeMention qualifier, ClassLikeDeclaration cls, TypePath suffix |
      qualifier = this.getQualifier() and
      cls = this.getType().(ClassLikeDeclarationType).getClassLikeDeclaration() and
      path = TypePath::cons(TParentTypeParameterType(cls), suffix) and
      qualifier.getType().(ClassLikeDeclarationType).getClassLikeDeclaration().getABaseClass*() =
        cls.getEnclosingClassResolved() and
      result = qualifier.getTypeAt(suffix)
    )
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
    not this.hasQualifier() and
    not exists(TypeAliasDeclaration alias |
      this = alias.getType() or
      this = alias.getType().(GenericTypeExpr).getBase()
    ) and
    exists(
      ClassLikeDeclarationType rootType, ClassLikeDeclaration parent, ParentTypeParameterType tp,
      TypePath suffix
    |
      rootType = this.getType() and
      tp = TParentTypeParameterType(rootType.getClassLikeDeclaration()) and
      path = TypePath::cons(tp, suffix) and
      parent = this.getEnclosingClassResolved+() and
      result = parent.getNameNode().(TypeMention).getTypeAt(suffix)
    |
      parent = tp.getParent()
      or
      not tp.getParent() = this.getEnclosingClassResolved+() and
      parent.getABaseClass+() = tp.getParent()
    )
  }
}

/**
 * A type mention that resolves via an alias (aliases are expanded).
 */
private class AliasExprTypeMention extends ExprTypeMentionImpl {
  private TypeAliasDeclaration alias;

  AliasExprTypeMention() { alias.getNameNode() = getTypeFromRef(this) }

  private TypeParameterType getAliasTypeParameter(int i) {
    result.getTypeParameter() = alias.getTypeParameter(i)
  }

  override TypePath getTypeArgumentPath(int i) {
    exists(TypeParameterType tp |
      tp = this.getAliasTypeParameter(i) and
      tp = alias.getType().(TypeMention).getTypeAt(result)
    )
  }

  private predicate aliasHasQualifier() { alias.getType().(TypeMention).hasQualifier() }

  override TypeMention getQualifier() {
    result = alias.getType().(TypeMention).getQualifier()
    or
    not this.aliasHasQualifier() and
    result = this.(MemberAccessExpr).getBase()
  }

  override predicate hasQualifier() {
    alias.getType().(TypeMention).hasQualifier()
    or
    this instanceof MemberAccessExpr
  }

  override Type getType() { result = alias.getType().(TypeMention).getType() }

  override Type getTypeAtImpl(TypePath path) {
    result = alias.getType().(TypeMention).getTypeAt(path) and
    not result = this.getAliasTypeParameter(_)
  }
}

/**
 * A type mention that does not resolve via an alias.
 */
private class NonAliasExprTypeMention extends ExprTypeMentionImpl {
  NonAliasExprTypeMention() { not this instanceof AliasExprTypeMention }

  private Type getRootType0() {
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

  override Type getType() {
    result = this.getRootType0()
    or
    not exists(this.getRootType0()) and
    result instanceof UnknownType
  }

  override TypePath getTypeArgumentPath(int i) {
    result = TypePath::singleton(this.getType().getPositionalTypeParameter(i))
  }

  override Type getTypeAtImpl(TypePath path) {
    result = this.getType() and
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
        result = alias.getType().(TypeMention).getTypeAt(suffix)
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
        result = fe.getParameter(i).getType().(TypeMention).getTypeAt(suffix)
      )
      or
      prefix = Plugin::getFunctionExprReturnTypePath(t) and
      result = fe.getReturnType().(TypeMention).getTypeAt(suffix)
    )
    or
    this =
      any(TupleExpr te |
        exists(Plugin::TupleType tt, int i, TypePath suffix |
          tt.getArity() = te.getNumberOfElements() and
          result = te.getElement(i).getValue().(TypeMention).getTypeAt(suffix) and
          path = TypePath::cons(tt.getPositionalTypeParameter(i), suffix)
        )
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
    exists(ClassLikeDeclarationType rootType |
      rootType = this.getType() and
      (isInTypeContextWithImplicitTypeArgs(this) or this = rootType.getNameNode()) and
      rootType.getClassLikeDeclaration() = this.getEnclosingClassResolved+() and
      result = rootType.getATypeParameter() and
      path = TypePath::singleton(result) and
      not result instanceof ParentTypeParameterType
    )
  }

  override TypeMention getQualifier() { result = this.(MemberAccessExpr).getBase() }

  override predicate hasQualifier() { this instanceof MemberAccessExpr }
}

private class GenericTypeExprTypeMention extends TypeMentionImpl, GenericTypeExpr {
  private ExprTypeMention base;

  GenericTypeExprTypeMention() { base = this.getBase() }

  pragma[nomagic]
  private Type getTypeArgumentAt(int i, TypePath path) {
    result = this.getTypeArgument(i).(TypeMention).getTypeAt(path)
  }

  override Type getTypeAt(TypePath path) {
    result = base.getTypeAt(path)
    or
    exists(int i, TypePath prefix, TypePath suffix |
      prefix = base.getTypeArgumentPath(i) and
      result = this.getTypeArgumentAt(i, suffix) and
      path = prefix.append(suffix)
    )
  }

  override Type getType() { result = base.getType() }

  override TypeMention getQualifier() { result = this.getBase().(TypeMention).getQualifier() }

  override predicate hasQualifier() { this.getBase().(TypeMention).hasQualifier() }
}

TypeMention getClassLikeDeclarationTypeMention(ClassLikeDeclaration c) {
  result = c.getNameNode()
  or
  result = c.getExtensionTarget()
}
