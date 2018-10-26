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

/**
 * Gets `str` or a truncated version of `str` with `explanation` appended if its length exceeds `maxLength`.
 *
 * For example, the truncation of `"long_string"` for `maxLength = 5` and explanation `" ..."` is `"long_ ..."`.
 */
bindingset[str, maxLength, explanation]
string truncate(string str, int maxLength, string explanation) {
  if str.length() > maxLength then result = str.prefix(maxLength) + explanation else result = str
}
