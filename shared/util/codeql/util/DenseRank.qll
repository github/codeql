/**
 * Provides modules for computing dense `rank`s. See the `DenseRank` module
 * below for a more detailed explanation.
 */
overlay[local?]
module;

/** Provides the input to `DenseRank`. */
signature module DenseRankInputSig {
  /** An element that is ranked. */
  bindingset[this]
  class Ranked;

  /** Gets the rank of `r`. */
  int getRank(Ranked r);
}

/**
 * Provides the `denseRank` predicate for computing dense `rank`s. For example,
 * if we have
 *
 * ```ql
 * query predicate names(string name) {
 *   name = ["Alice", "Bob", "Charles", "Charlie", "David"]
 * }
 *
 * int rankByFirstLetter(string name) {
 *   name = rank[result](string n | names(n) | n order by n.charAt(0))
 * }
 * ```
 *
 * then `rankByFirstLetter` computes the following relation
 *
 * ```
 * Alice    1
 * Bob      2
 * Charles  3
 * Charlie  3
 * David    5
 * ```
 *
 * Note that `"David"` has rank 5 instead of 4. If we want a dense ranking instead,
 * we can do
 *
 * ```ql
 * module M implements DenseRankInputSig {
 *   class Ranked = string;
 *
 *   predicate getRank = rankByFirstLetter/1;
 * }
 *
 * predicate denseRank = DenseRank<M>::denseRank/1;
 * ```
 */
module DenseRank<DenseRankInputSig Input> {
  private import Input

  private int getARank() { result = getRank(_) }

  pragma[noinline]
  private int getARankGap() { result = getARank() and not result - 1 = getARank() }

  pragma[noinline]
  private predicate isDenseFrom(int i) { i = unique( | | getARankGap()) }

  pragma[noinline]
  private int getRankNeedsDenseRank(Ranked r) { result = getRank(r) and not isDenseFrom(_) }

  private int rankRank(Ranked r, int rnk) {
    rnk = getRankNeedsDenseRank(r) and
    rnk = rank[result](int rnk0 | rnk0 = getRankNeedsDenseRank(_) | rnk0)
  }

  /** Gets the `Ranked` value for which the dense rank is `rnk`. */
  pragma[nomagic]
  Ranked denseRank(int rnk) {
    rnk = rankRank(result, getRankNeedsDenseRank(result))
    or
    exists(int i, int offset |
      isDenseFrom(i) and
      offset = i - 1 and
      rnk = getRank(result) - offset
    )
  }
}

/** Provides the input to `DenseRank1`. */
signature module DenseRankInputSig1 {
  /** A ranking context. */
  bindingset[this]
  class C;

  /** An element that is ranked. */
  bindingset[this]
  class Ranked;

  /** Gets the rank of `r` in the context provided by `c`. */
  int getRank(C c, Ranked r);
}

/** Same as `DenseRank`, but allows for a context consisting of one element. */
module DenseRank1<DenseRankInputSig1 Input> {
  private import Input

  private int getARank(C c) { result = getRank(c, _) }

  pragma[noinline]
  private int getARankGap(C c) { result = getARank(c) and not result - 1 = getARank(c) }

  pragma[noinline]
  private predicate isDenseFrom(C c, int i) { i = unique( | | getARankGap(c)) }

  pragma[noinline]
  private int getRankNeedsDenseRank(C c, Ranked r) {
    result = getRank(c, r) and not isDenseFrom(c, _)
  }

  private int rankRank(C c, Ranked r, int rnk) {
    rnk = getRankNeedsDenseRank(c, r) and
    rnk = rank[result](int rnk0 | rnk0 = getRankNeedsDenseRank(c, _) | rnk0)
  }

  /**
   * Gets the `Ranked` value for which the dense rank in the context provided by
   * `c` is `rnk`.
   */
  pragma[nomagic]
  Ranked denseRank(C c, int rnk) {
    rnk = rankRank(c, result, getRankNeedsDenseRank(c, result))
    or
    exists(int i, int offset |
      isDenseFrom(c, i) and
      offset = i - 1 and
      rnk = getRank(c, result) - offset
    )
  }
}

/** Provides the input to `DenseRank2`. */
signature module DenseRankInputSig2 {
  /** A ranking context. */
  bindingset[this]
  class C1;

  /** A ranking context. */
  bindingset[this]
  class C2;

  /** An element that is ranked. */
  bindingset[this]
  class Ranked;

  /** Gets the rank of `r` in the context provided by `c1` and `c2`. */
  int getRank(C1 c1, C2 c2, Ranked r);
}

/** Same as `DenseRank`, but allows for a context consisting of two elements. */
module DenseRank2<DenseRankInputSig2 Input> {
  private import Input

  private int getARank(C1 c1, C2 c2) { result = getRank(c1, c2, _) }

  pragma[noinline]
  private int getARankGap(C1 c1, C2 c2) {
    result = getARank(c1, c2) and not result - 1 = getARank(c1, c2)
  }

  pragma[noinline]
  private predicate isDenseFrom(C1 c1, C2 c2, int i) { i = unique( | | getARankGap(c1, c2)) }

  pragma[noinline]
  private int getRankNeedsDenseRank(C1 c1, C2 c2, Ranked r) {
    result = getRank(c1, c2, r) and not isDenseFrom(c1, c2, _)
  }

  private int rankRank(C1 c1, C2 c2, Ranked r, int rnk) {
    rnk = getRankNeedsDenseRank(c1, c2, r) and
    rnk = rank[result](int rnk0 | rnk0 = getRankNeedsDenseRank(c1, c2, _) | rnk0)
  }

  /**
   * Gets the `Ranked` value for which the dense rank in the context provided by
   * `c1` and `c2` is `rnk`.
   */
  pragma[nomagic]
  Ranked denseRank(C1 c1, C2 c2, int rnk) {
    rnk = rankRank(c1, c2, result, getRankNeedsDenseRank(c1, c2, result))
    or
    exists(int i, int offset |
      isDenseFrom(c1, c2, i) and
      offset = i - 1 and
      rnk = getRank(c1, c2, result) - offset
    )
  }
}
