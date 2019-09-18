private newtype TOverlap =
  TMayPartiallyOverlap() or
  TMustTotallyOverlap() or
  TMustExactlyOverlap()

abstract class Overlap extends TOverlap {
  abstract string toString();
}

class MayPartiallyOverlap extends Overlap, TMayPartiallyOverlap {
  final override string toString() { result = "MayPartiallyOverlap" }
}

class MustTotallyOverlap extends Overlap, TMustTotallyOverlap {
  final override string toString() { result = "MustTotallyOverlap" }
}

class MustExactlyOverlap extends Overlap, TMustExactlyOverlap {
  final override string toString() { result = "MustExactlyOverlap" }
}
