/**
 * @name Arbitrary file access during archive extraction ("Zip Slip")
 * @description Accessing filesystem paths built from the name of an archive entry without
 *              validating that the destination file path is within the destination directory
 *              can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @id cs/zipslip
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import csharp
import semmle.code.csharp.security.dataflow.ZipSlipQuery
import ZipSlip::PathGraph

from ZipSlip::PathNode source, ZipSlip::PathNode sink
where ZipSlip::flowPath(source, sink)
select source.getNode(), source, sink,
  "Unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
