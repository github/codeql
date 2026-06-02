/**
 * New-CFG version of AnnotationHasCfgNode.
 *
 * Checks that every timer annotation has a corresponding CFG node.
 */

import python
import TimerUtils
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils::CfgTests

from TimerAnnotation ann
where annotationWithoutCfgNode(ann)
select ann, "Annotation in $@ has no CFG node", ann.getTestFunction(),
  ann.getTestFunction().getName()
