/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @kind diagnostic
 * @id java/utils/modelgenerator/source-models
 * @tags modelgenerator
 */

import internal.CaptureModels

from DataFlowTargetApi api, string source
where source = captureSource(api)
select source order by source
