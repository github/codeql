import python
import Basic
private import Common

/**
 * An extensible kind of taint representing an externally controlled string.
 */
abstract class ExternalStringKind extends StringKind {
  bindingset[this]
  ExternalStringKind() { this = this }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    result = StringKind.super.getTaintForFlowStep(fromnode, tonode)
    or
    tonode.(SequenceNode).getElement(_) = fromnode and
    result.(ExternalStringSequenceKind).getItem() = this
    or
    json_load(fromnode, tonode) and result.(ExternalJsonKind).getValue() = this
    or
    tonode.(DictNode).getAValue() = fromnode and result.(ExternalStringDictKind).getValue() = this
    or
    urlsplit(fromnode, tonode) and result.(ExternalUrlSplitResult).getItem() = this
    or
    urlparse(fromnode, tonode) and result.(ExternalUrlParseResult).getItem() = this
    or
    parse_qs(fromnode, tonode) and result.(ExternalStringDictKind).getValue() = this
    or
    parse_qsl(fromnode, tonode) and result.(SequenceKind).getItem().(SequenceKind).getItem() = this
  }
}

/** A kind of "taint", representing a sequence, with a "taint" member */
class ExternalStringSequenceKind extends SequenceKind {
  ExternalStringSequenceKind() { this.getItem() instanceof ExternalStringKind }
}

/**
 * An hierachical dictionary or list where the entire structure is externally controlled
 * This is typically a parsed JSON object.
 */
class ExternalJsonKind extends TaintKind {
  ExternalJsonKind() { this = "json[" + any(ExternalStringKind key) + "]" }

  /** Gets the taint kind for item in this sequence */
  TaintKind getValue() {
    this = "json[" + result + "]"
    or
    result = this
  }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    this.taints(fromnode) and
    json_subscript_taint(tonode, fromnode, this, result)
    or
    result = this and copy_call(fromnode, tonode)
  }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "get" and result = this.getValue()
  }
}

/** A kind of "taint", representing a dictionary mapping keys to tainted strings. */
class ExternalStringDictKind extends DictKind {
  ExternalStringDictKind() { this.getValue() instanceof ExternalStringKind }
}

/**
 * A kind of "taint", representing a dictionary mapping keys to sequences of
 *  tainted strings.
 */
class ExternalStringSequenceDictKind extends DictKind {
  ExternalStringSequenceDictKind() { this.getValue() instanceof ExternalStringSequenceKind }
}

/** TaintKind for the result of `urlsplit(tainted_string)` */
class ExternalUrlSplitResult extends ExternalStringSequenceKind {
  // https://docs.python.org/3/library/urllib.parse.html#urllib.parse.urlsplit
  override TaintKind getTaintOfAttribute(string name) {
    result = super.getTaintOfAttribute(name)
    or
    (
      // namedtuple field names
      name = "scheme" or
      name = "netloc" or
      name = "path" or
      name = "query" or
      name = "fragment" or
      // class methods
      name = "username" or
      name = "password" or
      name = "hostname"
    ) and
    result instanceof ExternalStringKind
  }

  override TaintKind getTaintOfMethodResult(string name) {
    result = super.getTaintOfMethodResult(name)
    or
    name = "geturl" and
    result instanceof ExternalStringKind
  }
}

/** TaintKind for the result of `urlparse(tainted_string)` */
class ExternalUrlParseResult extends ExternalStringSequenceKind {
  // https://docs.python.org/3/library/urllib.parse.html#urllib.parse.urlparse
  override TaintKind getTaintOfAttribute(string name) {
    result = super.getTaintOfAttribute(name)
    or
    (
      // namedtuple field names
      name = "scheme" or
      name = "netloc" or
      name = "path" or
      name = "params" or
      name = "query" or
      name = "fragment" or
      // class methods
      name = "username" or
      name = "password" or
      name = "hostname"
    ) and
    result instanceof ExternalStringKind
  }

  override TaintKind getTaintOfMethodResult(string name) {
    result = super.getTaintOfMethodResult(name)
    or
    name = "geturl" and
    result instanceof ExternalStringKind
  }
}

/* Helper for getTaintForStep() */
pragma[noinline]
private predicate json_subscript_taint(
  SubscriptNode sub, ControlFlowNode obj, ExternalJsonKind seq, TaintKind key
) {
  sub.isLoad() and
  sub.getObject() = obj and
  key = seq.getValue()
}

private predicate json_load(ControlFlowNode fromnode, CallNode tonode) {
  tonode = Value::named("json.loads").getACall() and
  tonode.getArg(0) = fromnode
}

private predicate urlsplit(ControlFlowNode fromnode, CallNode tonode) {
  // This could be implemented as `exists(FunctionValue` without the explicit six part,
  // but then our tests will need to import +100 modules, so for now this slightly
  // altered version gets to live on.
  exists(Value urlsplit |
    (
      urlsplit = Value::named("six.moves.urllib.parse.urlsplit")
      or
      // Python 2
      urlsplit = Value::named("urlparse.urlsplit")
      or
      // Python 3
      urlsplit = Value::named("urllib.parse.urlsplit")
    ) and
    tonode = urlsplit.getACall() and
    tonode.getArg(0) = fromnode
  )
}

