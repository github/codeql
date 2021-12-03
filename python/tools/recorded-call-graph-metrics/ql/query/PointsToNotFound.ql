import lib.RecordedCalls

from IdentifiedRecordedCall rc
where not rc instanceof PointsToBasedCallGraph::ResolvableRecordedCall
select rc, rc.getACall()
