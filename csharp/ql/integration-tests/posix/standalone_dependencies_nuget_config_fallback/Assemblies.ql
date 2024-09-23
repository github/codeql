import csharp

from Assembly a
where exists(a.getFile().getAbsolutePath().indexOf("newtonsoft.json"))
select a
