import semmle.code.cpp.regex.internal.ParseRegExp
import semmle.code.cpp.regex.RegexTreeView

// Stop gap for missing flow configs
class RegExpTest extends RegExp {
  RegExpTest() { any() }
}

query predicate groupName(RegExpGroup g, string name) { name = g.getName() }

query predicate groupNumber(RegExpGroup g, int number) { number = g.getNumber() }

query predicate term(RegExpTerm term, string c) { c = term.getPrimaryQlClasses() }

query predicate regExpNormalCharValue(RegExpNormalChar term, string value) {
  value = term.getValue()
}
