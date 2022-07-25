private import semmle.code.cpp.ir.IR
private import cpp as CPP

module Private {
  predicate edge(Node n1, Node n2) { n1.getASuccessor() = n2 }

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

  class CallNode extends Node, CallInstruction { }

  class Callable extends IRFunction { }

  class Position = CPP::ParameterIndex;
}

private newtype TSplit = TNone() { none() }

private import Public
