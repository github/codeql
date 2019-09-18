/**
 * @name Defect from SVN
 * @description A test case for creating a defect from SVN data.
 * @kind problem
 * @problem.severity warning
 * @tags external-data
 * @deprecated
 */

import cpp
import external.ExternalArtifact
import external.VCS

predicate numCommits(File f, int i) { i = count(Commit e | e.getAnAffectedFile() = f) }

predicate maxCommits(int i) { i = max(File f, int j | numCommits(f, j) | j) }

from File f, int i
where numCommits(f, i) and maxCommits(i)
select f, "This file has " + i + " commits."
