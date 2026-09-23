private import unified as Unified
private import Type
private import TypeInference
private import TypeInferencePlugin as Plugin
private import codeql.unified.internal.StaticNameBinding
private import codeql.unified.internal.ExprPositions

/** An AST node that mentions a type. */
abstract class TypeMention extends AstNode {
  /**
   * Gets the type mentioned at `path`.
   */
  pragma[nomagic]
  abstract Type getTypeAt(TypePath path);

  /**
   * Gets the type mentioned at the root of this type mention.
   */
  final Type getType() { result = this.getTypeAt(TypePath::nil()) }
}

private Type resolveType(Identifier access) {
  exists(NameBinding b | b = getStaticBindingTarget(access) |
    b = result.(ClassLikeDeclarationType).getClassLikeDeclaration().getNameNode()
    or
    b = result.(TypeParameterType).getTypeParameter().getNameNode()
  )
}

abstract private class ExprTypeMention extends TypeMention, Expr {
  ExprTypeMention() { isInTypeContext(this) }

  pragma[nomagic]
  abstract TypePath getTypeArgumentPath(int i);
}

/**
 * A type mention that resolves via an alias (aliases are expanded).
 */
private class AliasExprTypeMention extends ExprTypeMention {
  private TypeAliasDeclaration alias;

  AliasExprTypeMention() { alias.getNameNode() = getStaticBindingTarget(this) }

  private TypeParameterType getAliasTypeParameter(int i) {
    result.getTypeParameter() = alias.getTypeParameter(i)
  }

  override TypePath getTypeArgumentPath(int i) {
    exists(TypeParameterType tp |
      tp = this.getAliasTypeParameter(i) and
      tp = alias.getType().(TypeMention).getTypeAt(result)
    )
  }

  override Type getTypeAt(TypePath path) {
    result = alias.getType().(TypeMention).getTypeAt(path) and
    not result = this.getAliasTypeParameter(_)
  }
}

/**
 * A type mention that does not resolve via an alias.
 */
private class NonAliasExprTypeMention extends ExprTypeMention {
  NonAliasExprTypeMention() { not this instanceof AliasExprTypeMention }

  private Type getRootType0() {
    result = resolveType(this)
    or
    result = Plugin::getFunctionExprType(this)
    or
    result.(Plugin::TupleType).getArity() = this.(TupleExpr).getNumberOfElements()
  }

  Type getRootType() {
    result = this.getRootType0()
    or
    not exists(this.getRootType0()) and
    result instanceof UnknownType
  }

  override TypePath getTypeArgumentPath(int i) {
    result = TypePath::singleton(this.getRootType().getPositionalTypeParameter(i))
  }

  override Type getTypeAt(TypePath path) {
    result = this.getRootType() and
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
  }
}

private class GenericTypeExprTypeMention extends TypeMention, GenericTypeExpr {
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
}

/** A class declaration mentions itself. */
private class ClassLikeDeclarationTypeMention extends TypeMention, Identifier {
  private ClassLikeDeclaration c;

  ClassLikeDeclarationTypeMention() { this = c.getNameNode() }

  ClassLikeDeclarationType getRootType() { c = result.getClassLikeDeclaration() }

  ClassLikeDeclaration getClassLikeDeclaration() { result = c }

  override Type getTypeAt(TypePath path) {
    result = this.getRootType() and
    path.isEmpty()
    or
    result = this.getRootType().getATypeParameter() and
    path = TypePath::singleton(result)
  }
}

TypeMention getClassLikeDeclarationTypeMention(ClassLikeDeclaration c) {
  result = c.getNameNode()
  or
  result = c.getExtensionTarget()
}
