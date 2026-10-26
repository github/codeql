/**
 * @name Receiver variable
 * @description Finds receiver variables of pointer type.
 * @id go/examples/pointerreceiver
 * @tags receiver variable
 */

import go

from ReceiverVariable recv
where recv.getType() instanceof PointerType
select recv
