private import semmle.code.cpp.ir.IR
private import cpp as CPP

module Private {
  predicate edge(Node n1, Node n2) { n1.getASuccessor() = n2 }

  class Callable extends IRFunction { }

  predicate callTarget(CallInstruction call, Callable target) {
    // TODO virtual dispatch
    call.getStaticCallTarget() = target.getFunction()
  }

  predicate flowEntry(Callable c, Node entry) { c.getEnterFunctionInstruction() = entry }

  predicate flowExit(Callable c, Node exitNode) { c.getExitFunctionInstruction() = exitNode }

  Callable getEnclosingCallable(Node n) { n.getEnclosingIRFunction() = result }

  class Split extends TSplit {
    abstract string toString();

    abstract CPP::Location getLocation();

    abstract predicate entry(Node n1, Node n2);

    abstract predicate exit(Node n1, Node n2);

    abstract predicate blocked(Node n1, Node n2);
  }
}

module Public {
  class Node extends Instruction {
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  class CallNode extends Node {
    CallNode() { this instanceof CallInstruction }
  }

  abstract class Label extends TLabel {
    abstract string toString();
  }

  class LabelUnit extends Label, TLabelUnit {
    override string toString() { result = "labelunit" }
  }

  class LabelVar extends Label, TLabelVar {
    CPP::Variable var;

    LabelVar() { this = TLabelVar(var) }

    CPP::Variable getVar() { result = var }

    override string toString() { result = var.toString() }
  }

  class Position = CPP::ParameterIndex;
}

private newtype TSplit = TNone() { none() }

private newtype TLabel =
  TLabelUnit() or
  TLabelVar(CPP::Variable var)

private import Public
