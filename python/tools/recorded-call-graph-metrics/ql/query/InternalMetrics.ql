/**
 * Metrics for evaluating how good we are at interpreting results from the cg_trace program.
 * See Metrics.ql for call-graph quality metrics.
 */

import lib.RecordedCalls

from string text, float number, float ratio
where
  exists(int all_rcs | all_rcs = count(XmlRecordedCall rc) and ratio = number / all_rcs |
    text = "XMLRecordedCall" and number = all_rcs
    or
    text = "IdentifiedRecordedCall" and number = count(IdentifiedRecordedCall rc)
    or
    text = "UnidentifiedRecordedCall" and number = count(UnidentifiedRecordedCall rc)
  )
select text, number, ratio * 100 + "%" as percent
