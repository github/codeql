import lib.RecordedCalls

from PointsToBasedCallGraph::ResolvableRecordedCall rc
select rc.getACall(), "-->", rc.getCalleeValue()
