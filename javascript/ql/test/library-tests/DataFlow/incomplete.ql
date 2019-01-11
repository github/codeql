import javascript

from DataFlow::Node dfn, DataFlow::Incompleteness cause
where dfn.isIncomplete(cause)
select dfn, cause
