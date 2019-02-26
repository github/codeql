import csharp

from TrivialProperty prop
where
  prop.getDeclaringType().hasQualifiedName("System.Reflection.AssemblyName")
  or
  prop.getDeclaringType().hasQualifiedName("System.Collections.DictionaryEntry")
select prop.getQualifiedName()
