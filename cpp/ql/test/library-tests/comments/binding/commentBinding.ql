import cpp

from Comment c, string s
where
  if exists(c.getCommentedElement()) then s = c.getCommentedElement().toString() else s = "<none>"
select c, s
