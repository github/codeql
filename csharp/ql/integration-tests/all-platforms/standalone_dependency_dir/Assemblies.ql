import csharp

from Assembly a
where
  not a.getCompilation().getOutputAssembly() = a and
  a.getName().matches("%Newtonsoft%")
select a
