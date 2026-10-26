import go

from ControlFlow::Node nd
where
  // exclude code with build constraints to ensure platform-independent results
  not nd.getFile().hasBuildConstraints()
select nd, nd.getASuccessor()
