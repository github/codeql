import python

/*
 * When this library is imported, the 'hasLocationInfo' predicate of
 * Functions and is overridden to specify their entire range
 * instead of just the range of their name. The latter can still be
 * obtained by invoking the getLocation() predicate.
 *
 * The full ranges are required for the purpose of associating an alert
 * with an individual Function as opposed to a whole File.
 */

/**
 * A Function whose 'hasLocationInfo' is overridden to specify its entire range
 * including the body (if any), as opposed to the location of its name only.
 */
class RangeFunction extends Function {
    predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
        super.getLocation().hasLocationInfo(path, sl, sc, _, _) and
        this.getBody().getLastItem().getLocation().hasLocationInfo(path, _, _, el, ec)
    }
}

/**
 * A Class whose 'hasLocationInfo' is overridden to specify its entire range
 * including the body (if any), as opposed to the location of its name only.
 */
class RangeClass extends Class {
    predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
        super.getLocation().hasLocationInfo(path, sl, sc, _, _) and
        this.getBody().getLastItem().getLocation().hasLocationInfo(path, _, _, el, ec)
    }
}
