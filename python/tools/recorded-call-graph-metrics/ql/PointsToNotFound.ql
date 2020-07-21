import RecordedCalls

from IdentifiedRecordedCall rc
where not rc instanceof PointsToBasedCallGraph::ResolvableRecordedCall
select rc
