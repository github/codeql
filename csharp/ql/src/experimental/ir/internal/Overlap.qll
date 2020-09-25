private newtype TOverlap =
  TMayPartiallyOverlap() or
  TMustTotallyOverlap() or
  TMustExactlyOverlap()

/**
 * Represents a possible overlap between two memory ranges.
 */
abstract class Overlap extends TOverlap {
  abstract string toString();
}

/**
 * Represents a partial overlap between two memory ranges, which may or may not
 * actually occur in practice.
 */
class MayPartiallyOverlap extends Overlap, TMayPartiallyOverlap {
  final override string toString() { result = "MayPartiallyOverlap" }
}

/**
 * Represents an overlap in which the first memory range is known to include all
 * bits of the second memory range, but may be larger or have a different type.
 */
class MustTotallyOverlap extends Overlap, TMustTotallyOverlap {
  final override string toString() { result = "MustTotallyOverlap" }
}

/**
 * Represents an overlap between two memory ranges that have the same extent and
 * the same type.
 */
class MustExactlyOverlap extends Overlap, TMustExactlyOverlap {
  final override string toString() { result = "MustExactlyOverlap" }
}
