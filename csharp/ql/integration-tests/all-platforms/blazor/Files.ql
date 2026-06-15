import csharp

from File f
where f.fromSource() or f.getExtension() = "razor"
select f
