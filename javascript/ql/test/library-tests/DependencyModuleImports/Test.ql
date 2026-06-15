import javascript
import semmle.javascript.dependencies.SemVer

class SampleVersionSink extends DataFlow::Node {
  SampleVersionSink() {
    exists(
      string dependencyName, Dependency dep, DependencySemVer vDep, string vFrom, string vTo,
      string functionName, int argNumber
    |
      dependencyName = "a" and
      vFrom = "0.1.0" and
      vTo = "1.1.0" and
      functionName = "m1" and
      argNumber = 0
      or
      dependencyName = "b" and
      vFrom = "1.1.0" and
      vTo = "2.1.0" and
      functionName = "m1" and
      argNumber = 0
      or
      dependencyName = "c" and
      vFrom = "0.1.0" and
      vTo = "1.1.0" and
      functionName = "m1" and
      argNumber = 1
      or
      dependencyName = "d" and
      vFrom = "0.1.0" and
      vTo = "1.0.0" and
      functionName = "m1" and
      argNumber = 0
    |
      this =
        DataFlow::dependencyModuleImport(dep).getAMemberCall(functionName).getArgument(argNumber) and
      dep.info(dependencyName, vDep) and
      vDep.maybeBetween(vFrom, vTo)
    )
  }
}

select any(SampleVersionSink s)
