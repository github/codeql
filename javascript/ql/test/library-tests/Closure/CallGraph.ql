import javascript

from DataFlow::InvokeNode node, int imprecision
select node, node.getACallee(imprecision), imprecision
