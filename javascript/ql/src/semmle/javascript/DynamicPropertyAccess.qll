/**
 * Provides classes for working with dynamic property accesses.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.DataFlow::DataFlow
private import semmle.javascript.dataflow.internal.FlowSteps

/**
 * Gets a node that refers to an element of `array`, likely obtained
 * as a result of enumerating the elements of the array.
 */
SourceNode getAnEnumeratedArrayElement(SourceNode array) {
  exists(MethodCallNode call, string name |
    call = array.getAMethodCall(name) and
    (name = "forEach" or name = "map") and
    result = call.getCallback(0).getParameter(0)
  )
  or
  exists(DataFlow::PropRead read |
    read = array.getAPropertyRead() and
    not exists(read.getPropertyName()) and
    not read.getPropertyNameExpr().analyze().getAType() = TTString() and
    result = read
  )
}

/**
 * A data flow node that refers to the name of a property obtained by enumerating
 * the properties of some object.
 */
abstract class EnumeratedPropName extends DataFlow::Node {
  /**
   * Gets the data flow node holding the object whose properties are being enumerated.
   *
   * For example, gets `src` in `for (var key in src)`.
   */
  abstract DataFlow::Node getSourceObject();

  /**
   * Gets a source node that refers to the object whose properties are being enumerated.
   */
  DataFlow::SourceNode getASourceObjectRef() {
    result = AccessPath::getAnAliasedSourceNode(getSourceObject())
  }

  /**
   * Gets a property read that accesses the corresponding property value in the source object.
   *
   * For example, gets `src[key]` in `for (var key in src) { src[key]; }`.
   */
  SourceNode getASourceProp() {
    exists(Node base, Node key |
      dynamicPropReadStep(base, key, result) and
      getASourceObjectRef().flowsTo(base) and
      key.getImmediatePredecessor*() = this
    )
  }
}

/**
 * Property enumeration through `for-in` for `Object.keys` or similar.
 */
private class ForInEnumeratedPropName extends EnumeratedPropName {
  DataFlow::Node object;

  ForInEnumeratedPropName() {
    exists(ForInStmt stmt |
      this = DataFlow::lvalueNode(stmt.getLValue()) and
      object = stmt.getIterationDomain().flow()
    )
    or
    exists(CallNode call |
      call = globalVarRef("Object").getAMemberCall("keys")
      or
      call = globalVarRef("Object").getAMemberCall("getOwnPropertyNames")
      or
      call = globalVarRef("Reflect").getAMemberCall("ownKeys")
    |
      object = call.getArgument(0) and
      this = getAnEnumeratedArrayElement(call)
    )
  }

  override Node getSourceObject() { result = object }
}

/**
 * Property enumeration through `Object.entries`.
 */
private class EntriesEnumeratedPropName extends EnumeratedPropName {
  CallNode entries;
  SourceNode entry;

  EntriesEnumeratedPropName() {
    entries = globalVarRef("Object").getAMemberCall("entries") and
    entry = getAnEnumeratedArrayElement(entries) and
    this = entry.getAPropertyRead("0")
  }

  override DataFlow::Node getSourceObject() { result = entries.getArgument(0) }

  override SourceNode getASourceProp() {
    result = super.getASourceProp()
    or
    result = entry.getAPropertyRead("1")
  }
}

/**
 * Gets a function that enumerates object properties when invoked.
 *
 * Invocations takes the following form:
 * ```js
 * fn(obj, (value, key, o) => { ... })
 * ```
 */
private SourceNode propertyEnumerator() {
  result = moduleImport("for-own") or
  result = moduleImport("for-in") or
  result = moduleMember("ramda", "forEachObjIndexed") or
  result = LodashUnderscore::member("forEach") or
  result = LodashUnderscore::member("each")
}

/**
 * Property enumeration through a library function taking a callback.
 */
private class LibraryCallbackEnumeratedPropName extends EnumeratedPropName {
  CallNode call;
  FunctionNode callback;

  LibraryCallbackEnumeratedPropName() {
    call = propertyEnumerator().getACall() and
    callback = call.getCallback(1) and
    this = callback.getParameter(1)
  }

  override Node getSourceObject() { result = call.getArgument(0) }

  override SourceNode getASourceObjectRef() {
    result = super.getASourceObjectRef()
    or
    result = callback.getParameter(2)
  }

  override SourceNode getASourceProp() {
    result = super.getASourceProp()
    or
    result = callback.getParameter(0)
  }
}

/**
 * A dynamic property access that is not obviously an array access.
 */
class DynamicPropRead extends DataFlow::SourceNode, DataFlow::ValueNode {
  // Use IndexExpr instead of PropRead as we're not interested in implicit accesses like
  // rest-patterns and for-of loops.
  override IndexExpr astNode;

  DynamicPropRead() {
    not exists(astNode.getPropertyName()) and
    // Exclude obvious array access
    astNode.getPropertyNameExpr().analyze().getAType() = TTString()
  }

  /** Gets the base of the dynamic read. */
  DataFlow::Node getBase() { result = astNode.getBase().flow() }

  /** Gets the node holding the name of the property. */
  DataFlow::Node getPropertyNameNode() { result = astNode.getIndex().flow() }

  /**
   * Holds if the value of this read was assigned to earlier in the same basic block.
   *
   * For example, this is true for `dst[x]` on line 2 below:
   * ```js
   * dst[x] = {};
   * dst[x][y] = src[y];
   * ```
   */
  predicate hasDominatingAssignment() {
    exists(DataFlow::PropWrite write, BasicBlock bb, int i, int j, SsaVariable ssaVar |
      write = getBase().getALocalSource().getAPropertyWrite() and
      bb.getNode(i) = write.getWriteNode() and
      bb.getNode(j) = astNode and
      i < j and
      write.getPropertyNameExpr() = ssaVar.getAUse() and
      astNode.getIndex() = ssaVar.getAUse()
    )
  }
}

/**
 * Holds if `output` is the result of `base[key]`, either directly or through
 * one or more function calls, ignoring reads that can't access the prototype chain.
 */
predicate dynamicPropReadStep(Node base, Node key, SourceNode output) {
  exists(DynamicPropRead read |
    not read.hasDominatingAssignment() and
    base = read.getBase() and
    key = read.getPropertyNameNode() and
    output = read
  )
  or
  // Summarize functions returning a dynamic property read of two parameters, such as `function getProp(obj, prop) { return obj[prop]; }`.
  exists(
    CallNode call, Function callee, ParameterNode baseParam, ParameterNode keyParam, Node innerBase,
    Node innerKey, SourceNode innerOutput
  |
    dynamicPropReadStep(innerBase, innerKey, innerOutput) and
    baseParam.flowsTo(innerBase) and
    keyParam.flowsTo(innerKey) and
    innerOutput.flowsTo(callee.getAReturnedExpr().flow()) and
    call.getACallee() = callee and
    argumentPassingStep(call, base, callee, baseParam) and
    argumentPassingStep(call, key, callee, keyParam) and
    output = call
  )
}
