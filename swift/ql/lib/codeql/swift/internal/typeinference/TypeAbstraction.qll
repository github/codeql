private import Type

/**
 * A type abstraction. I.e., a place in the program where type variables may
 * be introduced.
 *
 * Example:
 *
 * ```swift
 * class C<A, B> { }
 * //     ^^^^^^ a type abstraction
 * ```
 */
abstract class TypeAbstraction extends AstNode {
  abstract TypeParameter getATypeParameter();
}

final class GenericContextTypeAbstraction extends TypeAbstraction, GenericContext {
  override TypeParameter getATypeParameter() {
    result.(GenericTypeParamDeclTypeParameter).getDecl() = this.getAGenericTypeParam()
    or
    result.(SelfTypeParameter).getProtocol() = this
    or
    result.(AssociatedTypeTypeParameter).getProtocol() = this
  }
}
