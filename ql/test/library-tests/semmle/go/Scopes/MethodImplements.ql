import go

from Method m, Method im
where m.implements(im) and m.getPackage().getName() = "main"
select m.getReceiverType(), m.getName(), im.getReceiverType(), im.getName()
