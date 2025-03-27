private import powershell as PS

/**
 * TODO: This whole computation cab be sped up by providing a set of "root"s and doing
 * a forward/backwards traversal first.
 */
module Private {
  signature module InterpretAstInputSig {
    /** The type on which to translate `Ast` elements during escape calculations */
    class T;

    /** Interpret `a` into a `T` */
    T interpret(PS::Ast a);
  }

  module AstEscape<InterpretAstInputSig Interpret> {
    private import Interpret

    /** An AST element that may produce a value which can escape from this `Ast` when evaluated. */
    abstract private class ElementImpl instanceof PS::Ast {
      string toString() { result = super.toString() }

      /** Gets a direct node that will may escape when evaluating this element. */
      T getANode() { none() }

      /** Gets a child that may produce more elements that may escape. */
      abstract Element getAChild();

      /**
       * Gets a (possibly transitive) element that may escape when evaluating
       * this element.
       */
      final T getAnEscapingElement() {
        result = this.getANode()
        or
        result = this.getAChild().getAnEscapingElement()
      }
    }

    final class Element = ElementImpl;

    private class ScriptBlockElement extends ElementImpl instanceof PS::ScriptBlock {
      final override Element getAChild() { result = super.getEndBlock() }
    }

    private class NamedBlockElement extends ElementImpl instanceof PS::NamedBlock {
      final override Element getAChild() { result = super.getAStmt() }
    }

    private class ExprStmtElement extends ElementImpl instanceof PS::ExprStmt {
      final override T getANode() { result = interpret(super.getExpr()) }

      final override Element getAChild() { none() }
    }

    private class LoopStmtElement extends ElementImpl instanceof PS::LoopStmt {
      final override Element getAChild() { result = super.getBody() }
    }

    private class StmtBlockElement extends ElementImpl instanceof PS::StmtBlock {
      final override Element getAChild() { result = super.getAStmt() }
    }

    private class TryStmtElement extends ElementImpl instanceof PS::TryStmt {
      final override Element getAChild() {
        result = super.getBody() or result = super.getACatchClause() or result = super.getFinally()
      }
    }

    private class ReturnStmtElement extends ElementImpl instanceof PS::ReturnStmt {
      final override Element getAChild() { result = super.getPipeline() }
    }

    private class CatchClausElement extends ElementImpl instanceof PS::CatchClause {
      final override Element getAChild() { result = super.getBody() }
    }

    private class SwitchStmtElement extends ElementImpl instanceof PS::SwitchStmt {
      final override Element getAChild() { result = super.getACase() }
    }
  }
}

module Public { }
