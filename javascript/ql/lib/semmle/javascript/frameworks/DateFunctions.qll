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
  private class FormatStep extends TaintTracking::SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = formatFunction().getACall() and
        pred = call.getArgument(1) and
        succ = call
      )
    }
  }

  /**
   * Taint step of form: `f -> format(f)(date)`
   */
  private class CurriedFormatStep extends TaintTracking::SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = curriedFormatFunction().getACall() and
        pred = call.getArgument(0) and
        succ = call.getACall()
      )
    }
  }
}

/**
 * Provides classes and predicates modeling the `@date-io` libraries.
 */
private module DateIO {
  private class FormatStep extends TaintTracking::SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(API::CallNode formatCall |
        formatCall =
          API::moduleImport("@date-io/" +
              ["date-fns", "moment", "luxon", "dayjs", "date-fns-jalali", "jalaali", "hijri"])
              .getInstance()
              // the `format` function only select between a predefined list of formats, but the `formatByString` function formats using any string.
              .getMember(["formatByString", "formatNumber"])
              .getACall()
      |
        pred = formatCall.getArgument(1) and
        succ = formatCall
      )
    }
  }

  /** Gets a method name from an `@date-io` adapter that returns an instance of the adapted library. */
  private string getAnAdapterMethodName() {
    result =
      [
        "addSeconds", "addMinutes", "addHours", "addDays", "addWeeks", "addMonths", "endOfDay",
        "setHours", "setMinutes", "setSeconds", "startOfMonth", "endOfMonth", "startOfWeek",
        "endOfWeek", "setYear", "date", "parse", "setMonth", "getNextMonth", "getPreviousMonth"
      ]
  }

  /**
   * Gets an instance of `library` that has been created by an `@date-io` adapter.
   * Library is one of: "moment", "luxon", or "dayjs".
   */
  API::Node getAnAdaptedInstance(string library) {
    exists(API::Node adapter |
      library = "moment" and
      adapter = API::moduleImport("@date-io/moment")
      or
      library = "luxon" and
      adapter = API::moduleImport("@date-io/luxon")
      or
      library = "dayjs" and
      adapter = API::moduleImport("@date-io/dayjs")
    |
      result = adapter.getInstance().getMember(getAnAdapterMethodName()).getReturn()
    )
  }
}

/**
 * Provides classes and predicates modeling the `luxon` library.
 */
private module Luxon {
  /**
   * Gets a reference to a `DateTime` object from the `luxon` library.
   */
  private API::Node luxonDateTime() {
    exists(API::Node constructor | constructor = API::moduleImport("luxon").getMember("DateTime") |
      result = constructor.getInstance()
      or
      result =
        constructor
            .getMember([
                "fromJSDate", "fromJSDate", "fromISO", "now", "fromMillis", "fromHTTP",
                "fromObject", "fromRFC2822", "fromSeconds", "fromSQL", "fromFormat", "fromString",
                "invalid", "local", "utc"
              ])
            .getReturn()
      or
      // fluent API that return immutable objects
      result = luxonDateTime().getAMember()
      or
      result = luxonDateTime().getReturn()
      or
      result = DateIO::getAnAdaptedInstance("luxon")
    )
  }

  /**
   * A step of the form: `f -> luxonDateTime.toFormat(f)`.
   */
  private class ToFormatStep extends TaintTracking::SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(API::CallNode call | call = luxonDateTime().getMember("toFormat").getACall() |
        pred = call.getArgument(0) and succ = call
      )
    }
  }
}

private module Moment {
  /** Gets a reference to a `moment` object. */
  private API::Node moment() {
    result = API::moduleImport(["moment", "moment-timezone"])
    or
    // `dayjs` largely has a similar API to `moment`
    result = API::moduleImport("dayjs")
    or
    result = moment().getReturn()
    or
    result = moment().getAMember()
    or
    result = DateIO::getAnAdaptedInstance(["moment", "dayjs"])
  }

  /**
   * Taint step of form: `f -> momentObj.format(f)`
   *
   * The format string can use backslash-escaping to include mostly arbitrary text.
   */
  private class MomentFormatStep extends TaintTracking::SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = moment().getMember("format").getACall() and
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }
}

private module DateFormat {
  /**
   * Taint step of form: `x -> dateformat(..., x)`
   *
   * The format string can use single-quotes to include mostly arbitrary text.
   */
  private class DateFormatStep extends TaintTracking::SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::moduleImport("dateformat").getACall() and
        pred = call.getArgument(1) and
        succ = call
      )
    }
  }
}
