import csharp
import semmle.code.csharp.commons.QualifiedName

from TrivialProperty prop, string namespace, string type, string name
where
  prop.getDeclaringType().hasQualifiedName(namespace, type) and
  (
    namespace = "System.Reflection" and type = "AssemblyName"
    or
    namespace = "System.Collections" and type = "DictionaryEntry"
    or
    namespace = "Dataflow" and type = "Properties"
  ) and
  prop.hasQualifiedName(namespace, type, name)
select getQualifiedName(namespace, type, name)
