/**
 * @name Flow Sources
 * @description List all flow sources found in the database. Flow sources
 *              indicate data that originates from an untrusted source, such
 *              as as untrusted remote data.
 * @kind problem
 * @problem.severity info
 * @id swift/summary/flow-sources
 * @tags summary
 */

/*
 * Most queries compute data flow from one of the following sources:
 *  - flow sources (listed by this query, `swift/summary/flow-sources`).
 *  - sensitive expressions (see `swift/summary/sensitive-expressions`).
 *  - constant values.
 *  - custom per-query sources.
 */

import swift
import codeql.swift.dataflow.FlowSources

string sourceClass(FlowSource s) {
  s instanceof LocalFlowSource and result = "Local flow source"
  or
  s instanceof RemoteFlowSource and result = "Remote flow source"
}

from FlowSource s
select s, sourceClass(s) + ": " + s.getSourceType()
