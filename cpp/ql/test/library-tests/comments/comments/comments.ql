import cpp

from Comment c, Element e
where e = c.getCommentedElement()
select c, strictcount(c.getCommentedElement()), e
