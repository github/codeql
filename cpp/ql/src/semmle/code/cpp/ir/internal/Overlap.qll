private import cpp

private newtype TOverlap =
  TMayPartiallyOverlap() or
  TMustTotallyOverlap() or
  TMustExactlyOverlap()

abstract class Overlap extends TOverlap {
  abstract string toString();
}

class MayPartiallyOverlap extends Overlap, TMayPartiallyOverlap {
  override final string toString() {
    result = "MayPartiallyOverlap"
  }
}

class MustTotallyOverlap extends Overlap, TMustTotallyOverlap {
  override final string toString() {
    result = "MustTotallyOverlap"
  }
}

class MustExactlyOverlap extends Overlap, TMustExactlyOverlap {
  override final string toString() {
    result = "MustExactlyOverlap"
  }
}
