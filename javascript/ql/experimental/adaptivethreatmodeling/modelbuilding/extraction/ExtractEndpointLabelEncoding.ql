/**
 * @name Endpoint types
 * @description Maps endpoint type encodings to human-readable descriptions.
 * @kind table
 * @id js/ml-powered/model-building/endpoint-type-encodings
 */

import experimental.adaptivethreatmodeling.EndpointTypes

from EndpointType type
select type.getEncoding() as encoding, type.getDescription() as description order by encoding
