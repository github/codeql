import csharp

from Assembly a
where exists(a.getFile().getAbsolutePath().indexOf("microsoft.windowsdesktop.app.ref"))
select a
