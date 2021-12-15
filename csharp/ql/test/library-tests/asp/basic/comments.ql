import semmle.code.asp.AspNet

from AspComment comment, string kind
where if comment instanceof AspServerComment then kind = "server" else kind = "client"
select comment, comment.getBody(), kind
