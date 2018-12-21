import csharp

from CommentBlock c, CommentLine l
where l.getParent() = c
select c, c.getNumLines(), l, l.getText(), l.getRawText(), l.getAQlClass()
