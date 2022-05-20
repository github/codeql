import go

from Method m
where m.getPackage().getName() = "main"
select m, m.getQualifiedName(), m.getReceiver(), m.getReceiverType().pp()
