import python

/**
 * A Version of the Python interpreter.
 * Currently only 2.7 or 3.x but may include different sets of versions in the future.
 */
class Version extends int {
  Version() { this = 2 or this = 3 }

  /** Holds if this version (or set of versions) includes the version `major`.`minor` */
  predicate includes(int major, int minor) {
    this = 2 and major = 2 and minor = 7
    or
    this = 3 and major = 3 and minor in [4 .. 8]
  }
}
