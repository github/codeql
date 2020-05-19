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

abstract class FooDictKind extends TaintKind {
    bindingset[this]
    FooDictKind() { any() }
}

private module FooDictKind {
    class SubclassSpecific extends FooDictKind {
        SubclassSpecific() { this = "FooDictKind::SubclassSpecific" }

        override TaintKind getTaintOfAttribute(string name) {
            name = "foo" and result instanceof ExternalFileObject
        }
    }

    class DictPart extends FooDictKind, ExternalStringDictKind { }
}

class FooDictSource extends TaintSource {
    FooDictSource() { this.(NameNode).getId() = "FOO_DICT" }

    override predicate isSourceOf(TaintKind kind) { kind instanceof FooDictKind }
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
        kind instanceof ExternalStringDictKind
    }
}
