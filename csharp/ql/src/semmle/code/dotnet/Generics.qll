/** Provides classes for generic types and methods. */
import Declaration

/**
 * A generic declaration. Either an unbound generic (`UnboundGeneric`) or a
 * constructed generic (`ConstructedGeneric`).
 */
abstract class Generic extends Declaration, @dotnet_generic { }

/** An unbound generic. */
abstract class UnboundGeneric extends Generic {
  /** Gets the `i`th type parameter, if any. */
  abstract TypeParameter getTypeParameter(int i);

  /** Gets a type parameter, if any. */
  TypeParameter getATypeParameter() { result=getTypeParameter(_) }

  /**
   * Gets one of the constructed versions of this declaration,
   * which has been bound to a specific set of types.
   */
  ConstructedGeneric getAConstructedGeneric() {
    result.getUnboundGeneric() = this
  }

  /** Gets the total number of type parameters. */
  int getNumberOfTypeParameters() {
    result = count(int i | exists(this.getTypeParameter(i)))
  }

  /** Gets the type parameters as a comma-separated string. */
  language [monotonicAggregates]
  string typeParametersToString() {
    result = concat(int i |
      exists(this.getTypeParameter(i)) |
      this.getTypeParameter(i).toStringWithTypes(), ", " order by i asc
    )
  }
}

/** A constructed generic. */
abstract class ConstructedGeneric extends Generic {
  /** Gets the `i`th type argument, if any. */
  abstract Type getTypeArgument(int i);

  /** Gets a type argument, if any. */
  Type getATypeArgument() { result=getTypeArgument(_) }

  /** Gets the unbound generic declaration from which this declaration was constructed. */
  UnboundGeneric getUnboundGeneric() { none() }

  /** Gets the total number of type arguments. */
  int getNumberOfTypeArguments() {
    result = count(int i | exists(this.getTypeArgument(i)))
  }

  /** Gets the type arguments as a comma-separated string. */
  language [monotonicAggregates]
  string typeArgumentsToString() {
    result = concat(int i |
      exists(this.getTypeArgument(i)) |
      this.getTypeArgument(i).toStringWithTypes(), ", " order by i asc
    )
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Constructs the label suffix for a generic method or type.
 */
string getGenericsLabel(Declaration d) {
  result = "`" + d.(UnboundGeneric).getNumberOfTypeParameters()
  or
  result = "<" + typeArgs(d) + ">"
  or
  not d instanceof Generic and result = ""
}

language[monotonicAggregates]
private string typeArgs(ConstructedGeneric generic) {
  result = concat(int p | exists(generic.getTypeArgument(p)) | generic.getTypeArgument(p).getLabel(), ",")
}
