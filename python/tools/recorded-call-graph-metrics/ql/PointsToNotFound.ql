import RecordedCalls

from ValidRecordedCall rc
where not rc instanceof PointsToBasedCallGraph::ResolvableRecordedCall
select rc
