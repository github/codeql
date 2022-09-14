import ql
private import NodeName
private import codeql.typos.TypoDatabase

predicate misspelling(string wrong, string right, string mistake) {
  mistake = "common misspelling" and
  (typos(wrong, right) or additional_typos(wrong, right))
  or
  mistake = "non-US spelling" and
  non_us_spelling(wrong, right)
}

predicate additional_typos(string wrong, string right) {
  wrong = "tranformer" and right = "transformer"
}

/**
 * Holds if `word` is an acceptable spelling that would otherwise be considered
 * a mistake by the typo database.
 */
predicate isAllowed(string word) {
  word =
    [
      "asign", // 'sign of a', not 'assign'
      "larg", // 'left argument', not 'large'
      "nto", // some comments refer to the variable `nTo`
      "thn" // deliberate misspelling of 'then' to avoid using a keyword
    ]
}

predicate non_us_spelling(string wrong, string right) {
  exists(string s |
    wrong = s.splitAt("/", 0) and
    right = s.splitAt("/", 1) and
    s =
      [
        "colour/color", "authorise/authorize", "authorises/authorizes", "authorised/authorized",
        "analyse/analyze", "analysed/analyzed", "behaviour/behavior", "modelling/modeling",
        "modelled/modeled"
      ]
  )
}

/**
 * Gets a word in the camel-case string `s`. For example, if `s` is
 * `"getFooBar"`, it returns `"get"`, `"Foo"`, and `"Bar"`.
 */
bindingset[s]
string getACamelCaseWord(string s) { result = s.regexpFind("(^[a-z]+)|([A-Z][a-z]+)", _, _) }

bindingset[s]
string getACommentWord(string s) { result = s.regexpFind("\\b\\w+\\b", _, _) }

string getAWord(AstNode node, string kind) {
  result = getACommentWord(node.(Comment).getContents()).toLowerCase() and
  kind = "comment"
  or
  exists(string nodeKind |
    result = getACamelCaseWord(getName(node, nodeKind)).toLowerCase() and
    kind = nodeKind + " name"
  )
}

predicate misspelled_element(AstNode node, string kind, string wrong, string right, string mistake) {
  wrong = getAWord(node, kind) and
  misspelling(wrong, right, mistake) and
  not isAllowed(wrong) and
  not node.hasAnnotation("deprecated")
}
