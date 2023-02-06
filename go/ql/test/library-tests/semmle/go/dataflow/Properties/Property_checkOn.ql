import go

from DataFlow::Property prop, DataFlow::Node test, boolean outcome, DataFlow::Node nd
where prop.checkOn(test, outcome, nd)
select prop, test, outcome, nd
