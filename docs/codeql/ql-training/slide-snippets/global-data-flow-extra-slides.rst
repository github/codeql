Exercise: How not to do global data flow
========================================

Implement a ``flowStep`` predicate extending ``localFlowStep`` with steps through function calls and returns. Why might we not want to use this?

.. code-block:: ql

   predicate stepIn(Call c, DataFlow::Node arg, DataFlow::ParameterNode parm) {
     exists(int i | arg.asExpr() = c.getArgument(i) |
       parm.asParameter() = c.getTarget().getParameter(i))
   }
   
   predicate stepOut(Call c, DataFlow::Node ret, DataFlow::Node res) {
     exists(ReturnStmt retStmt | retStmt.getEnclosingFunction() = c.getTarget() |
       ret.asExpr() = retStmt.getExpr() and res.asExpr() = c)
   }
   
   predicate flowStep(DataFlow::Node pred, DataFlow::Node succ) {
     DataFlow::localFlowStep(pred, succ) or
     stepIn(_, pred, succ) or
     stepOut(_, pred, succ)
   }

.. rst-class:: mismatched-calls-and-returns

Mismatched calls and returns
============================

.. diagram copied from google slides

Balancing calls and returns
===========================

- If we simply take ``flowStep*``, we might mismatch calls and returns, causing imprecision, which in turn may cause false positives.

- Instead, make sure that matching ``stepIn``/``stepOut`` pairs talk about the same call site:

.. code-block:: ql

   predicate balancedPath(DataFlow::Node src, DataFlow::Node snk) {
     src = snk or DataFlow::localFlowStep(src, snk) or
     exists(DataFlow::Node m | balancedPath(src, m) | balancedPath(m, snk)) or
     exists(Call c, DataFlow::Node parm, DataFlow::Node ret |
       stepIn(c, src, parm) and
       balancedPath(parm, ret) and
       stepOut(c, ret, snk)
     )
   }

Summary-based global data flow
==============================

- To avoid traversing the same paths many times, we compute function summaries that record if a function parameter flows into a return value:

   .. code-block:: ql
   
      predicate returnsParameter(Function f, int i) {
        exists (Parameter p, ReturnStmt retStmt, Expr ret |
          p = f.getParameter(i) and
          retStmt.getEnclosingFunction() = f and
          ret = retStmt.getExpr() and
          balancedPath(DataFlow::parameterNode(p), DataFlow::exprNode(ret))
        )
      }

- Use this predicate in ``balancedPath`` instead of ``stepIn``/``stepOut`` pairs.

