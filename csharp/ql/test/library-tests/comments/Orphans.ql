import csharp

from CommentBlock b
where b.isOrphan() and b.getLocation().getFile().fromSource()
select b
