/**
 * INTERNAL: This module may be replaced without notice.
 *
 * Provides a module to create first-class representations of sets of values.
 */

/** The input signature for `MakeSets`. */
signature module MkSetsInputSig {
  class Key;

  class Value;

  Value getAValue(Key k);

  int totalorder(Value v);
}

/**
 * Given a binary predicate `getAValue`, this module groups the `Value` column
 * by `Key` and constructs the corresponding sets of `Value`s as single entities.
 *
 * The output is a functional predicate, `getValueSet`, such that
 * `getValueSet(k).contains(v)` is equivalent to `v = getAValue(k)`, and a
 * class, `ValueSet`, that canonically represents a set of `Value`s. In
 * particular, if two keys `k1` and `k2` relate to the same set of values, then
 * `getValueSet(k1) = getValueSet(k2)`.
 *
 * If the given `totalorder` is not a total order, then the keys for which we
 * cannot order the values cannot be given a canonical representation, and
 * instead the key is simply reused as the set representation. This provides a
 * reasonable fallback where `getValueSet(k).contains(v)` remains equivalent to
 * `v = getAValue(k)`.
 */
module MakeSets<MkSetsInputSig Inp> {
  private import Inp

  module Sets = QlBuiltins::InternSets<Key, Value, getAValue/1>;

  class ValueSet extends Sets::Set {
    string toString() {
      result = "ValueSet"
    }
  }

  predicate getValueSet = Sets::getSet/1;
}
