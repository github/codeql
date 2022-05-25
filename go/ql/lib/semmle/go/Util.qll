/** This module provides general utility classes and predicates. */

/**
 * A Boolean value.
 *
 * This is a self-binding convenience wrapper for `boolean`.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}

/**
 * Gets a regexp pattern that matches common top-level domain names.
 */
string commonTLD() {
  // according to ranking by http://google.com/search?q=site:.<<TLD>>
  result = "(?:com|org|edu|gov|uk|net|io)(?![a-z0-9])"
}
