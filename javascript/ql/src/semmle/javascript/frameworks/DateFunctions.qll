/** Provides taint steps modeling flow through date-manipulation libraries. */

private import javascript

private module DateFns {
  private API::Node formatFunction() {
    result = API::moduleImport(["date-fns", "date-fns/esm"]).getMember(["format", "lightFormat"])
    or
    result =
      API::moduleImport([
          "date-fns/format", "date-fns/lightFormat", "date-fns/esm/format",
          "date-fns/esm/lightFormat"
        ])
  }

  private API::Node curriedFormatFunction() {
    result =
      API::moduleImport(["date-fns/fp", "date-fns/esm/fp"]).getMember(["format", "lightFormat"])
    or
    result =
      API::moduleImport([
          "date-fns/fp/format", "date-fns/fp/lightFormat", "date-fns/esm/fp/format",
          "date-fns/esm/fp/lightFormat"
        ])
  }

  /**
   * Taint step of form: `f -> format(date, f)`
   *
   * A format string can use single-quotes to include mostly arbitrary text.
   */
  private class FormatStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    FormatStep() { this = formatFunction().getACall() }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(1) and
      succ = this
    }
  }

  /**
   * Taint step of form: `f -> format(f)(date)`
   */
  private class CurriedFormatStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    CurriedFormatStep() { this = curriedFormatFunction().getACall() }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(0) and
      succ = getACall()
    }
  }
}

private module Moment {
  /** Gets a reference to a `moment` object. */
  private API::Node moment() {
    result = API::moduleImport(["moment", "moment-timezone"])
    or
    result = moment().getReturn()
    or
    result = moment().getAMember()
  }

  /**
   * Taint step of form: `f -> momentObj.format(f)`
   *
   * The format string can use backslash-escaping to include mostly arbitrary text.
   */
  private class MomentFormatStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    MomentFormatStep() { this = moment().getMember("format").getACall() }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(0) and
      succ = this
    }
  }
}

private module DateFormat {
  /**
   * Taint step of form: `x -> dateformat(..., x)`
   *
   * The format string can use single-quotes to include mostly arbitrary text.
   */
  private class DateFormatStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    DateFormatStep() { this = DataFlow::moduleImport("dateformat").getACall() }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(1) and
      succ = this
    }
  }
}
