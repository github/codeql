import javascript

from JQuery::MethodCall mc, DataFlow::Node node
where mc.interpretsArgumentAsHtml(node)
select mc, node
