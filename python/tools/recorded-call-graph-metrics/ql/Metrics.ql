import RecordedCalls


from string text, float number, float ratio, int i
where
  exists(int all_rcs | all_rcs = count(XMLRecordedCall rc) and ratio = number / all_rcs |
    text = "XMLRecordedCall" and number = all_rcs and i = 0
    or
    text = "IgnoredRecordedCall" and number = count(IgnoredRecordedCall rc) and i = 1
  )
  or
  text = "----------" and
  number = 0 and
  ratio = 0 and
  i = 2
  or
  exists(int all_not_ignored_rcs |
    all_not_ignored_rcs = count(XMLRecordedCall rc | not rc instanceof IgnoredRecordedCall) and
    ratio = number / all_not_ignored_rcs
  |
    text = "IdentifiedRecordedCall" and
    number = count(IdentifiedRecordedCall rc | not rc instanceof IgnoredRecordedCall) and
    i = 3
    or
    text = "UnidentifiedRecordedCall" and
    number = count(UnidentifiedRecordedCall rc | not rc instanceof IgnoredRecordedCall) and
    i = 4
  )
  or
  text = "----------" and
  number = 0 and
  ratio = 0 and
  i = 5
  or
  exists(int all_identified_rcs |
    all_identified_rcs = count(IdentifiedRecordedCall rc | not rc instanceof IgnoredRecordedCall) and
    ratio = number / all_identified_rcs
  |
    text = "points-to ResolvableRecordedCall" and
    number =
      count(PointsToBasedCallGraph::ResolvableRecordedCall rc |
        not rc instanceof IgnoredRecordedCall
      ) and
    i = 6
    or
    text = "points-to not ResolvableRecordedCall" and
    number =
      all_identified_rcs -
        count(PointsToBasedCallGraph::ResolvableRecordedCall rc |
          not rc instanceof IgnoredRecordedCall
        ) and
    i = 7
  )
select i, text, number, ratio * 100 + "%" as percent order by i
