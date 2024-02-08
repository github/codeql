/** Provides the `Boolean` class. */

/**
 * A utility class that is equivalent to `boolean`.
 *
 * As opposed to `boolean`, this type does not require explicit binding.
 */
final class Boolean extends FinalBoolean {
  Boolean() { this = [true, false] }

  /** Returns either "true" or "false". */
  // reimplement to avoid explicit binding
  string toString() { result = super.toString() }
}

final private class FinalBoolean = boolean;
