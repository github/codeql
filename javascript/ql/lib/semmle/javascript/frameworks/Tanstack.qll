private import javascript

class TanstackStep extends DataFlow::AdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::CallNode useQuery |
      useQuery = useQueryCall() and
      node1 =
        useQuery
            .getArgument(0)
            .getALocalSource()
            .getAPropertyWrite("queryFn")
            .getRhs()
            .getAFunctionValue()
            .getAReturn() and
      node2 = useQuery.getAPropertyRead("data")
    )
  }
}

DataFlow::CallNode useQueryCall() {
  result = DataFlow::moduleImport("@tanstack/react-query").getAPropertyRead("useQuery").getACall()
}
