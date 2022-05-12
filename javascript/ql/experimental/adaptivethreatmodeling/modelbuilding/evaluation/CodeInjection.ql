/**
 * CodeInjection.ql
 *
 * Version of the standard Code Injection query with an output relation ready to plug into the evaluation
 * pipeline.
 *
 * Standard query: javascript/ql/src/Security/CWE-094/CodeInjection.ql
 */

import semmle.javascript.security.dataflow.CodeInjectionQuery
import EndToEndEvaluation as EndToEndEvaluation

from
  DataFlow::Configuration cfg, DataFlow::Node source, DataFlow::Node sink, string filePathSink,
  int startLineSink, int endLineSink, int startColumnSink, int endColumnSink, string filePathSource,
  int startLineSource, int endLineSource, int startColumnSource, int endColumnSource
where
  cfg instanceof Configuration and
  cfg.hasFlow(source, sink) and
  not EndToEndEvaluation::isFlowExcluded(source, sink) and
  sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
  source
      .hasLocationInfo(filePathSource, startLineSource, startColumnSource, endLineSource,
        endColumnSource)
select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
  sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink
