import python

class RecordedCall extends XMLElement {
  RecordedCall() { this.hasName("recorded_call") }

  string call_filename() { result = this.getAttributeValue("call_filename") }

  int call_linenum() { result = this.getAttributeValue("call_linenum").toInt() }

  int call_inst_index() { result = this.getAttributeValue("call_inst_index").toInt() }

  Call getCall() {
    // TODO: handle calls spanning multiple lines
    result.getLocation().hasLocationInfo(this.call_filename(), this.call_linenum(), _, _, _)
  }

  string callee_filename() { result = this.getAttributeValue("callee_filename") }

  int callee_linenum() { result = this.getAttributeValue("callee_linenum").toInt() }

  string callee_funcname() { result = this.getAttributeValue("callee_funcname") }

  Function getCallee() {
    result.getLocation().hasLocationInfo(this.callee_filename(), this.callee_linenum(), _, _, _)
  }
}

/**
 * Class of recorded calls where we can uniquely identify both the `call` and the `callee`.
 */
class ValidRecordedCall extends RecordedCall {
  ValidRecordedCall() {
    strictcount(this.getCall()) = 1 and
    strictcount(this.getCallee()) = 1
  }
}
