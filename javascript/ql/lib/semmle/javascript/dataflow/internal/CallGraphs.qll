/**
 * Internal predicates for computing the call graph.
 */

private import javascript
private import semmle.javascript.dataflow.internal.StepSummary
private import semmle.javascript.dataflow.internal.PreCallGraphStep

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
   *
   * Note that functions are not currently type-tracked, but this exposes the type-tracker `t`
   * from underlying class tracking if the function came from a class or instance.
   */
  pragma[nomagic]
  private DataFlow::SourceNode getAFunctionReference(
    DataFlow::FunctionNode function, int imprecision, DataFlow::TypeTracker t
  ) {
    t.start() and
    exists(Function fun |
      fun = function.getFunction() and
      fun = getAFunctionValue(result)
    |
      if isIndefiniteGlobal(result)
      then
        fun.getFile() = result.getFile() and imprecision = 0
        or
        fun.inExternsFile() and imprecision = 1
        or
        imprecision = 2
      else imprecision = 0
    )
    or
    imprecision = 0 and
    t.start() and
    AccessPath::step(function, result)
    or
    t.start() and
    imprecision = 0 and
    PreCallGraphStep::step(any(DataFlow::Node n | function.flowsTo(n)), result)
    or
    imprecision = 0 and
    result = callgraphStep(function, t)
  }

  /**
   * Gets a reference to `function` type-tracked by `t`.
   *
   * This only includes steps that aren't included in ordinary type-tracking.
   * For example, this steps from a method definition to an access on an instance, but
   * does not step through access paths, as those are included in type-tracking already.
   */
  cached
  DataFlow::SourceNode callgraphStep(DataFlow::FunctionNode function, DataFlow::TypeTracker t) {
    exists(DataFlow::ClassNode cls |
      exists(string name |
        function = cls.getInstanceMethod(name) and
        cls.getAnInstanceMemberAccess(name, t.continue()) = result
        or
        function = cls.getStaticMethod(name) and
        cls.getAClassReference(t.continue()).getAPropertyRead(name) = result
      )
      or
      function = cls.getConstructor() and
      cls.getAClassReference(t.continue()) = result
    )
    or
    exists(DataFlow::SourceNode object, string prop |
      function = object.getAPropertySource(prop) and
      result = getAnAllocationSiteRef(object).getAPropertyRead(prop) and
      t.start()
    )
    or
    exists(DataFlow::FunctionNode outer |
      result = getAFunctionReference(outer, 0, t.continue()).getAnInvocation() and
      locallyReturnedFunction(outer, function)
    )
    or
    // dynamic dispatch to unknown property of an object
    exists(DataFlow::ObjectLiteralNode obj, DataFlow::PropRead read |
      getAFunctionReference(function, 0, t.continue()) = obj.getAPropertySource() and
      obj.getAPropertyRead() = read and
      not exists(read.getPropertyName()) and
      result = read and
      // there exists only local reads of the object, nothing else.
      forex(DataFlow::Node ref | ref = obj.getALocalUse() and exists(ref.asExpr()) |
        ref = [obj, any(DataFlow::PropRead r).getBase()]
      )
    )
  }

  private predicate locallyReturnedFunction(
    DataFlow::FunctionNode outer, DataFlow::FunctionNode inner
  ) {
    inner.flowsTo(outer.getAReturn())
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
  private DataFlow::SourceNode getABoundFunctionReferenceAux(
    DataFlow::FunctionNode function, int boundArgs, DataFlow::TypeTracker t
  ) {
    exists(DataFlow::PartialInvokeNode partial, DataFlow::Node callback |
      result = partial.getBoundFunction(callback, boundArgs) and
      getAFunctionReference(function, 0, t.continue()).flowsTo(callback)
    )
    or
    exists(StepSummary summary, DataFlow::TypeTracker t2 |
      result = getABoundFunctionReferenceAux(function, boundArgs, t2, summary) and
      t = t2.append(summary)
    )
  }

  pragma[noinline]
  private DataFlow::SourceNode getABoundFunctionReferenceAux(
    DataFlow::FunctionNode function, int boundArgs, DataFlow::TypeTracker t, StepSummary summary
  ) {
    exists(DataFlow::SourceNode prev |
      prev = getABoundFunctionReferenceAux(function, boundArgs, t) and
      StepSummary::step(prev, result, summary)
    )
  }

  /**
   * Gets a data flow node that refers to the result of the given partial function invocation,
   * with `function` as the underlying function.
   */
  cached
  DataFlow::SourceNode getABoundFunctionReference(
    DataFlow::FunctionNode function, int boundArgs, boolean contextDependent
  ) {
    exists(DataFlow::TypeTracker t |
      result = getABoundFunctionReferenceAux(function, boundArgs, t) and
      t.end() and
      contextDependent = t.hasCall()
    )
  }

  /**
   * Gets a possible callee of `node` with the given `imprecision`.
   *
   * Does not include custom call edges.
   */
  cached
  DataFlow::FunctionNode getACallee(DataFlow::InvokeNode node, int imprecision) {
    getAFunctionReference(result, imprecision).flowsTo(node.getCalleeNode())
    or
    imprecision = 0 and
    exists(InvokeExpr expr | expr = node.(DataFlow::Impl::ExplicitInvokeNode).asExpr() |
      result.getFunction() = expr.getResolvedCallee()
      or
      exists(DataFlow::ClassNode cls |
        expr.(SuperCall).getBinder() = cls.getConstructor().getFunction() and
        result = cls.getADirectSuperClass().getConstructor()
      )
    )
  }

  /** Holds if a property setter named `name` exists in a class. */
  private predicate isSetterName(string name) {
    exists(any(DataFlow::ClassNode cls).getInstanceMember(name, DataFlow::MemberKind::setter()))
  }

  /**
   * Gets a property write that assigns to the property `name` on an instance of this class,
   * and `name` is the name of a property setter.
   */
  private DataFlow::PropWrite getAnInstanceMemberAssignment(DataFlow::ClassNode cls, string name) {
    isSetterName(name) and // restrict size of predicate
    result = cls.getAnInstanceReference().getAPropertyWrite(name)
    or
    exists(DataFlow::ClassNode subclass |
      result = getAnInstanceMemberAssignment(subclass, name) and
      not exists(subclass.getInstanceMember(name, DataFlow::MemberKind::setter())) and
      cls = subclass.getADirectSuperClass()
    )
  }

  /**
   * Holds if `write` installs an accessor on an object. Such property writes should not
   * be considered calls to an accessor.
   */
  pragma[nomagic]
  private predicate isAccessorInstallation(DataFlow::PropWrite write) {
    exists(write.getInstalledAccessor(_))
  }

  /**
   * Gets a getter or setter invoked as a result of the given property access.
   */
  cached
  DataFlow::FunctionNode getAnAccessorCallee(DataFlow::PropRef ref) {
    not isAccessorInstallation(ref) and
    (
      exists(DataFlow::ClassNode cls, string name |
        ref = cls.getAnInstanceMemberAccess(name) and
        result = cls.getInstanceMember(name, DataFlow::MemberKind::getter())
        or
        ref = getAnInstanceMemberAssignment(cls, name) and
        result = cls.getInstanceMember(name, DataFlow::MemberKind::setter())
        or
        ref = cls.getAClassReference().getAPropertyRead(name) and
        result = cls.getStaticMember(name, DataFlow::MemberKind::getter())
        or
        ref = cls.getAClassReference().getAPropertyWrite(name) and
        result = cls.getStaticMember(name, DataFlow::MemberKind::setter())
      )
      or
      exists(DataFlow::ObjectLiteralNode object, string name |
        ref = getAnAllocationSiteRef(object).getAPropertyRead(name) and
        result = object.getPropertyGetter(name)
        or
        ref = getAnAllocationSiteRef(object).getAPropertyWrite(name) and
        result = object.getPropertySetter(name)
      )
    )
  }

  private DataFlow::FunctionNode getAMethodOnObject(DataFlow::SourceNode node) {
    (
      result = node.getAPropertySource()
      or
      result = node.(DataFlow::ObjectLiteralNode).getPropertyGetter(_)
      or
      result = node.(DataFlow::ObjectLiteralNode).getPropertySetter(_)
    ) and
    not node.getTopLevel().isExterns() and
    // Ignore writes to `this` inside a constructor, since this is already handled by instance method tracking
    not exists(DataFlow::ClassNode cls |
      node = cls.getConstructor().getReceiver()
      or
      node = cls.(DataFlow::ClassNode::FunctionStyleClass).getAPrototypeReference()
    )
  }

  private predicate shouldTrackObjectWithMethods(DataFlow::SourceNode node) {
    exists(getAMethodOnObject(node))
  }

  /**
   * Gets a step summary for tracking object literals.
   *
   * To avoid false flow from callbacks passed in via "named parameters", we only track object
   * literals out of returns, not into calls.
   */
  private StepSummary objectWithMethodsStep() { result = LevelStep() or result = ReturnStep() }

  /** Gets a node that refers to the given object, via a limited form of type tracking. */
  cached
  DataFlow::SourceNode getAnAllocationSiteRef(DataFlow::SourceNode node) {
    shouldTrackObjectWithMethods(node) and
    result = node
    or
    StepSummary::step(getAnAllocationSiteRef(node), result, objectWithMethodsStep())
  }

  /**
   * Holds if `function` flows to a property of `host` via non-local data flow.
   */
  pragma[nomagic]
  private predicate complexMethodInstallation(
    DataFlow::SourceNode host, DataFlow::FunctionNode function
  ) {
    not function = getAMethodOnObject(_) and
    exists(DataFlow::TypeTracker t |
      getAFunctionReference(function, 0, t) = host.getAPropertySource() and
      t.start() // require call bit to be false
    )
  }

  /**
   * Holds if `pred` is assumed to flow to `succ` because a method is stored on an object that is assumed
   * to be the receiver of calls to that method.
   *
   * For example, object literal below is assumed to flow to the receiver of the `foo` function:
   * ```js
   * let obj = {};
   * obj.foo = function() {}
   * ```
   */
  cached
  predicate impliedReceiverStep(DataFlow::SourceNode pred, DataFlow::SourceNode succ) {
    // To avoid double-recursion, we handle either complex flow for the host object, or for the function, but not both.
    exists(DataFlow::SourceNode host |
      // Complex flow for the host object
      pred = getAnAllocationSiteRef(host) and
      succ = getAMethodOnObject(host).getReceiver()
      or
      // Complex flow for the function
      exists(DataFlow::FunctionNode function |
        complexMethodInstallation(host, function) and
        pred = host and
        succ = function.getReceiver()
      )
    )
  }
}
