import csharp

from CommentBlock b
where b.getLocation().getFile().fromSource()
select b, b.getElement(), b.getChild(0).getText()
