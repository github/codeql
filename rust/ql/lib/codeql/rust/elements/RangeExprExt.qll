/**
 * This module provides sub classes of the `RangeExpr` class.
 */

private import rust

/**
 * A range-from expression. For example:
 * ```rust
 * let x = 10..;
 * ```
 */
final class RangeFromExpr extends RangeExpr {
  RangeFromExpr() {
    this.getOperatorName() = ".." and
    this.hasStart() and
    not this.hasEnd()
  }
}

/**
 * A range-to expression. For example:
 * ```rust
 * let x = ..10;
 * ```
 */
final class RangeToExpr extends RangeExpr {
  RangeToExpr() {
    this.getOperatorName() = ".." and
    not this.hasStart() and
    this.hasEnd()
  }
}

/**
 * A range-from-to expression. For example:
 * ```rust
 * let x = 10..20;
 * ```
 */
final class RangeFromToExpr extends RangeExpr {
  RangeFromToExpr() {
    this.getOperatorName() = ".." and
    this.hasStart() and
    this.hasEnd()
  }
}

/**
 * A range-full expression. For example:
 * ```rust
 * let x = ..;
 * ```
 */
final class RangeFullExpr extends RangeExpr {
  RangeFullExpr() {
    this.getOperatorName() = ".." and
    not this.hasStart() and
    not this.hasEnd()
  }
}

/**
 * A range-inclusive expression. For example:
 * ```rust
 * let x = 1..=10;
 * ```
 */
final class RangeInclusiveExpr extends RangeExpr {
  RangeInclusiveExpr() {
    this.getOperatorName() = "..=" and
    this.hasStart() and
    this.hasEnd()
  }
}

/**
 * A range-to-inclusive expression. For example:
 * ```rust
 * let x = ..=10;
 * ```
 */
final class RangeToInclusiveExpr extends RangeExpr {
  RangeToInclusiveExpr() {
    this.getOperatorName() = "..=" and
    not this.hasStart() and
    this.hasEnd()
  }
}
