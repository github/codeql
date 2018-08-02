import javascript

from DataFlow::SourceNode src, string prop, DataFlow::Node rhs
where src.hasPropertyWrite(prop, rhs)
select src, prop, rhs
