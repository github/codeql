/**
 * @name Remote data to unsafe deserializer
 * @description Calling an unsafe deserializer can lead to denial of service and other
 *              security problems. This version checks the source of the stream for untrusted input.
 * @kind problem
 * @id cs/unsafe-deserialization-untrusted-input
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.serialization.UnsafeDeserialization::UnsafeDeserializersDataFlow

from UnsafeDeserializationTrackingConfig config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "$@ flows to  unsafe deserializer.", source, "User-provided data"
