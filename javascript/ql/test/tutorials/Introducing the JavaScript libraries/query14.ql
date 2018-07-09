import javascript

from DataFlow::InvokeNode cs
where not cs.isIncomplete() and
      not exists(cs.getACallee())
select cs, "Unable to find a callee for this call site."
