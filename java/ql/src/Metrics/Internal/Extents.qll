/**
 * Provides classes that modify the default location information
 * of `RefType`s and `Callable`s to cover their full extent.
 *
 * When this library is imported, the `hasLocationInfo` predicate of
 * `Callable` and `RefTypes` is overridden to specify their entire range
 * instead of just the range of their name. The latter can still be
 * obtained by invoking the `getLocation()` predicate.
 *
 * The full ranges may be used to determine whether a given location
 * (for example, the location of an alert) is contained within the extent
 * of a `Callable` or `RefType`.
 */

import java

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
        this.lastParameter().hasLocationInfo(path, _, _, el, ec)
        or
        not exists(this.getAParameter()) and el = elSuper and ec = ecSuper
      )
    )
  }

  private Parameter lastParameter() {
    result = this.getAParameter() and
    not this.getAParameter().getPosition() > result.getPosition()
  }
}

/**
 * A `RefType` whose `hasLocationInfo` is overridden to specify its entire range
 * including the range of its members (if any), as opposed to the location of its name only.
 */
class RangeRefType extends RefType {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(int elSuper, int ecSuper | super.hasLocationInfo(path, sl, sc, elSuper, ecSuper) |
      this.lastMember().hasLocationInfo(path, _, _, el, ec)
      or
      not exists(this.getAMember()) and el = elSuper and ec = ecSuper
    )
  }

  private Member lastMember() {
    result =
      max(this.getAMember() as m
        order by
          m.getLocation().getStartLine(), m.getLocation().getStartColumn()
      )
  }
}
