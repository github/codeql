/** Provides classes for generic types and methods. */

private import CIL
private import dotnet

/**
 * A generic declaration. Either an unbound generic (`UnboundGeneric`) or a
 * constructed generic (`ConstructedGeneric`).
 */
class Generic extends DotNet::Generic, Declaration, TypeContainer {
  Generic() {
    cil_type_parameter(this, _, _) or
    cil_type_argument(this, _, _)
  }
}

/** An unbound generic type or method. */
class UnboundGeneric extends Generic, DotNet::UnboundGeneric {
  UnboundGeneric() { cil_type_parameter(this, _, _) }

  final override TypeParameter getTypeParameter(int n) { cil_type_parameter(this, n, result) }
}

/** A constructed generic type or method. */
class ConstructedGeneric extends Generic, DotNet::ConstructedGeneric {
  ConstructedGeneric() { cil_type_argument(this, _, _) }

  final override Type getTypeArgument(int n) { cil_type_argument(this, n, result) }
}

/** An unbound generic type. */
class UnboundGenericType extends UnboundGeneric, Type { }

/** An unbound generic method. */
class UnboundGenericMethod extends UnboundGeneric, Method { }

/** A constructed generic type. */
class ConstructedType extends ConstructedGeneric, Type {
  final override UnboundGenericType getUnboundGeneric() { result = this.getUnboundType() }

  override predicate isInterface() { this.getUnboundType().isInterface() }

  override predicate isClass() { this.getUnboundType().isClass() }
}

/** A constructed generic method. */
class ConstructedMethod extends ConstructedGeneric, Method {
  final override UnboundGenericMethod getUnboundGeneric() { result = this.getUnboundMethod() }
}
