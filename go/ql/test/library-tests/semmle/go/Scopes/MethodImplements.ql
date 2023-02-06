import go

from Method m, Method im
where m.implements(im) and m.getPackage().getName() = "main"
select m.getReceiverType().pp(), m.getName(), im.getReceiverType().pp(), im.getName()
