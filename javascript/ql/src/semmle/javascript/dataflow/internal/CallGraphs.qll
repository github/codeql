/**
 * Internal predicates for computing the call graph.
 */
private import javascript

cached
module CallGraph {
  /** Gets the function referenced by `node`, as determined by the type inference. */
  cached
  Function getAFunctionValue(AnalyzedNode node) {
    result = node.getAValue().(AbstractCallable).getFunction()
  }

  /** Holds if the type inferred for `node` is indefinite due to global flow. */
  cached
  predicate isIndefiniteGlobal(AnalyzedNode node) {
    node.analyze().getAValue().isIndefinite("global")
  }

  /**
   * Gets a data flow node that refers to the given function.
   */
  pragma[nomagic]
  private
  DataFlow::SourceNode getAFunctionReference(DataFlow::FunctionNode function, int imprecision, DataFlow::TypeTracker t) {
    t.start() and
    exists(Function fun |
      fun = function.getFunction() and
      fun = getAFunctionValue(result)
    |
      if isIndefiniteGlobal(result) then
        fun.getFile() = result.getFile() and imprecision = 0
        or
        fun.inExternsFile() and imprecision = 1
        or
        imprecision = 2
      else
        imprecision = 0
    )
    or
    imprecision = 0 and
    t.start() and
    exists(string name |
      GlobalAccessPath::isAssignedInUniqueFile(name) and
      GlobalAccessPath::fromRhs(function) = name and
      GlobalAccessPath::fromReference(result) = name
    )
    or
    imprecision = 0 and
    exists(DataFlow::ClassNode cls |
      exists(string name |
        function = cls.getInstanceMethod(name) and
        getAnInstanceMemberAccess(cls, name, t.continue()).flowsTo(result)
        or
        function = cls.getStaticMethod(name) and
        cls.getAClassReference(t.continue()).getAPropertyRead(name).flowsTo(result)
      )
      or
      function = cls.getConstructor() and
      cls.getAClassReference(t.continue()).flowsTo(result)
    )
  }

  /**
   * Gets a data flow node that refers to the given function.
   */
  cached
  DataFlow::SourceNode getAFunctionReference(DataFlow::FunctionNode function, int imprecision) {
    result = getAFunctionReference(function, imprecision, DataFlow::TypeTracker::end())
  }

  /**
   * Gets a data flow node that refers to the result of the given partial function invocation,
   * with `function` as the underlying function.
   */
  pragma[nomagic]
  private
  DataFlow::SourceNode getABoundFunctionReference(DataFlow::FunctionNode function, int boundArgs, DataFlow::TypeTracker t) {
    exists(DataFlow::PartialInvokeNode partial, DataFlow::Node callback |
      result = partial.getBoundFunction(callback, boundArgs) and
      getAFunctionReference(function, 0, t.continue()).flowsTo(callback)
    )
    or
    result = getABoundFunctionReferenceAux(function, boundArgs, t)
  }

  pragma[noopt]
  private
  DataFlow::SourceNode getABoundFunctionReferenceAux(DataFlow::FunctionNode function, int boundArgs, DataFlow::TypeTracker t) {
    exists(DataFlow::TypeTracker t2, DataFlow::SourceNode prev |
      prev = getABoundFunctionReference(function, boundArgs, t2) and
      exists(DataFlow::StepSummary summary |
        DataFlow::StepSummary::step(prev, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  /**
   * Gets a data flow node that refers to the result of the given partial function invocation,
   * with `function` as the underlying function.
   */
  cached
  DataFlow::SourceNode getABoundFunctionReference(DataFlow::FunctionNode function, int boundArgs) {
    result = getABoundFunctionReference(function, boundArgs, DataFlow::TypeTracker::end())
  }

  /**
   * Gets a property read that accesses the property `name` on an instance of this class.
   *
   * Concretely, this holds when the base is an instance of this class or a subclass thereof.
   *
   * This predicate may be overridden to customize the class hierarchy analysis.
   */
  pragma[nomagic]
  private
  DataFlow::PropRead getAnInstanceMemberAccess(DataFlow::ClassNode cls, string name, DataFlow::TypeTracker t) {
    result = cls.getAnInstanceReference(t.continue()).getAPropertyRead(name)
    or
    exists(DataFlow::ClassNode subclass |
      result = getAnInstanceMemberAccess(subclass, name, t) and
      not exists(subclass.getAnInstanceMember(name)) and
      cls = subclass.getADirectSuperClass()
    )
  }
}
