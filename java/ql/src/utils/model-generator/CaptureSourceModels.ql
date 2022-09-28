/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @kind diagnostic
 * @id java/utils/model-generator/source-models
 * @tags model-generator
 */

import internal.CaptureModels

from DataFlowTargetApi api, string source
where source = captureSource(api)
select source order by source
