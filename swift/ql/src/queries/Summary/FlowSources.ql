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

from RemoteFlowSource s
select s, "Flow source: " + s.getSourceType()
