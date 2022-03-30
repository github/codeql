import cpp

from StaticAssert sa
select sa, sa.getCondition(), count(Comment c | c.getCommentedElement() = sa)
