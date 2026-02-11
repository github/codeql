/**
 * @name Extraction metrics
 * @description Raw metrics relating to extraction.
 * @kind metric
 * @tags summary telemetry
 * @id cpp/telemetry/extraction-metrics
 */

import Metrics

from ExtractionMetric m
select m.toString(), m.getValue()
