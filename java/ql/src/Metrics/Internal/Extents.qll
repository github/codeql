import java

/*
 * When this library is imported, the `hasLocationInfo` predicate of
 * `Callable` and `RefTypes` is overridden to specify their entire range
 * instead of just the range of their name. The latter can still be
 * obtained by invoking the `getLocation()` predicate.
 *
 * The full ranges are required for the purpose of associating a violation
 * with an individual `Callable` or `RefType` as opposed to a whole `File`.
 */

/**
 * A Callable whose `hasLocationInfo` is overridden to specify its entire range
 * including the body (if any), as opposed to the location of its name only.
 */
class RangeCallable extends Callable {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(int elSuper, int ecSuper | super.hasLocationInfo(path, sl, sc, elSuper, ecSuper) |
      this.getBody().hasLocationInfo(path, _, _, el, ec)
      or
      not exists(this.getBody()) and
      (
        lastParameter().hasLocationInfo(path, _, _, el, ec)
        or
        not exists(this.getAParameter()) and el = elSuper and ec = ecSuper
      )
    )
  }

  private Parameter lastParameter() {
    result = getAParameter() and
    not getAParameter().getPosition() > result.getPosition()
  }
}

/**
 * A `RefType` whose `hasLocationInfo` is overridden to specify its entire range
 * including the range of its members (if any), as opposed to the location of its name only.
 */
class RangeRefType extends RefType {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(int elSuper, int ecSuper | super.hasLocationInfo(path, sl, sc, elSuper, ecSuper) |
      lastMember().hasLocationInfo(path, _, _, el, ec)
      or
      not exists(this.getAMember()) and el = elSuper and ec = ecSuper
    )
  }

  private Member lastMember() {
    exists(Member m, int i |
      result = m and
      m = getAMember() and
      i = rankOfMember(m) and
      not exists(Member other | other = getAMember() and rankOfMember(other) > i)
    )
  }

  private int rankOfMember(Member m) {
    this.getAMember() = m and
    exists(Location mLoc, File f, int maxCol | mLoc = m.getLocation() |
      f = mLoc.getFile() and
      maxCol = max(Location loc | loc.getFile() = f | loc.getStartColumn()) and
      result = mLoc.getStartLine() * maxCol + mLoc.getStartColumn()
    )
  }
}
