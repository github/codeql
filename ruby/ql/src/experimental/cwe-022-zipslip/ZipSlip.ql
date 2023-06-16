/**
 * @name Arbitrary file access during archive extraction ("Zip Slip")
 * @description Accessing filesystem paths built from the name of an archive entry without
 *              validating that the destination file path is within the destination directory
 *              can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @id rb/zip-slip
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-022
 */

import ruby
import codeql.ruby.experimental.ZipSlipQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
