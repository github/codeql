import go

from Method m, string pkg, string tp, string name
where
  m.implements(pkg, tp, name) and
  m.hasQualifiedName("github.com/Semmle/go/ql/test/library-tests/semmle/go/Scopes", _, _)
select m.getReceiverType(), m.getName(), pkg, tp, name
