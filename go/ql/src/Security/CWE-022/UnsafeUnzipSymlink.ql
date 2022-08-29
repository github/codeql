/**
 * @name Arbitrary file write extracting an archive containing symbolic links
 * @description Extracting files from a malicious zip archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten. Extracting symbolic links in particular
 *              requires resolving previously extracted links to ensure the destination directory
 *              is not escaped.
 * @kind path-problem
 * @id go/unsafe-unzip-symlink
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import go
import DataFlow::PathGraph
import semmle.go.security.UnsafeUnzipSymlink::UnsafeUnzipSymlink

from SymlinkConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Unresolved path from an archive header, which may point outside the archive root, is used in $@.",
  sink.getNode(), "symlink creation"
