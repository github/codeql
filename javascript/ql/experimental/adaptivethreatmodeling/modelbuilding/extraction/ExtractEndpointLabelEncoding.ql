/**
 * @name Endpoint types
 * @description Maps endpoint type encodings to human-readable descriptions.
 * @kind table
 */

import experimental.adaptivethreatmodeling.EndpointTypes

from EndpointType type
select type.getEncoding() as encoding, type.getDescription() as description order by encoding
