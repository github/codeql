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

 /**
  * Gets the pluralization for `n` occurrences of `noun`.
  *
  * For example, the pluralization of `"function"` for `n = 2` is `"functions"`.
  */
bindingset[noun, n]
string pluralize(string noun, int n) {
  if n = 1 then
    result = noun
  else
    result = noun + "s"
}