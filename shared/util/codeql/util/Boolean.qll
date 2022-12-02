/** Provides the `Boolean` class. */

/**
 * A utility class that is equivalent to `boolean`.
 *
 * As opposed to `boolean`, this type does not require explicit binding.
 */
class Boolean extends boolean {
  Boolean() { this = [true, false] }
}
