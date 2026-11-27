import go

from DataFlow::PostUpdateNode pun
where pun.getFile().getBaseName() = "test.go"
select pun.getPreUpdateNode(), pun
