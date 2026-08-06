/**
 * @name Debug static name-binding graph
 * @description Renders the graph used to perform static name lookups
 * @kind graph
 * @id unified/debug-static-name-binding-graph
 */

private import unified
private import codeql.unified.internal.StaticNameBinding

/**
 * Holds if graphs related to `file` should be shown in the graph.
 */
predicate relevantFile(File file) { file.getBaseName() = "test.swift" }

import DebugGraph<relevantFile/1>
