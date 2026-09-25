/** Provides classes representing types without type arguments. */

import unified // reexport in order to shadow e.g. the `TypeParameter` class
private import unified as Unified
private import TypeInference
private import codeql.unified.internal.StaticNameBinding

/**
 * Holds if `a` is an associated type of `c`, in which case we model it
 * as a type parameter.
 *
 * `inherited` indicates whether the associated type is declared in `c`
 * or inherited from a base class.
 */
private predicate associatedTypeParameter(
  ClassLikeDeclaration c, AssociatedTypeDeclaration a, boolean inherited
) {
  a = c.getAMember() and
  inherited = false
  or
  exists(string name |
    associatedTypeParameterInherited(c, a, _, _, name) and
    not c.getAMember().(TypeAliasDeclaration).getName() = name and
    inherited = true
  )
}

pragma[nomagic]
predicate associatedTypeParameterInherited(
  ClassLikeDeclaration c, AssociatedTypeDeclaration a, ClassLikeDeclaration base, Expr baseRef,
  string name
) {
  associatedTypeParameter(base, a, _) and
  baseRef = c.getABaseType().getType() and
  base.getNameNode() = getStaticBindingTargetFromRef(baseRef) and
  name = a.getName()
}

cached
newtype TType =
  TClassLikeDeclarationType(ClassLikeDeclaration c) {
    CachedStage::ref() and
    exists(c.getNameNode())
  } or
  TClosureParameterPseudoType(Parameter p) {
    exists(FunctionExpr fe |
      p = fe.getAParameter() and
      not exists(p.getType())
    )
  } or
  TTypeParameterType(Unified::TypeParameter tp) or
  TAssociatedTypeParameterType(
    ClassLikeDeclaration c, AssociatedTypeDeclaration a, boolean inherited
  ) {
    associatedTypeParameter(c, a, inherited)
  } or
  TUnknownType() or
  TUnknownTypeTypeParameter(int i) { i in [0 .. 20] }

final class Type = TypeImpl;

/**
 * A type without type arguments.
 */
abstract private class TypeImpl extends TType {
  /**
   * Gets the `i`th positional type parameter of this type, if any.
   *
   * This excludes synthetic type parameters, such as associated types.
   */
  abstract TypeParameter getPositionalTypeParameter(int i);

  /**
   * Gets a type parameter of this type.
   *
   * This includes both positional type parameters and synthetic type parameters,
   * such as associated types.
   */
  TypeParameter getATypeParameter() { result = this.getPositionalTypeParameter(_) }

  /** Gets a textual representation of this type. */
  abstract string toString();

  /** Gets the location of this type. */
  abstract Location getLocation();
}

/**
 * A type representing a class-like declaration.
 */
class ClassLikeDeclarationType extends TypeImpl, TClassLikeDeclarationType {
  ClassLikeDeclaration c;

  ClassLikeDeclarationType() { this = TClassLikeDeclarationType(c) }

  ClassLikeDeclaration getClassLikeDeclaration() { result = c }

  string getName() { result = c.getName() }

  override TypeParameter getPositionalTypeParameter(int i) {
    result = TTypeParameterType(c.getTypeParameter(i))
  }

  override TypeParameter getATypeParameter() {
    result = super.getATypeParameter()
    or
    result = TAssociatedTypeParameterType(c, _, _)
  }

  override string toString() { result = c.getName() }

  override Location getLocation() { result = c.getLocation() }
}

/**
 * A pseudo type that does not correspond to any concrete type in the source code.
 */
abstract class PseudoType extends TypeImpl { }

/**
 * A type representing an unknown type.
 */
class UnknownType extends PseudoType, TUnknownType {
  override TypeParameter getPositionalTypeParameter(int i) { result = TUnknownTypeTypeParameter(i) }

  override string toString() { result = "(unknown type)" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A type representing a closure parameter.
 */
class ClosureParameterPseudoType extends PseudoType, TClosureParameterPseudoType {
  private Parameter param;

  ClosureParameterPseudoType() { this = TClosureParameterPseudoType(param) }

  Parameter getParam() { result = param }

  override TypeParameter getPositionalTypeParameter(int i) { none() }

  override string toString() { result = "(closure parameter " + param + ")" }

  override Location getLocation() { result = param.getLocation() }
}

/** A type parameter. */
abstract class TypeParameter extends TypeImpl {
  override TypeParameter getPositionalTypeParameter(int i) { none() }

  abstract AstNode getDeclaringItem();
}

private class IdAstNode =
  @unified_type_parameter or @unified_class_like_declaration or @unified_associated_type_declaration;

private predicate id(IdAstNode x, IdAstNode y) { x = y }

private predicate idOf(IdAstNode x, int y) = equivalenceRelation(id/2)(x, y)

int idOfTypeParameterAstNode(AstNode node) { idOf(node, result) }

/** A type parameter from source code. */
class TypeParameterType extends TypeParameter, TTypeParameterType {
  private Unified::TypeParameter typeParam;

  TypeParameterType() { this = TTypeParameterType(typeParam) }

  Unified::TypeParameter getTypeParameter() { result = typeParam }

  override ClassLikeDeclaration getDeclaringItem() { typeParam = result.getATypeParameter() }

  override string toString() { result = typeParam.getName() }

  override Location getLocation() { result = typeParam.getLocation() }
}

/**
 * An associated type viewed as a type parameter.
 */
class AssociatedTypeParameterType extends TypeParameter, TAssociatedTypeParameterType {
  private Unified::ClassLikeDeclaration c;
  private Unified::AssociatedTypeDeclaration assocTypeDecl;
  private boolean inherited;

  AssociatedTypeParameterType() { this = TAssociatedTypeParameterType(c, assocTypeDecl, inherited) }

  Unified::AssociatedTypeDeclaration getAssociatedTypeDeclaration() { result = assocTypeDecl }

  override ClassLikeDeclaration getDeclaringItem() { result = c }

  override string toString() {
    if inherited = true
    then result = assocTypeDecl.getName() + " (inherited)"
    else result = assocTypeDecl.getName()
  }

  override Location getLocation() {
    if inherited = true then result = c.getLocation() else result = assocTypeDecl.getLocation()
  }
}

/**
 * A type parameter of the special `UnknownType`.
 */
class UnknownTypeTypeParameter extends TypeParameter, TUnknownTypeTypeParameter {
  private int i;

  UnknownTypeTypeParameter() { this = TUnknownTypeTypeParameter(i) }

  override AstNode getDeclaringItem() { none() }

  override TypeParameter getPositionalTypeParameter(int j) { none() }

  override string toString() { result = "unknown type parameter " + i }

  override Location getLocation() { result instanceof EmptyLocation }
}
