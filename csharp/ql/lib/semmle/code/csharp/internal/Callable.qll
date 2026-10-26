/**
 * INTERNAL: Do not use.
 *
 * Provides `Callable` classes, which are things that can be called
 * such as methods and operators.
 */

private import semmle.code.csharp.Callable
private import semmle.code.csharp.Property

/**
 * A callable that is declared as an extension.
 *
 * Either an extension method (`ExtensionMethod`), an extension operator
 * (`ExtensionOperator`) or an extension accessor (`ExtensionAccessor`).
 */
abstract class ExtensionCallableImpl extends Callable {
  /** Gets the type being extended by this method. */
  pragma[noinline]
  Type getExtendedType() { result = this.getDeclaringType().(ExtensionType).getExtendedType() }

  override string getAPrimaryQlClass() { result = "ExtensionCallable" }
}

/**
 * An extension method.
 *
 * Either a classic extension method (`ClassicExtensionMethod`) or an extension
 * type extension method (`ExtensionTypeExtensionMethod`).
 */
abstract class ExtensionMethodImpl extends ExtensionCallableImpl, Method {
  override string getAPrimaryQlClass() { result = "ExtensionMethod" }
}