private predicate urlparse(ControlFlowNode fromnode, CallNode tonode) {
  // This could be implemented as `exists(FunctionValue` without the explicit six part,
  // but then our tests will need to import +100 modules, so for now this slightly
  // altered version gets to live on.
  exists(Value urlparse |
    (
      urlparse = Value::named("six.moves.urllib.parse.urlparse")
      or
      // Python 2
      urlparse = Value::named("urlparse.urlparse")
      or
      // Python 3
      urlparse = Value::named("urllib.parse.urlparse")
    ) and
    tonode = urlparse.getACall() and
    tonode.getArg(0) = fromnode
  )
}

private predicate parse_qs(ControlFlowNode fromnode, CallNode tonode) {
  // This could be implemented as `exists(FunctionValue` without the explicit six part,
  // but then our tests will need to import +100 modules, so for now this slightly
  // altered version gets to live on.
  exists(Value parse_qs |
    (
      parse_qs = Value::named("six.moves.urllib.parse.parse_qs")
      or
      // Python 2
      parse_qs = Value::named("urlparse.parse_qs")
      or
      // Python 2 deprecated version of `urlparse.parse_qs`
      parse_qs = Value::named("cgi.parse_qs")
      or
      // Python 3
      parse_qs = Value::named("urllib.parse.parse_qs")
    ) and
    tonode = parse_qs.getACall() and
    (
      tonode.getArg(0) = fromnode
      or
      tonode.getArgByName("qs") = fromnode
    )
  )
}

private predicate parse_qsl(ControlFlowNode fromnode, CallNode tonode) {
  // This could be implemented as `exists(FunctionValue` without the explicit six part,
  // but then our tests will need to import +100 modules, so for now this slightly
  // altered version gets to live on.
  exists(Value parse_qsl |
    (
      parse_qsl = Value::named("six.moves.urllib.parse.parse_qsl")
      or
      // Python 2
      parse_qsl = Value::named("urlparse.parse_qsl")
      or
      // Python 2 deprecated version of `urlparse.parse_qsl`
      parse_qsl = Value::named("cgi.parse_qsl")
      or
      // Python 3
      parse_qsl = Value::named("urllib.parse.parse_qsl")
    ) and
    tonode = parse_qsl.getACall() and
    (
      tonode.getArg(0) = fromnode
      or
      tonode.getArgByName("qs") = fromnode
    )
  )
}

/** A kind of "taint", representing an open file-like object from an external source. */
class ExternalFileObject extends TaintKind {
  ExternalStringKind valueKind;

  ExternalFileObject() { this = "file[" + valueKind + "]" }

  /** Gets the taint kind for the contents of this file */
  TaintKind getValue() { result = valueKind }

  override TaintKind getTaintOfMethodResult(string name) {
    name in ["read", "readline"] and result = this.getValue()
    or
    name = "readlines" and result.(SequenceKind).getItem() = this.getValue()
  }

  override TaintKind getTaintForIteration() { result = this.getValue() }
}

/**
 * Temporary sanitizer for the tainted result from `urlsplit` and `urlparse`. Can be used to reduce FPs until
 * we have better support for namedtuples.
 *
 * Will clear **all** taint on a test of the kind. That is, on the true edge of any matching test,
 * all fields/indexes will be cleared of taint.
 *
 * Handles:
 * - `if splitres.netloc == "KNOWN_VALUE"`
 * - `if splitres[0] == "KNOWN_VALUE"`
 */
class UrlsplitUrlparseTempSanitizer extends Sanitizer {
  // TODO: remove this once we have better support for named tuples
  UrlsplitUrlparseTempSanitizer() { this = "UrlsplitUrlparseTempSanitizer" }

  override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
    (
      taint instanceof ExternalUrlSplitResult
      or
      taint instanceof ExternalUrlParseResult
    ) and
    exists(ControlFlowNode full_use |
      full_use.(SubscriptNode).getObject() = test.getInput().getAUse()
      or
      full_use.(AttrNode).getObject() = test.getInput().getAUse()
    |
      clears_taint(full_use, test.getTest(), test.getSense())
    )
  }

  private predicate clears_taint(ControlFlowNode tainted, ControlFlowNode test, boolean sense) {
    test_equality_with_const(test, tainted, sense)
    or
    test_in_const_seq(test, tainted, sense)
    or
    test.(UnaryExprNode).getNode().getOp() instanceof Not and
    exists(ControlFlowNode nested_test |
      nested_test = test.(UnaryExprNode).getOperand() and
      clears_taint(tainted, nested_test, sense.booleanNot())
    )
  }

  /** holds for `== "KNOWN_VALUE"` on `true` edge, and `!= "KNOWN_VALUE"` on `false` edge */
  private predicate test_equality_with_const(CompareNode cmp, ControlFlowNode tainted, boolean sense) {
    exists(ControlFlowNode const, Cmpop op | const.getNode() instanceof StrConst |
      (
        cmp.operands(const, op, tainted)
        or
        cmp.operands(tainted, op, const)
      ) and
      (
        op instanceof Eq and sense = true
        or
        op instanceof NotEq and sense = false
      )
    )
  }

  /** holds for `in ["KNOWN_VALUE", ...]` on `true` edge, and `not in ["KNOWN_VALUE", ...]` on `false` edge */
  private predicate test_in_const_seq(CompareNode cmp, ControlFlowNode tainted, boolean sense) {
    exists(SequenceNode const_seq, Cmpop op |
      forall(ControlFlowNode elem | elem = const_seq.getAnElement() |
        elem.getNode() instanceof StrConst
      )
    |
      cmp.operands(tainted, op, const_seq) and
      (
        op instanceof In and sense = true
        or
        op instanceof NotIn and sense = false
      )
    )
  }
}
