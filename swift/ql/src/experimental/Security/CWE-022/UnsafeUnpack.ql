/**
 * @name Arbitrary file write during a zip extraction from a user controlled source
 * @description Unpacking user controlled zips without validating whether the
 *              destination file path is within the destination directory can cause files
 *              outside the destination directory to be overwritten.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/unsafe-unpacking
 * @tags security
 *       experimental
 *       external/cwe/cwe-022
 */

import swift
import codeql.swift.security.UnsafeUnpackQuery
import UnsafeUnpackFlow::PathGraph

from UnsafeUnpackFlow::PathNode sourceNode, UnsafeUnpackFlow::PathNode sinkNode
where UnsafeUnpackFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "Unsafe unpacking from a malicious zip retrieved from a remote location."
