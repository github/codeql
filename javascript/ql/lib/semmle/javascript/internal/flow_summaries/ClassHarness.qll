/**
 * Contains flow for the "class harness", which facilitates flow from constructor to methods in a class.
 */

private import javascript
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.internal.DataFlowPrivate

/**
 * Synthesizes a callable for each class, which invokes the class constructor and every
 * instance method with the same value of `this`.
 *
 * This ensures flow between methods in a class when the source originated "within the class",
 * but not when the flow into the field came from an argument.
 *
 * For example:
 * ```js
 * class C {
 *   constructor(arg) {
 *     this.x = sourceOfTaint();
 *     this.y = arg;
 *   }
 *   method() {
 *     sink(this.x); // sourceOfTaint() flows here
 *     sink(this.y); // but 'arg' does not flow here (only through real call sites)
 *   }
 * }
 * ```
 *
 * The class harness for a class `C` can roughly be thought of as the following code:
 * ```js
 * function classHarness() {
 *   var c = new C();
 *   while (true) {
 *     // call an arbitrary instance methods in the loop
 *     c.arbitraryInstaceMethod();
 *   }
 * }
 * ```
 *
 * This is realized with the following data flow graph:
 * ```
 * [Call to constructor]
 *     |
 *     | post-update for 'this' argument
 *     V
 * [Data flow node]   <----------------------+
 *     |                                     |
 *     | 'this' argument                     | post-update for 'this' argument
 *     V                                     |
 *  [Call to an instance method]  -----------+
 * ```
 */
class ClassHarnessModel extends AdditionalFlowInternal {
  override predicate needsSynthesizedCallable(AstNode node, string tag) {
    node instanceof Function and
    not node instanceof ArrowFunctionExpr and // can't be called with 'new'
    not node.getTopLevel().isExterns() and // we don't need harnesses in externs
    tag = "class-harness"
  }

  override predicate needsSynthesizedCall(AstNode node, string tag, DataFlowCallable container) {
    container = getSynthesizedCallable(node, "class-harness") and
    tag = ["class-harness-constructor-call", "class-harness-method-call"]
  }

  override predicate needsSynthesizedNode(AstNode node, string tag, DataFlowCallable container) {
    // We synthesize two nodes, but note that `class-harness-constructor-this-arg` never actually has any
    // ingoing flow, we just need it to specify which post-update node to use for that argument.
    container = getSynthesizedCallable(node, "class-harness") and
    tag = ["class-harness-constructor-this-arg", "class-harness-method-this-arg"]
  }

  override predicate argument(DataFlowCall call, ArgumentPosition pos, DataFlow::Node value) {
    pos.isThis() and
    exists(Function f |
      call = getSynthesizedCall(f, "class-harness-constructor-call") and
      value = getSynthesizedNode(f, "class-harness-constructor-this-arg")
      or
      call = getSynthesizedCall(f, "class-harness-method-call") and
      value = getSynthesizedNode(f, "class-harness-method-this-arg")
    )
  }

  override predicate postUpdate(DataFlow::Node pre, DataFlow::Node post) {
    exists(Function f |
      pre =
        getSynthesizedNode(f,
          ["class-harness-constructor-this-arg", "class-harness-method-this-arg"]) and
      post = getSynthesizedNode(f, "class-harness-method-this-arg")
    )
  }

  override predicate viableCallable(DataFlowCall call, DataFlowCallable target) {
    exists(DataFlow::ClassNode cls, Function f | f = cls.getConstructor().getFunction() |
      call = getSynthesizedCall(f, "class-harness-constructor-call") and
      target.asSourceCallable() = f
      or
      call = getSynthesizedCall(f, "class-harness-method-call") and
      target.asSourceCallable() = cls.getAnInstanceMember().getFunction()
    )
  }
}
