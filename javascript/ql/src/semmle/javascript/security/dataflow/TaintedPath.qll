/**
 * Provides a taint tracking configuration for reasoning about
 * tainted-path vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `TaintedPath::Configuration` is needed, otherwise
 * `TaintedPathCustomizations` should be imported instead.
 */

import javascript

module TaintedPath {
  import TaintedPathCustomizations::TaintedPath

  /**
   * A taint-tracking configuration for reasoning about tainted-path vulnerabilities.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "TaintedPath" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      label = source.(Source).getAFlowLabel()
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      label = sink.(Sink).getAFlowLabel()
    }

    override predicate isBarrier(DataFlow::Node node) {
      super.isBarrier(node) or
      node instanceof Sanitizer
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      guard instanceof StartsWithDotDotSanitizer or
      guard instanceof StartsWithDirSanitizer or
      guard instanceof IsAbsoluteSanitizer or
      guard instanceof ContainsDotDotSanitizer
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
      isTaintedPathStep(src, dst, srclabel, dstlabel)
      or
      // Ignore all preliminary sanitization after decoding URI components
      srclabel instanceof Label::PosixPath and
      dstlabel instanceof Label::PosixPath and
      (
        any(UriLibraryStep step).step(src, dst)
        or
        exists(DataFlow::CallNode decode |
          decode.getCalleeName() = "decodeURIComponent" or decode.getCalleeName() = "decodeURI"
        |
          src = decode.getArgument(0) and
          dst = decode
        )
      )
      or
      promiseTaintStep(src, dst) and srclabel = dstlabel
      or
      any(TaintTracking::PersistentStorageTaintStep st).step(src, dst) and srclabel = dstlabel
      or
      exists(DataFlow::PropRead read | read = dst |
        src = read.getBase() and
        read.getPropertyName() != "length" and
        srclabel = dstlabel
      )
    }

    /**
     * Holds if we should include a step from `src -> dst` with labels `srclabel -> dstlabel`, and the
     * standard taint step `src -> dst` should be suppresesd.
     */
    predicate isTaintedPathStep(
      DataFlow::Node src, DataFlow::Node dst, Label::PosixPath srclabel, Label::PosixPath dstlabel
    ) {
      // path.normalize() and similar
      exists(NormalizingPathCall call |
        src = call.getInput() and
        dst = call.getOutput() and
        dstlabel = srclabel.toNormalized()
      )
      or
      // path.resolve() and similar
      exists(ResolvingPathCall call |
        src = call.getInput() and
        dst = call.getOutput() and
        dstlabel.isAbsolute() and
        dstlabel.isNormalized()
      )
      or
      // path.relative() and similar
      exists(NormalizingRelativePathCall call |
        src = call.getInput() and
        dst = call.getOutput() and
        dstlabel.isRelative() and
        dstlabel.isNormalized()
      )
      or
      // path.dirname() and similar
      exists(PreservingPathCall call |
        src = call.getInput() and
        dst = call.getOutput() and
        srclabel = dstlabel
      )
      or
      // path.join()
      exists(DataFlow::CallNode join, int n |
        join = DataFlow::moduleMember("path", "join").getACall()
      |
        src = join.getArgument(n) and
        dst = join and
        (
          // If the initial argument is tainted, just normalize it. It can be relative or absolute.
          n = 0 and
          dstlabel = srclabel.toNormalized()
          or
          // For later arguments, the flow label depends on whether the first argument is absolute or relative.
          // If in doubt, we assume it is absolute.
          n > 0 and
          srclabel.canContainDotDotSlash() and
          dstlabel.isNormalized() and
          if isRelative(join.getArgument(0).getStringValue())
          then dstlabel.isRelative()
          else dstlabel.isAbsolute()
        )
      )
      or
      // String concatenation - behaves like path.join() except without normalization
      exists(DataFlow::Node operator, int n |
        StringConcatenation::taintStep(src, dst, operator, n)
      |
        // use ordinary taint flow for the first operand
        n = 0 and
        srclabel = dstlabel
        or
        n > 0 and
        srclabel.canContainDotDotSlash() and
        dstlabel.isNonNormalized() and // The ../ is no longer at the beginning of the string.
        (
          if isRelative(StringConcatenation::getOperand(operator, 0).getStringValue())
          then dstlabel.isRelative()
          else dstlabel.isAbsolute()
        )
      )
    }
  }
}
