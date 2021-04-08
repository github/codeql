import csharp

from Indexer i, Accessor a, string s
where
  i.getDeclaringType().hasQualifiedName("System", s) and
  s.regexpMatch("Tuple<,*>") and
  a = i.getAnAccessor()
select i.toStringWithTypes(), a.toStringWithTypes()
