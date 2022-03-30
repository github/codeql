/**
 * Provides classes for .Net types.
 */

import Declaration
import Namespace
import Callable
import Generics

/**
 * A type. Either a value or reference type (`ValueOrRefType`), a type parameter (`TypeParameter`),
 * a pointer type (`PointerType`), or an array type (`ArrayType`).
 */
class Type extends Declaration, @dotnet_type {
  /** Gets the name of this type without additional syntax such as `[]`, `*`, or `<...>`. */
  override string getUndecoratedName() { none() }
}

/**
 * A value or reference type.
 */
class ValueOrRefType extends Type, @dotnet_valueorreftype {
  /** Gets the namespace declaring this type, if any. */
  Namespace getDeclaringNamespace() { none() }

  private string getPrefixWithTypes() {
    result = this.getDeclaringType().getLabel() + "."
    or
    if this.getDeclaringNamespace().isGlobalNamespace()
    then result = ""
    else result = this.getDeclaringNamespace().getQualifiedName() + "."
  }

  pragma[noinline]
  private string getLabelNonGeneric() {
    not this instanceof Generic and
    result = this.getPrefixWithTypes() + this.getUndecoratedName()
  }

  pragma[noinline]
  private string getLabelGeneric() {
    result = this.getPrefixWithTypes() + this.getUndecoratedName() + getGenericsLabel(this)
  }

  override string getLabel() {
    result = this.getLabelNonGeneric() or
    result = this.getLabelGeneric()
  }

  /** Gets a base type of this type, if any. */
  ValueOrRefType getABaseType() { none() }

  /** Holds if this type is a `record`. */
  predicate isRecord() { exists(RecordCloneCallable c | c.getDeclaringType() = this) }
}

/**
 * A type parameter, for example `T` in `System.Nullable<T>`.
 */
class TypeParameter extends Type, @dotnet_type_parameter {
  /** Gets the generic type or method declaring this type parameter. */
  UnboundGeneric getDeclaringGeneric() { this = result.getATypeParameter() }

  /** Gets the index of this type parameter. For example the index of `U` in `Func<T,U>` is 1. */
  int getIndex() { none() }

  final override string getLabel() { result = "!" + this.getIndex() }

  override string getUndecoratedName() { result = "!" + this.getIndex() }
}

/** A pointer type. */
class PointerType extends Type, @dotnet_pointer_type {
  /** Gets the type referred by this pointer type, for example `char` in `char*`. */
  Type getReferentType() { none() }

  override string getName() { result = this.getReferentType().getName() + "*" }

  final override string getLabel() { result = this.getReferentType().getLabel() + "*" }

  override string toStringWithTypes() { result = this.getReferentType().toStringWithTypes() + "*" }
}

/** An array type. */
class ArrayType extends ValueOrRefType, @dotnet_array_type {
  /** Gets the type of the array element. */
  Type getElementType() { none() }

  final override string getLabel() { result = this.getElementType().getLabel() + "[]" }

  override string toStringWithTypes() { result = this.getElementType().toStringWithTypes() + "[]" }

  override string getAPrimaryQlClass() { result = "ArrayType" }
}
