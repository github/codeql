import csharp

from TrivialProperty prop, string qualifier, string name
where
  exists(string dqualifier, string dname |
    prop.getDeclaringType().hasQualifiedName(dqualifier, dname) and
    (
      dqualifier = "System.Reflection" and dname = "AssemblyName"
      or
      dqualifier = "System.Collections" and dname = "DictionaryEntry"
      or
      dqualifier = "Dataflow" and dname = "Properties"
    )
  ) and
  prop.hasQualifiedName(qualifier, name)
select printQualifiedName(qualifier, name)
