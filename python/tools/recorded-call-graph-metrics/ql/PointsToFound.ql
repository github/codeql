import RecordedCalls

from PointsToBasedCallGraph::ResolvableRecordedCall rc
select rc.getCall(), "-->", rc.getCalleeValue()
