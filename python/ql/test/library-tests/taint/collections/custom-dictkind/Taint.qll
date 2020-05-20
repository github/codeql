/**
 * The idea of this test is that each of TAINTED_DICT, FOO_DICT, and BAR_DICT should give
 * rise to one (and only one) TaintKind.
 *
 * With the current setup, the taint of FOO_DICT will give rise to the most-specific
 * classes: FooDict, BarDict, ExternalStringDictKind, and StringDictKind.
 *
 * When modeling a python class that is a dictionary, but also provides custom attributes/methods,
 * it's very useful to be able to define a TaintKind for that specific class. Obviously, such TaintKinds
 * should not be able to influence each other :\
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.External
import semmle.python.security.strings.Untrusted

class DictSource extends TaintSource {
    DictSource() { this.(NameNode).getId() = "TAINTED_DICT" }

    override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringDictKind }
}

class FooDictKind extends TaintKind {
    FooDictKind() { this = "FooDictKind" }

    override TaintKind getTaintOfAttribute(string name) {
        name = "foo" and result instanceof ExternalFileObject
    }
}

class FooDictSource extends TaintSource {
    FooDictSource() { this.(NameNode).getId() = "FOO_DICT" }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof FooDictKind
        or
        kind.(DictKind).getValue() instanceof ExternalStringKind
    }
}

class BarDictKind extends TaintKind {
    BarDictKind() { this = "BarDictKind" }

    override TaintKind getTaintOfAttribute(string name) {
        name = "bar" and result instanceof ExternalFileObject
    }
}

class BarDictSource extends TaintSource {
    BarDictSource() { this.(NameNode).getId() = "BAR_DICT" }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof BarDictKind
        or
        kind.(DictKind).getValue() instanceof ExternalStringKind
    }
}


/**
 * Kind for a custom dictionary class where `dict.key` is the same as `dict['key']`.
 * A real example is `bottle.FormsDict`.
*/
class AttrBasedDictKind extends TaintKind {

    // we _could_ add a `TaintKind valueKind` field, but then we need a way to disallow
    // infinite recursion since `valueKind` could be `AttrBasedDictKind`. Essentially the
    // same problem that CollectionKind, SequenceKind, and DictKind is dealing with :\

    AttrBasedDictKind() { this = "AttrBasedDictKind" }

    // bindingset[name]
    // override TaintKind getTaintOfAttribute(string name) {
    //     result instanceof <TODO>
    // }
}

class AttrBasedDictSource extends TaintSource {

    TaintKind valueKind;

    AttrBasedDictSource() {
        this.(NameNode).getId() = "ATTR_BASED_FILES" and
        valueKind instanceof ExternalFileObject
        or
        this.(NameNode).getId() = "ATTR_BASED_STRINGS" and
        valueKind instanceof ExternalStringKind
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof AttrBasedDictKind
        or
        kind.(DictKind).getValue() = valueKind
    }
}
