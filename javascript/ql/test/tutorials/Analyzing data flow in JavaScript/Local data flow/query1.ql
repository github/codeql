import javascript

from DataFlow::MethodCallNode readFile, DataFlow::Node source
where
  readFile.getMethodName() = "readFile" and
  source.getASuccessor*() = readFile.getArgument(0)
select source
