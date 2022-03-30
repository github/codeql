/**
 * TaintedPathATMLite.ql
 *
 * Arbitrarily ranked version of the boosted path injection query with an output relation ready to
 * plug into the evaluation pipeline. This is useful (a) for evaluating the performance of endpoint
 * filters, and (b) as a baseline to compare the model against.
 */

import ATM::ResultsInfo
import EndToEndEvaluation as EndToEndEvaluation
import experimental.adaptivethreatmodeling.TaintedPathATM

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
  score = 0
select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
  sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink, score order by
    score desc, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
    startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink
