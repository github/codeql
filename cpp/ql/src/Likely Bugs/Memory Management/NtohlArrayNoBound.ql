/**
 * @id cpp/network-to-host-function-as-array-bound
 * @name Untrusted network-to-host usage
 * @description Using the result of a network-to-host byte order function, such as ntohl, as an
 *              array bound or length value without checking it may result in buffer overflows or
 *              other vulnerabilities.
 * @kind problem
 * @problem.severity error
 */

import cpp
import NtohlArrayNoBound

from DataFlow::Node source, DataFlow::Node sink
where NetworkToBufferSizeFlow::flow(source, sink)
select sink, "Unchecked use of data from network function $@.", source, source.toString()
