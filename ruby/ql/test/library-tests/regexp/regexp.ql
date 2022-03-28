import codeql.ruby.Regexp

query predicate groupName(RegExpGroup g, string name) { name = g.getName() }

query predicate groupNumber(RegExpGroup g, int number) { number = g.getNumber() }

query predicate term(RegExpTerm term, string c) { c = term.getPrimaryQlClasses() }

query predicate regExpNormalCharValue(RegExpNormalChar term, string value) {
  value = term.getValue()
}
