/**
 * Provides general-purpose utility predicates.
 */

 /**
  * Gets the capitalization of `s`.
  *
  * For example, the capitalization of `"function"` is `"Function"`.
  */
bindingset[s]
string capitalize(string s) {
  result = s.charAt(0).toUpperCase() + s.suffix(1)
}
