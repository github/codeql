import go

from File f, CommentGroup cg, int idx
where cg = f.getCommentGroup(idx)
select f, idx, cg
