private import codeql.swift.generated.AvailabilityInfo

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An availability condition of an `if`, `while`, or `guard` statements.
   *
   * Examples:
   * ```
   * if #available(iOS 12, *) {
   *   // Runs on iOS 12 and above
   * } else {
   *   // Runs only anything below iOS 12
   * }
   * if #unavailable(macOS 10.14, *) {
   *   // Runs only on macOS 10 and below
   * }
   * ```
   */
  class AvailabilityInfo extends Generated::AvailabilityInfo {
    override string toString() {
      result = "#available" and not this.isUnavailable()
      or
      result = "#unavailable" and this.isUnavailable()
    }
  }
}
