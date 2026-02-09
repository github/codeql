/**
 * Provides modules for printing control flow graphs in VSCode via the "View
 * CFG" query. Also provides modules for printing control flow graphs in tests
 * and as Mermaid diagrams.
 */
overlay[local?]
module;

private import codeql.util.FileSystem
private import codeql.util.Location
private import SuccessorType

signature module InputSig<LocationSig Location> {
  class Callable;

  class ControlFlowNode {
    Callable getEnclosingCallable();

    Location getLocation();

    string toString();
  }

  ControlFlowNode getASuccessor(ControlFlowNode n, SuccessorType t);
}

/** Provides modules for printing control flow graphs. */
module PrintGraph<LocationSig Location, InputSig<Location> Input> {
  private import Input

  /** A node to be included in the output of `TestOutput`. */
  signature class RelevantNodeSig extends ControlFlowNode;

  /**
   * Import this module into a `.ql` file to output a CFG. The
   * graph is restricted to nodes from `RelevantNode`.
   */
  module TestOutput<RelevantNodeSig RelevantNode> {
    /** Holds if `pred -> succ` is an edge in the CFG. */
    query predicate edges(RelevantNode pred, RelevantNode succ, string label) {
      label =
        strictconcat(SuccessorType t, string s |
          succ = getASuccessor(pred, t) and
          if t instanceof DirectSuccessor then s = "" else s = t.toString()
        |
          s, ", " order by s
        )
    }

    /**
     * Provides logic for representing a CFG as a [Mermaid diagram](https://mermaid.js.org/).
     */
    module Mermaid {
      private string nodeId(RelevantNode n) {
        result =
          any(int i |
            n =
              rank[i](RelevantNode p, string filePath, int startLine, int startColumn, int endLine,
                int endColumn |
                p.getLocation()
                    .hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
              |
                p order by filePath, startLine, startColumn, endLine, endColumn, p.toString()
              )
          ).toString()
      }

      private string nodes() {
        result =
          concat(RelevantNode n, string id, string text |
            id = nodeId(n) and
            text = n.toString()
          |
            id + "[\"" + text + "\"]", "\n" order by id
          )
      }

      private string edge(RelevantNode pred, RelevantNode succ) {
        edges(pred, succ, _) and
        exists(string label |
          edges(pred, succ, label) and
          if label = ""
          then result = nodeId(pred) + " --> " + nodeId(succ)
          else result = nodeId(pred) + " -- " + label + " --> " + nodeId(succ)
        )
      }

      private string edges() {
        result =
          concat(RelevantNode pred, RelevantNode succ, string edge, string filePath, int startLine,
            int startColumn, int endLine, int endColumn |
            edge = edge(pred, succ) and
            pred.getLocation().hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
          |
            edge, "\n"
            order by
              filePath, startLine, startColumn, endLine, endColumn, pred.toString()
          )
      }

      /** Holds if the Mermaid representation is `s`. */
      query predicate mermaid(string s) { s = "flowchart TD\n" + nodes() + "\n\n" + edges() }
    }
  }

  /** Provides the input to `ViewCfgQuery`. */
  signature module ViewCfgQueryInputSig<FileSig File> {
    /** Gets the source file selected in the IDE. Should be an `external` predicate. */
    string selectedSourceFile();

    /** Gets the source line selected in the IDE. Should be an `external` predicate. */
    int selectedSourceLine();

    /** Gets the source column selected in the IDE. Should be an `external` predicate. */
    int selectedSourceColumn();

    /**
     * Holds if `callable` spans column `startColumn` of line `startLine` to
     * column `endColumn` of line `endLine` in `file`.
     */
    predicate cfgScopeSpan(
      Callable callable, File file, int startLine, int startColumn, int endLine, int endColumn
    );
  }

  /**
   * Provides an implementation for a `View CFG` query.
   *
   * Import this module into a `.ql` that looks like
   *
   * ```ql
   * @name Print CFG
   * @description Produces a representation of a file's Control Flow Graph.
   *              This query is used by the VS Code extension.
   * @id <lang>/print-cfg
   * @kind graph
   * @tags ide-contextual-queries/print-cfg
   * ```
   */
  module ViewCfgQuery<FileSig File, ViewCfgQueryInputSig<File> ViewCfgQueryInput> {
    private import ViewCfgQueryInput

    bindingset[file, line, column]
    private Callable smallestEnclosingScope(File file, int line, int column) {
      result =
        min(Callable callable, int startLine, int startColumn, int endLine, int endColumn |
          cfgScopeSpan(callable, file, startLine, startColumn, endLine, endColumn) and
          (
            startLine < line
            or
            startLine = line and startColumn <= column
          ) and
          (
            endLine > line
            or
            endLine = line and endColumn >= column
          )
        |
          callable order by startLine desc, startColumn desc, endLine, endColumn
        )
    }

    private import IdeContextual<File>

    final private class FinalControlFlowNode = ControlFlowNode;

    private class RelevantNode extends FinalControlFlowNode {
      RelevantNode() {
        this.getEnclosingCallable() =
          smallestEnclosingScope(getFileBySourceArchiveName(selectedSourceFile()),
            selectedSourceLine(), selectedSourceColumn())
      }

      string getOrderDisambiguation() { result = "" }
    }

    private module Output = TestOutput<RelevantNode>;

    import Output::Mermaid

    /** Holds if `pred` -> `succ` is an edge in the CFG. */
    query predicate edges(RelevantNode pred, RelevantNode succ, string attr, string val) {
      attr = "semmle.label" and
      Output::edges(pred, succ, val)
    }
  }
}
