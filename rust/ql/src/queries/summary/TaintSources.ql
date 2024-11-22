/**
 * @name Taint Sources
 * @description List all sources of untrusted input that have been idenfitied
 *              in the database.
 * @kind problem
 * @problem.severity info
 * @id rust/summary/taint-sources
 * @tags summary
 */

import rust
import codeql.rust.Concepts

from ThreatModelSource s, string defaultString
where
  if s instanceof ActiveThreatModelSource then defaultString = " (DEFAULT)" else defaultString = ""
select s,
  "Flow source '" + s.getSourceType() + "' of type " + s.getThreatModel() + defaultString + "."
