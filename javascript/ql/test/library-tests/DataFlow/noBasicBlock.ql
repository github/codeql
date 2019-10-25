import javascript

from DataFlow::Node node
where not exists(node.getBasicBlock())
select node
