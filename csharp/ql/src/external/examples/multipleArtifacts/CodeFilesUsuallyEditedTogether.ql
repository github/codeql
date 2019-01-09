/**
 * @name Files edited in pairs
 * @description Files that are usually committed at the same time can be dangerous: it can indicate the files are too closely tied, and can create problems if someone forgets to edit the other file.
 * @kind problem
 * @problem.severity recommendation
 * @deprecated
 */

import csharp
import external.VCS

int numberOfCommitsWith(File a, File b) {
  result = count(Commit e | a = e.getAnAffectedFile() and b = e.getAnAffectedFile()) and
  a != b
}

int totalCommits(File a) { result = count(Commit e | a = e.getAnAffectedFile()) }

int percentagePairedCommits(File f, File with) {
  exists(int paired, int total |
    paired = numberOfCommitsWith(f, with) and
    total = totalCommits(f) and
    result = (100 * paired) / total and
    result > 0
  )
}

from File f, File other, int percent, int total
where
  percent = percentagePairedCommits(f, other) and
  total = totalCommits(f) and
  percent >= 70 and
  total >= 4
select f, "This file is usually edited together with " + other + " (" + percent + "% of commits)."
