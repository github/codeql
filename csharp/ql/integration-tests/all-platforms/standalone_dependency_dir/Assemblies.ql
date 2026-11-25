import csharp

from Assembly a
where
  not a.getCompilation().getOutputAssembly() = a and
  a.getName().contains("Newtonsoft")
select a
