/**
 * @name Insecure loading of an Android Dex File
 * @description Loading a DEX library located in a world-writable location such as
 * an SD card can lead to arbitrary code execution vulnerabilities.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/android-insecure-dex-loading
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import InsecureDexLoading
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, InsecureDexConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential arbitrary code execution due to $@.",
  source.getNode(), "a value loaded from a world-writable source."
