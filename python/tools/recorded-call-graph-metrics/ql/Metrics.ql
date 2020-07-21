import RecordedCalls

from string text, float number, float ratio
where
  exists(int all_rcs | all_rcs = count(XMLRecordedCall rc) and ratio = number / all_rcs |
    text = "Number of XMLRecordedCall" and number = all_rcs
    or
    text = "Number of IdentifiedRecordedCall" and number = count(IdentifiedRecordedCall rc)
    or
    text = "Number of UnidentifiedRecordedCall" and number = count(UnidentifiedRecordedCall rc)
  )
  or
  exists(int all_identified_rcs |
    all_identified_rcs = count(IdentifiedRecordedCall rc) and ratio = number / all_identified_rcs
  |
    text = "Number of points-to ResolvableRecordedCall" and
    number = count(PointsToBasedCallGraph::ResolvableRecordedCall rc)
    or
    text = "Number of points-to NOT ResolvableRecordedCall" and
    number = all_identified_rcs - count(PointsToBasedCallGraph::ResolvableRecordedCall rc)
  )
select text, number, ratio * 100 + "%" as percent
