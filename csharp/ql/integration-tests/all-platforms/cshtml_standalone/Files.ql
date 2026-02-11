import csharp

from File f
where f.fromSource() or f.getExtension() = "cshtml"
select f.getRelativePath()
