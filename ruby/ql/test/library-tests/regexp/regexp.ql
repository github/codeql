import codeql.ruby.security.performance.RegExpTreeView

query predicate groupName(RegExpGroup g, string name) { name = g.getName() }

query predicate groupNumber(RegExpGroup g, int number) { number = g.getNumber() }

query predicate term(RegExpTerm term, string c) { c = term.getPrimaryQlClasses() }
