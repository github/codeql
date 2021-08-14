private newtype TOverlap =
  TMayPartiallyOverlap() or
  TMustTotallyOverlap() or
  TMustExactlyOverlap()

/**
 * Represents a possible overlap between two memory ranges.
 */
abstract class Overlap extends TOverlap {
  abstract string toString();

  /**
   * Gets a value representing how precise this overlap is. The higher the value, the more precise
   * the overlap. The precision values are ordered as
   * follows, from most to least precise:
   * `MustExactlyOverlap`
   * `MustTotallyOverlap`
   * `MayPartiallyOverlap`
   */
  abstract int getPrecision();
}

/**
 * Represents a partial overlap between two memory ranges, which may or may not
 * actually occur in practice.
 */
class MayPartiallyOverlap extends Overlap, TMayPartiallyOverlap {
  final override string toString() { result = "MayPartiallyOverlap" }

  final override int getPrecision() { result = 0 }
}

/**
 * Represents an overlap in which the first memory range is known to include all
 * bits of the second memory range, but may be larger or have a different type.
 */
class MustTotallyOverlap extends Overlap, TMustTotallyOverlap {
  final override string toString() { result = "MustTotallyOverlap" }

  final override int getPrecision() { result = 1 }
}

/**
 * Represents an overlap between two memory ranges that have the same extent and
 * the same type.
 */
class MustExactlyOverlap extends Overlap, TMustExactlyOverlap {
  final override string toString() { result = "MustExactlyOverlap" }

  final override int getPrecision() { result = 2 }
}

/**
 * Gets the `Overlap` that best represents the relationship between two memory locations `a` and
 * `c`, where `getOverlap(a, b) = previousOverlap` and `getOverlap(b, c) = newOverlap`, for some
 * intermediate memory location `b`.
 */
Overlap combineOverlap(Overlap previousOverlap, Overlap newOverlap) {
  // Note that it's possible that two less precise overlaps could combine to result in a more
  // precise overlap. For example, both `previousOverlap` and `newOverlap` could be
  // `MustTotallyOverlap` even though the actual relationship between `a` and `c` is
  // `MustExactlyOverlap`. We will still return `MustTotallyOverlap` as the best conservative
  // approximation we can make without additional input information.
  result =
    min(Overlap overlap |
      overlap = [previousOverlap, newOverlap]
    |
      overlap order by overlap.getPrecision()
    )
}
