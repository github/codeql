/**
 * @name Flow Sources
 * @description List all flow sources found in the database. Flow sources
 *              indicate data that originates from an untrusted source, such
 *              as as untrusted remote data.
 * @kind table
 * @id swift/summary/flow-sources
 */

import swift
import codeql.swift.dataflow.FlowSources

from RemoteFlowSource s
select s, "Flow source: " + s.getSourceType()
