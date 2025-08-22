import csharp

from Assembly a
where not a.getCompilation().getOutputAssembly() = a
select a
