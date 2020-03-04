import semmle.go.dependencies.SemVer

from DependencySemVer ver, string normVer
where
  exists(int major, int minor, int patch |
    major = [0 .. 20] and minor = [0 .. 20] and patch = [0 .. 20]
  |
    normVer = major + "." + minor + "." + patch
  ) and
  ver.is(normVer)
select ver, normVer
