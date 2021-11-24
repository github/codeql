/**
 * INTERNAL: Do not use.
 *
 * Notice: The predicates provided in this module is a poor mans solution for function
 * resolution, and does not handle anything but the most simple cases.
 *
 * For example, in the code below, we're not able to tell anything about
 * `inst.my_method` (which is a bound-method)
 * ```py
 * class MyClass:
 *     def my_method(self):
 *         pass
 *
 * inst = MyClass()
 * print(inst.my_method)
 * ```
 */

private import python
private import semmle.python.dataflow.new.DataFlow

/**
 * Gets the last decorator call for the function `func`, if `func` has decorators.
 */
private Expr lastDecoratorCall(Function func) {
  result = func.getDefinition().(FunctionExpr).getADecoratorCall() and
  not exists(Call other_decorator | other_decorator.getArg(0) = result)
}

/**
 * Gets a reference to the Function `func`.
 *
 * Notice: This is a poor mans solution for function resolution, and does not handle
 * anything but the most simple cases.
 *
 * For example, in the code below, we're not able to tell anything about
 * `inst.my_method` (which is a bound-method)
 * ```py
 * class MyClass:
 *     def my_method(self):
 *         pass
 *
 * inst = MyClass()
 * print(inst.my_method)
 * ```
 */
private DataFlow::TypeTrackingNode poorMansFunctionTracker(DataFlow::TypeTracker t, Function func) {
  t.start() and
  (
    not exists(func.getADecorator()) and
    result.asExpr() = func.getDefinition()
    or
    // If the function has decorators, we still want to model the function as being
    // the request handler for a route setup. In such situations, we must track the
    // last decorator call instead of the function itself.
    //
    // Note that this means that we blindly ignore what the decorator actually does to
    // the function, which seems like an OK tradeoff.
    result.asExpr() = lastDecoratorCall(func)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = poorMansFunctionTracker(t2, func).track(t2, t))
}

/** Helper predicate to avoid bad join order. */
pragma[noinline]
private predicate getSimpleMethodReferenceWithinClass_helper(
  Function func, Class cls, DataFlow::AttrRead read
) {
  DataFlow::parameterNode(func.getArg(0)).flowsTo(read.getObject()) and
  cls.getAMethod() = func
}

/**
 * Helper predicate to avoid bad join order, which looked like:
 *
 * (8s) Tuple counts for PoorMansFunctionResolution::getSimpleMethodReferenceWithinClass#ff/2@cbddf257 after 8.6s:
 * 387565   ~0%     {3} r1 = JOIN Attributes::AttrRead#class#f WITH Attributes::AttrRef::accesses_dispred#bff ON FIRST 1 OUTPUT Rhs.2, Lhs.0 'result', Rhs.1
 * 6548632  ~0%     {3} r2 = JOIN r1 WITH Function::Function::getName_dispred#ff_10#join_rhs ON FIRST 1 OUTPUT Rhs.1 'func', Lhs.1 'result', Lhs.2
 * 5640480  ~0%     {4} r3 = JOIN r2 WITH Class::Class::getAMethod_dispred#ff_10#join_rhs ON FIRST 1 OUTPUT Rhs.1, Lhs.1 'result', Lhs.2, Lhs.0 'func'
 * 55660458 ~0%     {5} r4 = JOIN r3 WITH Class::Class::getAMethod_dispred#ff ON FIRST 1 OUTPUT Rhs.1, 0, Lhs.1 'result', Lhs.2, Lhs.3 'func'
 * 55621412 ~0%     {4} r5 = JOIN r4 WITH AstGenerated::Function_::getArg_dispred#fff ON FIRST 2 OUTPUT Rhs.2, Lhs.2 'result', Lhs.3, Lhs.4 'func'
 * 54467144 ~0%     {4} r6 = JOIN r5 WITH DataFlowPublic::ParameterNode::getParameter_dispred#fb_10#join_rhs ON FIRST 1 OUTPUT Lhs.2, Rhs.1, Lhs.1 'result', Lhs.3 'func'
 * 20928    ~0%     {2} r7 = JOIN r6 WITH LocalSources::Cached::hasLocalSource#ff ON FIRST 2 OUTPUT Lhs.3 'func', Lhs.2 'result'
 *                                        return r7
 */
pragma[noinline]
private predicate getSimpleMethodReferenceWithinClass_helper2(
  Function func, Class cls, DataFlow::AttrRead read, Function readFunction
) {
  getSimpleMethodReferenceWithinClass_helper(pragma[only_bind_into](func),
    pragma[only_bind_into](cls), pragma[only_bind_into](read)) and
  read.getAttributeName() = readFunction.getName()
}

/**
 * Gets a reference to `func`. `func` must be defined inside a class, and the reference
 * will be inside a different method of the same class.
 */
private DataFlow::Node getSimpleMethodReferenceWithinClass(Function func) {
  // TODO: Should take MRO into account
  exists(Class cls, Function otherFunc |
    cls.getAMethod() = func and
    cls.getAMethod() = otherFunc
  |
    getSimpleMethodReferenceWithinClass_helper2(pragma[only_bind_into](otherFunc),
      pragma[only_bind_into](cls), pragma[only_bind_into](result), pragma[only_bind_into](func))
  )
}

/**
 * INTERNAL: Do not use.
 *
 * Gets a reference to the Function `func`.
 *
 * Notice: This is a poor mans solution for function resolution, and does not handle
 * anything but the most simple cases.
 *
 * For example, in the code below, we're not able to tell anything about
 * `inst.my_method` (which is a bound-method)
 * ```py
 * class MyClass:
 *     def my_method(self):
 *         pass
 *
 * inst = MyClass()
 * print(inst.my_method)
 * ```
 *
 * But it is able to handle simple method calls within a class (but does not take MRO into
 * account).
 * ```py
 * class MyClass:
 *     def method1(self);
 *         pass
 *
 *     def method2(self);
 *         self.method1()
 * ```
 */
DataFlow::Node poorMansFunctionTracker(Function func) {
  poorMansFunctionTracker(DataFlow::TypeTracker::end(), func).flowsTo(result)
  or
  result = getSimpleMethodReferenceWithinClass(func)
}
