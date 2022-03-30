import csharp

from CommentBlock comment, Attribute attribute
where comment.getElement() = attribute
select attribute, comment
