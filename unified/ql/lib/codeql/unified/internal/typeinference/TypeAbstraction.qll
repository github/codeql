private import unified as Unified
private import Type

/**
 * A type abstraction. I.e., a place in the program where type variables may
 * be introduced.
 */
abstract class TypeAbstraction extends AstNode {
  abstract TypeParameter getATypeParameter();
}

/**
 * A class-like declaration. Unlike `ClassLikeDeclarationType`, this includes
 * declarations that do not define a new type, such as `extension`s in Swift.
 */
private class ClassLikeDeclarationTypeAbstraction extends TypeAbstraction instanceof Unified::ClassLikeDeclaration
{
  override TypeParameter getATypeParameter() { this = result.getDeclaringItem() }
}
