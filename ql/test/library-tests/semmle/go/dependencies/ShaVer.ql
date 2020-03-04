import semmle.go.dependencies.SemVer

from DependencySemShaVer ver
select ver, ver.getSha()
