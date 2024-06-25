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

  private int totalorderExt(Value v) {
    result = 0 and v = getAValue(_) and not exists(totalorder(v))
    or
    result = totalorder(v)
  }

  private predicate rankedValue(Key k, Value v, int r) {
    v = rank[r](Value v0 | v0 = getAValue(k) | v0 order by totalorderExt(v0))
  }

  private predicate unordered(Key k) {
    strictcount(int r | rankedValue(k, _, r)) != strictcount(getAValue(k))
  }

  private int maxRank(Key k) { result = max(int r | rankedValue(k, _, r)) and not unordered(k) }

  private newtype TValList =
    TValListNil() or
    TValListCons(Value head, int r, TValList tail) { hasValListCons(_, head, r, tail) } or
    TValListUnordered(Key k) { unordered(k) }

  private predicate hasValListCons(Key k, Value head, int r, TValList tail) {
    rankedValue(k, head, r) and
    hasValList(k, r - 1, tail)
  }

  private predicate hasValList(Key k, int r, TValList l) {
    exists(getAValue(k)) and r = 0 and l = TValListNil()
    or
    exists(Value head, TValList tail |
      l = TValListCons(head, r, tail) and
      hasValListCons(k, head, r, tail)
    )
  }

  private predicate hasValueSet(Key k, TValList vs) {
    hasValList(k, maxRank(k), vs) or vs = TValListUnordered(k)
  }

  /** A set of `Value`s. */
  class ValueSet extends TValList {
    ValueSet() { hasValueSet(_, this) }

    string toString() {
      this instanceof TValListCons and result = "ValueSet"
      or
      this instanceof TValListUnordered and result = "ValueSetUnordered"
    }

    private predicate sublist(TValListCons l) {
      this = l or
      this.sublist(TValListCons(_, _, l))
    }

    /** Holds if this set contains `v`. */
    predicate contains(Value v) {
      this.sublist(TValListCons(v, _, _))
      or
      exists(Key k | this = TValListUnordered(k) and v = getAValue(k))
    }
  }

  /**
   * Gets the set of values such that `getValueSet(k).contains(v)` is equivalent
   * to `v = getAValue(k)`.
   */
  ValueSet getValueSet(Key k) { hasValueSet(k, result) }
}
