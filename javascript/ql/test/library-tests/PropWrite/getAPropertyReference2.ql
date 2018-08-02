import javascript

from DataFlow::SourceNode nd, string prop
select nd, prop, nd.getAPropertyReference(prop)
