/**
 * Inline-expectations test for the store/load/delete/parameter
 * classification predicates on the new-CFG facade.
 *
 * Each tag fires when the corresponding predicate (`isLoad`,
 * `isStore`, `isDelete`, `isParameter`, `isAugLoad`, `isAugStore`)
 * holds on the canonical CFG node wrapping a `Py::Name` with the
 * given identifier. Subscript and attribute stores are not covered
 * by these tags — only the `Name`-typed targets/loads they involve.
 */

import python
import semmle.python.controlflow.internal.Cfg as Cfg
import utils.test.InlineExpectationsTest

module StoreLoadTest implements TestSig {
  string getARelevantTag() { result = ["load", "store", "delete", "param", "augload", "augstore"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Cfg::NameNode n |
      location = n.getLocation() and
      element = n.toString() and
      value = n.getId() and
      (
        n.isLoad() and not n.isAugLoad() and tag = "load"
        or
        n.isStore() and not n.isAugStore() and tag = "store"
        or
        n.isDelete() and tag = "delete"
        or
        n.isParameter() and tag = "param"
        or
        n.isAugLoad() and tag = "augload"
        or
        n.isAugStore() and tag = "augstore"
      )
    )
  }
}

import MakeTest<StoreLoadTest>
