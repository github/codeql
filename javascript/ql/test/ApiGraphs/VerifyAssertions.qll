/**
 * A test query that verifies assertions about the API graph embedded in source-code comments.
 *
 * An assertion is a comment of the form `def <path>` or `use <path>`, and asserts that
 * there is a def/use feature reachable from the root along the given path (described using
 * s-expression syntax), and its associated data-flow node must start on the same line as the
 * comment.
 *
 * We also support negative assertions of the form `!def <path>` or `!use <path>`, which assert
 * that there _isn't_ a node with the given path on the same line.
 *
 * The query only produces output for failed assertions, meaning that it should have no output
 * under normal circumstances.
 *
 * Note that this query file isn't itself meant to be run as a test; instead, the `.qlref`s
 * referring to it from inside the individual test directories should be run. However, when
 * all tests are run this test will also be run, hence we need to check in a (somewhat nonsensical)
 * `.expected` file for it as well.
 */

import javascript

private DataFlow::Node getNode(API::Node nd, string kind) {
  kind = "def" and
  result = nd.getARhs()
  or
  kind = "use" and
  result = nd.getAUse()
}

private string getLoc(DataFlow::Node nd) {
  exists(string filepath, int startline |
    nd.hasLocationInfo(filepath, startline, _, _, _) and
    result = filepath + ":" + startline
  )
}

/**
 * An assertion matching a data-flow node against an API-graph feature.
 */
class Assertion extends Comment {
  string polarity;
  string expectedKind;
  string expectedLoc;

  Assertion() {
    exists(string txt, string rex |
      txt = this.getText().trim() and
      rex = "(!?)(def|use) .*"
    |
      polarity = txt.regexpCapture(rex, 1) and
      expectedKind = txt.regexpCapture(rex, 2) and
      expectedLoc = getFile().getAbsolutePath() + ":" + getLocation().getStartLine()
    )
  }

  string getEdgeLabel(int i) { result = this.getText().regexpFind("(?<=\\()[^()]+", i, _).trim() }

  int getPathLength() { result = max(int i | exists(getEdgeLabel(i))) + 1 }

  API::Node lookup(int i) {
    i = getPathLength() and
    result = API::root()
    or
    result = lookup(i + 1).getASuccessor(getEdgeLabel(i))
  }

  predicate isNegative() { polarity = "!" }

  predicate holds() { getLoc(getNode(lookup(0), expectedKind)) = expectedLoc }

  string tryExplainFailure() {
    exists(int i, API::Node nd, string prefix, string suffix |
      nd = lookup(i) and
      i > 0 and
      not exists(lookup([0 .. i - 1])) and
      prefix = nd + " has no outgoing edge labelled " + getEdgeLabel(i - 1) + ";" and
      if exists(nd.getASuccessor())
      then
        suffix =
          "it does have outgoing edges labelled " +
            concat(string lbl | exists(nd.getASuccessor(lbl)) | lbl, ", ") + "."
      else suffix = "it has no outgoing edges at all."
    |
      result = prefix + " " + suffix
    )
    or
    exists(API::Node nd, string kind | nd = lookup(0) |
      exists(getNode(nd, kind)) and
      not exists(getNode(nd, expectedKind)) and
      result = "Expected " + expectedKind + " node, but found " + kind + " node."
    )
    or
    exists(DataFlow::Node nd | nd = getNode(lookup(0), expectedKind) |
      not getLoc(nd) = expectedLoc and
      result = "Node not found on this line (but there is one on line " + min(getLoc(nd)) + ")."
    )
  }

  string explainFailure() {
    if isNegative()
    then (
      holds() and
      result = "Negative assertion failed."
    ) else (
      not holds() and
      (
        result = tryExplainFailure()
        or
        not exists(tryExplainFailure()) and
        result = "Positive assertion failed for unknown reasons."
      )
    )
  }
}

query predicate failed(Assertion a, string explanation) { explanation = a.explainFailure() }
