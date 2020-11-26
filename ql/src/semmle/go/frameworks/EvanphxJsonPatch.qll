/**
 * Provides classes modeling github.com/evanphx/json-patch.
 */

import go

private module EvanphxJsonPatch {
  bindingset[result]
  private string packagePath() { result = package("github.com/evanphx/json-patch", "") }

  private class MergeMergePatches extends TaintTracking::FunctionModel {
    MergeMergePatches() { this.hasQualifiedName(packagePath(), "MergeMergePatches") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      (inp.isParameter(0) or inp.isParameter(1)) and
      outp.isResult(0)
    }
  }

  private class MergePatch extends TaintTracking::FunctionModel {
    MergePatch() { this.hasQualifiedName(packagePath(), "MergePatch") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      (inp.isParameter(0) or inp.isParameter(1)) and
      outp.isResult(0)
    }
  }

  private class CreateMergePatch extends TaintTracking::FunctionModel {
    CreateMergePatch() { this.hasQualifiedName(packagePath(), "CreateMergePatch") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      (inp.isParameter(0) or inp.isParameter(1)) and
      outp.isResult(0)
    }
  }

  private class DecodePatch extends TaintTracking::FunctionModel {
    DecodePatch() { this.hasQualifiedName(packagePath(), "DecodePatch") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and
      outp.isResult(0)
    }
  }

  private class Apply extends TaintTracking::FunctionModel {
    Apply() {
      exists(string fn |
        fn in ["Apply", "ApplyWithOptions", "ApplyIndent", "ApplyIndentWithOptions"]
      |
        this.hasQualifiedName(packagePath(), fn)
      )
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      (inp.isParameter(0) or inp.isReceiver()) and
      outp.isResult(0)
    }
  }
}
