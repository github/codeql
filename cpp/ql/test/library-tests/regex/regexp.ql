import cpp
import semmle.code.cpp.regex.RegexTreeView

query predicate groupName(RegExpGroup g, string name) { name = g.getName() }

query predicate groupNumber(RegExpGroup g, int number) { number = g.getNumber() }

query predicate term(RegExpTerm t, string c) { c = t.getPrimaryQlClasses() }

query predicate regExpNormalCharValue(RegExpNormalChar n, string value) { value = n.getValue() }
