import go

// This test should not have any results
from DataFlow::Node nd, int n
where n = count(globalValueNumber(nd)) and n != 1
select nd, n
