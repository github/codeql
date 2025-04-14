import csharp

from Assembly a
where exists(a.getFile().getAbsolutePath().indexOf("/legacypackages/"))
select a
