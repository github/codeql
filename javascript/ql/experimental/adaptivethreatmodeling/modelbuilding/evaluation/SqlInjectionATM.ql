/**
 * SqlInjectionATM.ql
 *
 * Version of the boosted SQL injection query with an output relation ready to plug into the
 * evaluation pipeline.
 */

import ATM::ResultsInfo
import EndToEndEvaluation as EndToEndEvaluation
import experimental.adaptivethreatmodeling.SqlInjectionATM

from
  DataFlow::Configuration cfg, DataFlow::Node source, DataFlow::Node sink, string filePathSink,
  int startLineSink, int endLineSink, int startColumnSink, int endColumnSink, string filePathSource,
  int startLineSource, int endLineSource, int startColumnSource, int endColumnSource, float score
where
  cfg.hasFlow(source, sink) and
  not EndToEndEvaluation::isFlowExcluded(source, sink) and
  not isFlowLikelyInBaseQuery(source, sink) and
  sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
  source
      .hasLocationInfo(filePathSource, startLineSource, startColumnSource, endLineSource,
        endColumnSource) and
  getScoreForFlow(source, sink) = score
select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
  sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink, score order by
    score desc, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
    startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink
