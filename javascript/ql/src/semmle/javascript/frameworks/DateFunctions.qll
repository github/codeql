private import javascript

private API::Node formatFunction() {
  result = API::moduleImport(["date-fns", "date-fns/utc"]).getMember(["format", "lightFormat"])
  or
  result =
    API::moduleImport(["date-fns/format", "date-fns/lightFormat", "date-fns/utc/format",
          "date-fns/utc/lightFormat"])
}

private API::Node formatFunctionCurried() {
  result =
    API::moduleImport(["date-fns/fp", "date-fns/fp/utc"]).getMember(["format", "lightFormat"])
  or
  result =
    API::moduleImport(["date-fns/fp/format", "date-fns/fp/lightFormat", "date-fns/fp/utc/format",
          "date-fns/fp/utc/lightFormat"])
}

/**
 * Taint step of form: `f -> format(date, f)`
 *
 * A format string can use single-quotes to include mostly arbitrary text.
 */
private class DateFnsFormatStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  DateFnsFormatStep() { this = formatFunction().getACall() }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getArgument(1) and
    succ = this
  }
}

/**
 * Taint step of form: `f -> format(f)(date)`
 */
private class DateFnsCurriedFormatStep extends TaintTracking::AdditionalTaintStep,
  DataFlow::CallNode {
  DateFnsCurriedFormatStep() { this = formatFunctionCurried().getACall() }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getArgument(0) and
    succ = getACall()
  }
}

/**
 * Taint step of form: `f -> momentObj.format(f)`
 *
 * The format string can use backslash-escaping to include mostly arbitrary text.
 */
private class MomentFormatStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  MomentFormatStep() {
    this = API::moduleImport("moment").getASuccessor*().getMember("format").getACall()
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getArgument(0) and
    succ = this
  }
}
