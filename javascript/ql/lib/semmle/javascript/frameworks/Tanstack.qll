/**
 * Provides classes and predicates modeling the Tanstack/react-query library.
 */

private import javascript

/**
 * An additional flow step that propagates data from the return value of the query function,
 * defined in a useQuery call from the '@tanstack/react-query' module, to the 'data' property.
 */
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

/**
 * Retrieves a call node representing a useQuery invocation from the '@tanstack/react-query' module.
 */
DataFlow::CallNode useQueryCall() {
  result = DataFlow::moduleImport("@tanstack/react-query").getAPropertyRead("useQuery").getACall()
}
