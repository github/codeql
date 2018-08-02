import csharp

from DelegateCall dc, Callable c, CallContext::CallContext cc
where c = dc.getARuntimeTarget(cc)
select dc, c, cc
