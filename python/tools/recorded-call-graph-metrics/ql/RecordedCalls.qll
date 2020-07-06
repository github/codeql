import python

class RecordedCall extends XMLElement {
    RecordedCall() {
        this.hasName("recorded_call")
    }

    string call_filename() { result = this.getAttributeValue("call_filename") }

    int call_linenum() { result = this.getAttributeValue("call_linenum").toInt() }

    int call_inst_index() { result = this.getAttributeValue("call_inst_index").toInt() }

    Call getCall() {
        // TODO: handle calls spanning multiple lines
        result.getLocation().hasLocationInfo(this.call_filename(), this.call_linenum(), _, _, _)
    }

    string callable_filename() { result = this.getAttributeValue("callable_filename") }

    int callable_linenum() { result = this.getAttributeValue("callable_linenum").toInt() }

    string callable_funcname() { result = this.getAttributeValue("callable_funcname") }

    Function getCallable() {
        result.getLocation().hasLocationInfo(this.callable_filename(), this.callable_linenum(), _, _, _)
    }
}

/**
 * Class of recorded calls where we can uniquely identify both the `call` and the `callable`.
 */
class ValidRecordedCall extends RecordedCall {
    ValidRecordedCall() {
        strictcount(this.getCall()) = 1 and
        strictcount(this.getCallable()) = 1
    }
}
