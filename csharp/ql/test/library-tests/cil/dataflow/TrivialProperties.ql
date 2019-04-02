import csharp

from TrivialProperty prop
where
  prop.getDeclaringType().hasQualifiedName("System.Reflection.AssemblyName")
  or
  prop.getDeclaringType().hasQualifiedName("System.Collections.DictionaryEntry")
  or
  prop.getDeclaringType().hasQualifiedName("Dataflow.Properties")
select prop.getQualifiedName()
