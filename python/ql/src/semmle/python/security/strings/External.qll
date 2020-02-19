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

/** A kind of "taint", representing a dictionary mapping str->"taint" */
class ExternalStringDictKind extends DictKind {
    ExternalStringDictKind() { this.getValue() instanceof ExternalStringKind }
}

/**
 * A kind of "taint", representing a dictionary mapping strings to sequences of
 *  tainted strings
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
    sub.getValue() = obj and
    key = seq.getValue()
}

private predicate json_load(ControlFlowNode fromnode, CallNode tonode) {
    exists(FunctionObject json_loads |
        ModuleObject::named("json").attr("loads") = json_loads and
        json_loads.getACall() = tonode and
        tonode.getArg(0) = fromnode
    )
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

/** A kind of "taint", representing an open file-like object from an external source. */
class ExternalFileObject extends TaintKind {
    ExternalFileObject() { this = "file[" + any(ExternalStringKind key) + "]" }

    /** Gets the taint kind for the contents of this file */
    TaintKind getValue() { this = "file[" + result + "]" }

    override TaintKind getTaintOfMethodResult(string name) {
        name = "read" and result = this.getValue()
    }
}
