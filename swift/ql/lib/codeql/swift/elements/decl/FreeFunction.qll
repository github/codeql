private import Function
private import Method

/**
 * A free (non-member) function.
 */
final class FreeFunction extends Function {
  FreeFunction() { not this instanceof Method }
}
