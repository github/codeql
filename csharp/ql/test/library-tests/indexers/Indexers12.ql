import csharp

from Indexer i, Accessor a, string s
where
  i.getDeclaringType().hasFullyQualifiedName("System", s) and
  s.regexpMatch("Tuple`[0-9]+") and
  a = i.getAnAccessor()
select i.toStringWithTypes(), a.toStringWithTypes()
