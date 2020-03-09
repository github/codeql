import semmle.go.dependencies.SemVer

from DependencySemShaVersion ver
select ver, ver.getSha()
