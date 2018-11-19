import python

from Name n
where n.getId() = "count"
select n.getLocation().getStartLine(), count(n.getAFlowNode())
