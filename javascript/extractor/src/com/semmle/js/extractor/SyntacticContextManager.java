package com.semmle.js.extractor;

import com.semmle.js.ast.BreakStatement;
import com.semmle.js.ast.JumpStatement;
import com.semmle.js.ast.LabeledStatement;
import com.semmle.js.ast.Loop;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.SwitchStatement;
import com.semmle.util.trap.TrapWriter.Label;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * The syntactic context manager keeps track of the statement currently being extracted and its
 * enclosing loops, switch statements and labelled statements. It can use this information to
 * determine the targets of 'break' or 'continue' statements.
 *
 * <p>The syntactic context manager maintains a context chain. Each context object on the chain
 * represents a syntactic context within a given function or the toplevel, and has a link to its
 * enclosing syntactic context. Context objects also maintain a reference to the statement currently
 * being extracted, and to the function or toplevel.
 *
 * <p>Furthermore, each context object has two maps, one representing 'break' targets, the other
 * 'continue' targets. These maps associate labels <i>l</i> with the nearest enclosing statement (in
 * the same function) that has label <i>l</i>, if any. If <i>l</i> is the empty string, it maps to
 * the nearest enclosing loop or switch statement (but only for 'break' targets).
 */
public class SyntacticContextManager {
  private static class JumpTarget {
    private final String label;
    private final Node node;
    private final JumpTarget outer;

    public JumpTarget(String label, Node node, JumpTarget outer) {
      this.label = label;
      this.node = node;
      this.outer = outer;
    }

    public Node lookup(String label) {
      if (this.label.equals(label)) return node;
      return outer == null ? null : outer.lookup(label);
    }
  }

  private static class Context {
    private final Context outer;
    private final Label containerKey;

    private Statement curStatement;
    private JumpTarget breakTargets;
    private JumpTarget continueTargets;

    public Context(Context outer, Label containerKey) {
      this.outer = outer;
      this.containerKey = containerKey;
    }

    public void addBreakTarget(String label, Node node) {
      breakTargets = new JumpTarget(label, node, breakTargets);
    }

    public void addContinueTarget(String label, Node node) {
      continueTargets = new JumpTarget(label, node, continueTargets);
    }
  }

  private Context context = null;
  private final Set<LabeledStatement> loopLabels = new LinkedHashSet<LabeledStatement>();

  public void enterContainer(Label containerKey) {
    context = new Context(context, containerKey);
  }

  public void leaveContainer() {
    context = context.outer;
  }

  public Statement getCurrentStatement() {
    return context.curStatement;
  }

  public void setCurrentStatement(Statement nd) {
    context.curStatement = nd;
  }

  public Object getCurrentContainerKey() {
    return context.containerKey;
  }

  public void enterSwitchStatement(SwitchStatement nd) {
    context.addBreakTarget("", nd);
  }

  public void leaveSwitchStatement() {
    context.breakTargets = context.breakTargets.outer;
  }

  public void enterLoopStmt(Statement nd) {
    context.addBreakTarget("", nd);
    context.addContinueTarget("", nd);
  }

  public void leaveLoopStmt() {
    context.breakTargets = context.breakTargets.outer;
    context.continueTargets = context.continueTargets.outer;
  }

  public void enterLabeledStatement(LabeledStatement nd) {
    context.addBreakTarget(nd.getLabel().getName(), nd);

    // check whether this labelled statement directly or indirectly labels a loop
    // (and thus may be the target of a 'continue' statement)
    Statement stmt;
    for (stmt = nd.getBody(); stmt instanceof LabeledStatement; ) {
      stmt = ((LabeledStatement) stmt).getBody();
    }
    if (stmt instanceof Loop) {
      loopLabels.add(nd);
      context.addContinueTarget(nd.getLabel().getName(), nd);
    }
  }

  public void leaveLabeledStatement(LabeledStatement nd) {
    context.breakTargets = context.breakTargets.outer;
    if (loopLabels.contains(nd)) context.continueTargets = context.continueTargets.outer;
  }

  public Object getTarget(JumpStatement nd) {
    String label = nd.hasLabel() ? nd.getLabel().getName() : "";
    if (nd instanceof BreakStatement)
      return this.context.breakTargets == null ? null : this.context.breakTargets.lookup(label);
    else
      return this.context.continueTargets == null
          ? null
          : this.context.continueTargets.lookup(label);
  }
}
