import csharp

query predicate expressions(Expr e) { e.fromSource() }

query predicate statements(Stmt s) { s.fromSource() }

query predicate methods(Method m) { m.fromSource() }

query predicate types(Type t) { t.fromSource() }

query predicate parameters(Parameter p) { p.fromSource() }

query predicate operators(Operator o) { o.fromSource() }

query predicate constructors(Constructor c) { c.fromSource() }

query predicate destructors(Destructor d) { d.fromSource() }

query predicate fields(Field f) { f.fromSource() }

query predicate properties(Property p) { p.fromSource() }

query predicate indexers(Indexer i) { i.fromSource() }

query predicate accessors(Accessor a) { a.fromSource() }

query predicate attributes(Attribute a) { a.fromSource() }

query predicate events(Event ev) { ev.fromSource() }

query predicate eventAccessors(EventAccessor ea) { ea.fromSource() }

query predicate usingDirectives(UsingDirective ud) { ud.fromSource() }

query predicate commentLines(CommentLine cl) { any() }

query predicate commentBlocks(CommentBlock cb) { any() }

query predicate typeMentions(TypeMention tm) { any() }

query predicate xmlLocatables(XmlLocatable xl) { any() }
