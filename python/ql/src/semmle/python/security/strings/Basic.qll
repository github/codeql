import python
private import Common
import semmle.python.dataflow.TaintTracking

/** An extensible kind of taint representing any kind of string. */
abstract class StringKind extends TaintKind {
  bindingset[this]
  StringKind() { this = this }

  override TaintKind getTaintOfMethodResult(string name) {
    name in ["capitalize", "casefold", "center", "expandtabs", "format", "format_map", "ljust",
          "lstrip", "lower", "replace", "rjust", "rstrip", "strip", "swapcase", "title", "upper",
          "zfill",
          /* encode/decode is technically not correct, but close enough */
          "encode", "decode"] and
    result = this
    or
    name in ["partition", "rpartition", "rsplit", "split", "splitlines"] and
    result.(SequenceKind).getItem() = this
  }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    result = this and
    (
      slice(fromnode, tonode) or
      tonode.(BinaryExprNode).getAnOperand() = fromnode or
      os_path_join(fromnode, tonode) or
      str_format(fromnode, tonode) or
      encode_decode(fromnode, tonode) or
      to_str(fromnode, tonode) or
      f_string(fromnode, tonode)
    )
    or
    result = this and copy_call(fromnode, tonode)
  }

  override ClassValue getType() {
    result = Value::named("bytes") or
    result = Value::named("str") or
    result = Value::named("unicode")
  }
}

private class StringEqualitySanitizer extends Sanitizer {
  StringEqualitySanitizer() { this = "string equality sanitizer" }

  /** The test `if untrusted == "KNOWN_VALUE":` sanitizes `untrusted` on its `true` edge. */
  override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
    taint instanceof StringKind and
    exists(ControlFlowNode const, Cmpop op | const.getNode() instanceof StrConst |
      (
        test.getTest().(CompareNode).operands(const, op, _)
        or
        test.getTest().(CompareNode).operands(_, op, const)
      ) and
      (
        op instanceof Eq and test.getSense() = true
        or
        op instanceof NotEq and test.getSense() = false
      )
    )
  }
}

/** tonode = ....format(fromnode) */
private predicate str_format(ControlFlowNode fromnode, CallNode tonode) {
  tonode.getFunction().(AttrNode).getName() = "format" and
  tonode.getAnArg() = fromnode
}

/** tonode = codec.[en|de]code(fromnode) */
private predicate encode_decode(ControlFlowNode fromnode, CallNode tonode) {
  exists(FunctionObject func, string name |
    not func.getFunction().isMethod() and
    func.getACall() = tonode and
    tonode.getAnArg() = fromnode and
    func.getName() = name
  |
    name = "encode" or
    name = "decode" or
    name = "decodestring"
  )
}

/** tonode = str(fromnode) */
private predicate to_str(ControlFlowNode fromnode, CallNode tonode) {
  tonode.getAnArg() = fromnode and
  (
    tonode = ClassValue::bytes().getACall()
    or
    tonode = ClassValue::unicode().getACall()
  )
}

/** tonode = fromnode[:] */
private predicate slice(ControlFlowNode fromnode, SubscriptNode tonode) {
  exists(Slice all |
    all = tonode.getIndex().getNode() and
    not exists(all.getStart()) and
    not exists(all.getStop()) and
    tonode.getObject() = fromnode
  )
}

/** tonode = os.path.join(..., fromnode, ...) */
private predicate os_path_join(ControlFlowNode fromnode, CallNode tonode) {
  tonode = Value::named("os.path.join").getACall() and
  tonode.getAnArg() = fromnode
}

/** tonode = f"... {fromnode} ..." */
private predicate f_string(ControlFlowNode fromnode, ControlFlowNode tonode) {
  tonode.getNode().(Fstring).getAValue() = fromnode.getNode()
}

/**
 * A kind of "taint", representing a dictionary mapping str->"taint"
 *
 * DEPRECATED: Use `ExternalStringDictKind` instead.
 */
deprecated class StringDictKind extends DictKind {
  StringDictKind() { this.getValue() instanceof StringKind }
}
