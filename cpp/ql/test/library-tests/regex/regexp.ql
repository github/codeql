import cpp
import semmle.code.cpp.regex.RegexTreeView as RE

query predicate groupName(RE::RegExpGroup g, string name) { name = g.getName() }

query predicate groupNumber(RE::RegExpGroup g, int number) { number = g.getNumber() }

query predicate term(RE::RegExpTerm term, string c) { c = term.getPrimaryQlClasses() }

query predicate regExpNormalCharValue(RE::RegExpNormalChar term, string value) {
  value = term.getValue()
}
