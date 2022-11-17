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

import swift
import codeql.swift.dataflow.FlowSources

string sourceClass(FlowSource s) {
  s instanceof LocalFlowSource and result = "LocalFlowSource"
  or
  s instanceof RemoteFlowSource and result = "RemoteFlowSource"
}

from FlowSource s
select s, sourceClass(s) + ": " + s.getSourceType()
