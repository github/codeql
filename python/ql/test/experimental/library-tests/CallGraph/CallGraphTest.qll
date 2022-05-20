import python

/** Gets the comment on the line above `ast` */
Comment commentFor(AstNode ast) {
  exists(int line | line = ast.getLocation().getStartLine() - 1 |
    result
        .getLocation()
        .hasLocationInfo(ast.getLocation().getFile().getAbsolutePath(), line, _, line, _)
  )
}

/** Gets the value from `tag:value` in the comment for `ast` */
string getAnnotation(AstNode ast, string tag) {
  exists(Comment comment, string match, string theRegex |
    theRegex = "([\\w]+):([\\w.]+)" and
    comment = commentFor(ast) and
    match = comment.getText().regexpFind(theRegex, _, _) and
    tag = match.regexpCapture(theRegex, 1) and
    result = match.regexpCapture(theRegex, 2)
  )
}

/** Gets a callable annotated with `name:name` */
Function annotatedCallable(string name) { name = getAnnotation(result, "name") }

/** Gets a call annotated with `calls:name` */
Call annotatedCall(string name) { name = getAnnotation(result, "calls") }

predicate missingAnnotationForCallable(string name, Call call) {
  call = annotatedCall(name) and
  not exists(annotatedCallable(name))
}

predicate nonUniqueAnnotationForCallable(string name, Function callable) {
  strictcount(annotatedCallable(name)) > 1 and
  callable = annotatedCallable(name)
}

predicate missingAnnotationForCall(string name, Function callable) {
  not exists(annotatedCall(name)) and
  callable = annotatedCallable(name)
}

/** There is an obvious problem with the annotation `name` */
predicate nameInErrorState(string name) {
  missingAnnotationForCallable(name, _)
  or
  nonUniqueAnnotationForCallable(name, _)
  or
  missingAnnotationForCall(name, _)
}

/** Source code has annotation with `name` showing that `call` will call `callable` */
predicate annotatedCallEdge(string name, Call call, Function callable) {
  not nameInErrorState(name) and
  call = annotatedCall(name) and
  callable = annotatedCallable(name)
}

// ------------------------- Annotation debug query predicates -------------------------
query predicate debug_missingAnnotationForCallable(Call call, string message) {
  exists(string name |
    message =
      "This call is annotated with '" + name +
        "', but no callable with that annotation was extracted. Please fix." and
    missingAnnotationForCallable(name, call)
  )
}

query predicate debug_nonUniqueAnnotationForCallable(Function callable, string message) {
  exists(string name |
    message = "Multiple callables are annotated with '" + name + "'. Please fix." and
    nonUniqueAnnotationForCallable(name, callable)
  )
}

query predicate debug_missingAnnotationForCall(Function callable, string message) {
  exists(string name |
    message =
      "This callable is annotated with '" + name +
        "', but no call with that annotation was extracted. Please fix." and
    missingAnnotationForCall(name, callable)
  )
}

// ------------------------- Call Graph resolution -------------------------
private newtype TCallGraphResolver =
  TPointsToResolver() or
  TTypeTrackerResolver()

/** A method of call graph resolution */
abstract class CallGraphResolver extends TCallGraphResolver {
  abstract predicate callEdge(Call call, Function callable);

  /**
   * Holds if annotations show that `call` will call `callable`,
   * but our call graph resolver was not able to figure that out
   */
  predicate expectedCallEdgeNotFound(Call call, Function callable) {
    annotatedCallEdge(_, call, callable) and
    not this.callEdge(call, callable)
  }

  /**
   * Holds if there are no annotations that show that `call` will call `callable` (where at least one of these are annotated),
   * but the call graph resolver claims that `call` will call `callable`
   */
  predicate unexpectedCallEdgeFound(Call call, Function callable, string message) {
    this.callEdge(call, callable) and
    not annotatedCallEdge(_, call, callable) and
    (
      exists(string name |
        message = "Call resolved to the callable named '" + name + "' but was not annotated as such" and
        callable = annotatedCallable(name) and
        not nameInErrorState(name)
      )
      or
      exists(string name |
        message = "Annotated call resolved to unannotated callable" and
        call = annotatedCall(name) and
        not nameInErrorState(name) and
        not exists( | callable = annotatedCallable(_))
      )
    )
  }

  string toString() { result = "CallGraphResolver" }
}

/** A call graph resolver based on the existing points-to analysis */
class PointsToResolver extends CallGraphResolver, TPointsToResolver {
  override predicate callEdge(Call call, Function callable) {
    exists(PythonFunctionValue funcValue |
      funcValue.getScope() = callable and
      call = funcValue.getACall().getNode()
    )
  }

  override string toString() { result = "PointsToResolver" }
}

/** A call graph resolved based on Type Trackers */
class TypeTrackerResolver extends CallGraphResolver, TTypeTrackerResolver {
  override predicate callEdge(Call call, Function callable) { none() }

  override string toString() { result = "TypeTrackerResolver" }
}
