/**
 * Provides utility predicates for working with flow summary specifications.
 */

import javascript

/**
 * Holds if `config` matches `spec`, that is, either `spec` is the ID of `config`
 * or `spec` is the empty string and `config` is an arbitrary configuration.
 */
predicate configSpec(DataFlow::Configuration config, string spec) {
  config.getId() = spec
  or
  spec = ""
}

/**
 * Holds if `lbl` matches `spec`, that is, either `spec` is the name of `config`
 * or `spec` is the empty string and `lbl` is the built-in flow label `data`.
 */
predicate sourceFlowLabelSpec(DataFlow::FlowLabel lbl, string spec) {
  lbl.toString() = spec
  or
  spec = "" and
  lbl.isData()
}

/**
 * Holds if `lbl` matches `spec`, that is, either `spec` is the name of `config`
 * or `spec` is the empty string and `lbl` is an arbitrary standard flow label.
 */
predicate sinkFlowLabelSpec(DataFlow::FlowLabel lbl, string spec) {
  lbl.toString() = spec
  or
  spec = "" and
  lbl.isDataOrTaint()
}

/**
 * A comment that annotates data flow nodes as sources/sinks.
 *
 * Such a comment starts with "Semmle:", possibly preceded by whitespace, and
 * may contain specifications of the form "source: label,config" and "sink: label, config"
 * where again whitespace is not significant and the ",config" part may be missing.
 *
 * It applies to any data flow node that ends on the line where the comment starts,
 * and annotates the node as being a source/sink with the given flow label(s) for
 * the given configuration (or any configuration if omitted).
 */
class AnnotationComment extends Comment {
  string ann;

  AnnotationComment() { ann = getText().regexpCapture("(?s)\\s*Semmle:(.*)", 1) }

  /**
   * Holds if this comment applies to `nd`, that is, it starts on the same line on
   * which `nd` ends.
   */
  predicate appliesTo(DataFlow::Node nd) {
    exists(string file, int line |
      getLocation().hasLocationInfo(file, line, _, _, _) and
      nd.hasLocationInfo(file, _, _, line, _)
    )
  }

  /**
   * Holds if this comment contains an annotation of the form `source: label, config`
   * or `source: label` (modulo whitespace). In the latter case, `config` may be
   * any configuration.
   */
  predicate specifiesSource(DataFlow::FlowLabel label, DataFlow::Configuration config) {
    exists(string spec |
      spec = ann.regexpFind("(?<=\\bsource:)\\s*[^\\s,]+(\\s*,\\s*[^\\s,])?", _, _) and
      sourceFlowLabelSpec(label, spec.splitAt(",", 0).trim()) and
      configSpec(config, spec.splitAt(",", 1).trim())
    )
  }

  /**
   * Holds if this comment contains an annotation of the form `sink: label, config`
   * or `sink: label` (modulo whitespace). In the latter case, `config` may be
   * any configuration.
   */
  predicate specifiesSink(string label, string config) {
    exists(string spec |
      spec = ann.regexpFind("(?<=\\bsink:)\\s*[^\\s,]+(\\s*,\\s*[^\\s,]+)?", _, _) and
      sinkFlowLabelSpec(label, spec.splitAt(",", 0).trim()) and
      configSpec(config, spec.splitAt(",", 1).trim())
    )
  }
}
