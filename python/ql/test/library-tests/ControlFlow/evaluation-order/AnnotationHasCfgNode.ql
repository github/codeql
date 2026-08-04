/**
 * Checks that every timer annotation has a corresponding CFG node.
 */

import OldCfgImpl

private module Utils = EvalOrderCfgUtils<OldCfg>;

private import Utils::CfgTests

from TimerAnnotation ann
where annotationWithoutCfgNode(ann)
select ann, "Annotation in $@ has no CFG node", ann.getTestFunction(),
  ann.getTestFunction().getName()
