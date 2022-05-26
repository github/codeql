/**
 * A test query that verifies assertions about the API graph embedded in source-code comments.
 *
 * An assertion is a comment of the form `def=<path>` or `use=<path>`, and asserts that
 * there is a def/use feature reachable from the root along the given path, and its
 * associated data-flow node must start on the same line as the comment.
 *
 * We also support negative assertions of the form `MISSING: def <path>` or `MISSING: use <path>`, which assert
 * that there _isn't_ a node with the given path on the same line.
 *
 * The query only produces output for failed assertions, meaning that it should have no output
 * under normal circumstances.
 *
 * The syntax is made to look exactly like inline expectation tests, so that the tests
 * can remain consistent with other Python tests.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

private DataFlow::Node getNode(API::Node nd, string kind) {
  kind = "def" and
  result = nd.getARhs()
  or
  kind = "use" and
  result = nd.getAUse()
}

private string getLocStr(Location loc) {
  exists(string filepath, int startline |
    loc.hasLocationInfo(filepath, startline, _, _, _) and
    result = filepath + ":" + startline
  )
}

/**
 * An assertion matching a data-flow node against an API-graph feature.
 */
class Assertion extends Comment {
  string expectedKind;
  string expectedLoc;
  string path;
  string polarity;

  Assertion() {
    exists(string txt, string rex |
      txt = this.getText().trim() and
      rex = "#\\$.*?((?:MISSING: )?)(def|use)=([\\w\\(\\)\"\\.]*).*"
    |
      polarity = txt.regexpCapture(rex, 1) and
      expectedKind = txt.regexpCapture(rex, 2) and
      path = txt.regexpCapture(rex, 3) and
      expectedLoc = getLocStr(this.getLocation())
    )
  }

  string getEdgeLabel(int i) {
    // matches a single edge. E.g. `getParameter(1)` or `getMember("foo")`.
    // The lookbehind/lookahead ensure that the boundary is correct, that is
    // either the edge is next to a ".", or it's the end of the string.
    result = path.regexpFind("(?<=\\.|^)([\\w\\(\\)\"]+)(?=\\.|$)", i, _).trim()
  }

  int getPathLength() { result = max(int i | exists(this.getEdgeLabel(i))) + 1 }

  predicate isNegative() { polarity = "MISSING: " }

  API::Node lookup(int i) {
    i = 0 and
    result = API::root()
    or
    result =
      this.lookup(i - 1)
          .getASuccessor(any(API::Label::ApiLabel label |
              label.toString() = this.getEdgeLabel(i - 1)
            ))
  }

  API::Node lookup() { result = this.lookup(this.getPathLength()) }

  predicate holds() { getLocStr(getNode(this.lookup(), expectedKind).getLocation()) = expectedLoc }

  string tryExplainFailure() {
    exists(int i, API::Node nd, string prefix, string suffix |
      nd = this.lookup(i) and
      i < getPathLength() and
      not exists(this.lookup([i + 1 .. getPathLength()])) and
      prefix = nd + " has no outgoing edge labelled " + this.getEdgeLabel(i) + ";" and
      if exists(nd.getASuccessor())
      then
        suffix =
          "it does have outgoing edges labelled " +
            concat(string lbl |
              exists(nd.getASuccessor(any(API::Label::ApiLabel label | label.toString() = lbl)))
            |
              lbl, ", "
            ) + "."
      else suffix = "it has no outgoing edges at all."
    |
      result = prefix + " " + suffix
    )
    or
    exists(API::Node nd, string kind | nd = this.lookup() |
      exists(getNode(nd, kind)) and
      not exists(getNode(nd, expectedKind)) and
      result = "Expected " + expectedKind + " node, but found " + kind + " node."
    )
    or
    exists(DataFlow::Node nd | nd = getNode(this.lookup(), expectedKind) |
      not getLocStr(nd.getLocation()) = expectedLoc and
      result =
        "Node not found on this line (but there is one on line " + min(getLocStr(nd.getLocation())) +
          ")."
    )
  }

  string explainFailure() {
    if this.isNegative()
    then (
      this.holds() and
      result = "Negative assertion failed."
    ) else (
      not this.holds() and
      (
        result = this.tryExplainFailure()
        or
        not exists(this.tryExplainFailure()) and
        result = "Positive assertion failed for unknown reasons."
      )
    )
  }
}

query predicate failed(Assertion a, string explanation) { explanation = a.explainFailure() }
