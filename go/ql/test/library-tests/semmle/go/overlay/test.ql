import go

query predicate expressions(Expr e) { any() }

query predicate statements(Stmt s) { any() }

query predicate functions(Function f) { exists(f.getLocation()) }

query predicate types(Type t) { exists(t.getLocation()) }

query predicate parameters(Parameter p) { any() }

query predicate fields(Field f) { exists(f.getLocation()) }

query predicate commentLines(Comment c) { any() }

query predicate commentBlocks(CommentGroup cg) { any() }

query predicate htmlElements(HTML::Element xl) { any() }
