predicate non_us_word(string wrong, string right) {
  exists(string s |
    wrong = s.splitAt("/", 0) and
    right = s.splitAt("/", 1) and
    s =
      [
        "colour/color", "authorise/authorize", "analyse/analyze", "behaviour/behavior",
        "modelling/modeling", "modelled/modeled"
      ]
  )
}

bindingset[s]
predicate contains_non_us_spelling(string s, string wrong, string right) {
  non_us_word(wrong, right) and
  (
    s.matches("%" + wrong + "%") and
    wrong != "analyse"
    or
    // analyses (as a noun) is fine
    s.regexpMatch(".*analyse[^s].*") and
    wrong = "analyse"
  )
}
