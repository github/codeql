import ruby

query predicate erbFiles(ErbFile f) { any() }

query predicate erbAstNodes(ErbAstNode n) { any() }

query predicate erbTemplates(ErbTemplate t) { any() }

query predicate erbDirectives(ErbDirective d) { any() }

query predicate erbCommentDirectives(ErbCommentDirective d) { any() }

query predicate erbGraphqlDirectives(ErbGraphqlDirective d) { any() }

query predicate erbOutputDirectives(ErbOutputDirective d) { any() }

query predicate erbExecutionDirectives(ErbExecutionDirective d) { any() }

query predicate childStmts(ErbDirective d, Stmt s) { s = d.getAChildStmt() }

query predicate terminalStatements(ErbDirective d, Stmt s) { s = d.getTerminalStmt() }

query predicate primaryQlClasses(ErbAstNode n, string cls) { cls = n.getAPrimaryQlClass() }

query predicate erbFileTemplates(ErbFile f, ErbTemplate t) { t = f.getTemplate() }
