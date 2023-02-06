import go

class BytesReadFrom extends TaintTracking::FunctionModel, Method {
  BytesReadFrom() { this.hasQualifiedName("bytes", "Buffer", "ReadFrom") }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(0) and outp.isReceiver()
  }
}

class ReaderReset extends TaintTracking::FunctionModel, Method {
  ReaderReset() { this.hasQualifiedName("bufio", "Reader", "Reset") }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(0) and outp.isReceiver()
  }
}

from TaintTracking::FunctionModel fn, DataFlow::Node pred, DataFlow::Node succ
where fn.taintStep(pred, succ)
select fn, pred, succ
