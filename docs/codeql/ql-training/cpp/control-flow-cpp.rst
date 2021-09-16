======================
Analyzing control flow
======================

CodeQL for C/C++

.. Include information slides here

.. rst-class:: setup

Setup
=====

For this example you should download:

- `CodeQL for Visual Studio Code <https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/>`__
- `ChakraCore database <https://downloads.lgtm.com/snapshots/cpp/microsoft/chakracore/ChakraCore-revision-2017-April-12--18-13-26.zip>`__

.. note::

   For the examples in this presentation, we will be analyzing `ChakraCore <https://github.com/Chakra-Core/ChakraCore/>`__.

   You can query the project in `the query console <https://lgtm.com/query/project:2034240708/lang:cpp/>`__ on LGTM.com.

   .. insert database-note.rst to explain differences between database available to download and the version available in the query console.

   .. include:: ../slide-snippets/database-note.rst

   .. resume slides


.. rst-class:: agenda

Agenda
======

- Control flow graphs
- Exercise: use after free
- Recursion over the control flow graph
- Basic blocks
- Guard conditions

Control flow graphs
===================

.. container:: column-left

   We frequently want to ask questions about the possible *order of execution* for a program.

   Example:

   .. code-block:: cpp

      if (x) {
        return 1;
      } else {
        return 2;
      }
 
.. container:: column-right

  Possible execution order is usually represented by a *control flow graph*:

   .. graphviz::
      
         digraph {
         graph [ dpi = 1000 ]
         node [shape=polygon,sides=4,color=blue4,style="filled,rounded",fontname=consolas,fontcolor=white]
         a [label=<if<BR /><FONT POINT-SIZE="10">IfStmt</FONT>>]
         b [label=<x<BR /><FONT POINT-SIZE="10">VariableAccess</FONT>>]
         c [label=<1<BR /><FONT POINT-SIZE="10">Literal</FONT>>]
         d [label=<2<BR /><FONT POINT-SIZE="10">Literal</FONT>>]
         e [label=<return<BR /><FONT POINT-SIZE="10">ReturnStmt</FONT>>]
         f [label=<return<BR /><FONT POINT-SIZE="10">ReturnStmt</FONT>>]

         a -> b
         b -> {c, d}
         c -> e
         d -> f
      }

.. note::

   The control flow graph is a static over-approximation of possible control flow at runtime. 
   Its nodes are program elements such as expressions and statements. 
   If there is an edge from one node to another, then it means that the semantic operation corresponding to the first node may be immediately followed by the operation corresponding to the second node. 
   Some nodes (such as conditions of “if” statements or loop conditions) have more than one successor, representing conditional control flow at runtime.

Modeling control flow
=====================

The control flow is modeled with a CodeQL class, ``ControlFlowNode``. Examples of control flow nodes include statements and expressions.

- ``ControlFlowNode`` provides API for traversing the control flow graph:

  - ``ControlFlowNode ControlFlowNode.getASuccessor()``
  - ``ControlFlowNode ControlFlowNode.getAPredecessor()``
  - ``ControlFlowNode ControlFlowNode.getATrueSuccessor()``
  - ``ControlFlowNode ControlFlowNode.getAFalseSuccessor()``

The control-flow graph is *intra-procedural*–in other words, only models paths within a function. To find the associated function, use

- ``Function ControlFlowNode.getControlFlowScope()``

.. note::

   The control flow graph is similar in concept to data flow graphs. In contrast to data flow, however, the AST nodes are directly control flow graph nodes.

   The predecessor/successor predicates are prime examples of member predicates with results that are used in functional syntax, but that are not actually functions. This is because a control flow node may have any number of predecessors and successors (including zero or more than one).

Example: malloc/free pairs
==========================

Find calls to ``free`` that are reachable from an allocation on the same variable:

.. literalinclude:: ../query-examples/cpp/control-flow-cpp-1.ql 
   :language: ql

.. note::

   Predicates ``allocationCall`` and ``freeCall`` are defined in the standard library and model a number of standard alloc/free-like functions.

Exercise: use after free
========================

Based on this query, write a query that finds accesses to the variable that occur after the free.

.. rst-class:: build
  
- What do you find? What problems occur with this approach to detecting use-after-free vulnerabilities?

  .. rst-class:: build

      .. literalinclude:: ../query-examples/cpp/control-flow-cpp-2.ql 
         :language: ql

Utilizing recursion
===================

The main problem we observed in the previous exercise was that the successor's relation is unaware of changes to the variable that would invalidate our results.

We can fix this by writing our own successor predicate that stops traversing the CFG if the variable is re-defined.

Utilizing recursion
===================

.. code-block:: ql

   ControlFlowNode reachesWithoutReassignment(FunctionCall free, LocalScopeVariable v) 
   {
     freeCall(free, v.getAnAccess()) and
     (
       // base case
       result = free
       or 
       // recursive case
       exists(ControlFlowNode mid |
         mid = reachesWithoutReassignment(free, v) and
         result = mid.getASuccessor() and
         // stop tracking when the value may change
         not result = v.getAnAssignedValue() and
         not result.(AddressOfExpr).getOperand() = v.getAnAccess()
       )
     )
   }

Exercise
========

Find local variables that are written to, and then never accessed again.

**Hint**: Use ``LocalVariable.getAnAssignment()``. 

.. rst-class:: build

   .. literalinclude:: ../query-examples/cpp/control-flow-cpp-3.ql 
      :language: ql

.. rst-class:: background2

More control flow
=================

Basic blocks
============

``BasicBlock`` represents basic blocks, that is, straight-line sequences of control flow nodes without branching.

- ``ControlFlowNode BasicBlock.getNode(int)``
- ``BasicBlock BasicBlock.getASuccessor()``
- ``BasicBlock BasicBlock.getAPredecessor()``
- ``BasicBlock BasicBlock.getATrueSuccessor()``
- ``BasicBlock BasicBlock.getAFalseSuccessor()``

Often, queries can be made more efficient by treating basic blocks as a unit instead of reasoning about individual control flow nodes.

Exercise: unreachable blocks
============================

Write a query to find unreachable basic blocks.

**Hint**: First define a recursive predicate to identify reachable blocks. Class ``EntryBasicBlock`` may be useful.

.. rst-class:: build

.. literalinclude:: ../query-examples/cpp/control-flow-cpp-4.ql 
   :language: ql

.. note::

   This query has a good number of false positives on Chakra, many of them to do with templating and macros.

Guard conditions
================

A ``GuardCondition`` is a ``Boolean`` condition that controls one or more basic blocks in the sense that it is known to be true/false at the entry of those blocks.

- ``GuardCondition.controls(BasicBlock bb, boolean outcome):`` the entry of bb can only be reached if the guard evaluates to outcome

- ``GuardCondition.comparesLt, GuardCondition.ensuresLt, GuardCondition.comparesEq:`` auxiliary predicates to identify conditions that guarantee that one expression is less than/equal to another

Further materials
=================

- CodeQL for C/C++: https://codeql.github.com/docs/codeql-language-guides/codeql-for-cpp/ 
- API reference: https://codeql.github.com/codeql-standard-libraries/cpp 

.. rst-class:: end-slide

Extra slides
============

.. rst-class:: background2

Appendix: Library customizations
================================

Call graph customizations
=========================

The default implementation of call target resolution does not handle function pointers, because they are difficult to deal with in general.

We can, however, add support for particular patterns of use by contributing a new override of ``Call.getTarget``.

Exercise: unresolvable calls
============================

Write a query that finds all calls for which no call target can be determined, and run it on libjpeg-turbo.

Examine the results. What do you notice? 

.. rst-class:: build

   .. code-block:: ql
   
      import cpp
   
      from Call c
      where not exists(c.getTarget())
      select c

.. rst-class:: build

- Many results are calls through struct fields emulating virtual dispatch.

Exercise: resolving calls through variables
===========================================

Write a query that resolves the call at `cjpeg.c:640 <https://github.com/libjpeg-turbo/libjpeg-turbo/blob/9bc8eb6449a32f452ab3fc9f94af672a0af13f81/cjpeg.c#L640>`__.

**Hint**: Use classes ``ExprCall``, ``PointerDereferenceExpr``, and ``Access``.

.. rst-class:: build

.. literalinclude:: ../query-examples/cpp/control-flow-cpp-5.ql 
   :language: ql

Exercise: customizing the call graph
====================================

Create a subclass of ``ExprCall`` that uses your query to implement ``getTarget``.

.. rst-class:: build

.. code-block:: ql

   class CallThroughVariable extends ExprCall {
     Variable v;
     CallThroughVariable() {
       exists(PointerDereferenceExpr callee | callee = getExpr() |
         callee.getOperand() = v.getAnAccess()
       )
     }
     override Function getTarget() {
       result = super.getTarget() or
       exists(Access init | init = v.getAnAssignedValue() |
         result = init.getTarget()
       )
     }
   }

Control-flow graph customizations
=================================

The default control-flow graph implementation recognizes a few common patterns for non-returning functions, but sometimes it fails to spot them, which can cause imprecision.

We can add support for new non-returning functions by overriding ``ControlFlowNode.getASuccessor()``.

Exercise: calls to ``error_exit``
=================================

Write a query that finds all calls to a field called ``error_exit``.

**Hint**: Reuse (parts of) the ``CallThroughVariable`` class from before.

.. rst-class:: build

.. code-block:: ql

   class CallThroughVariable extends ExprCall { ... }
   
   class ErrorExitCall extends CallThroughVariable {
     override Field v;
   
     ErrorExitCall() { v.getName() = "error_exit" }
   }
   
   from ErrorExitCall eec
   select eec

Exercise: customizing the control-flow graph
============================================

Override ``ControlFlowNode`` to mark calls to ``error_exit`` as non-returning.

**Hint**: ``ExprCall`` is an indirect subclass of ``ControlFlowNode``. 

.. rst-class:: build

.. code-block:: ql

   class CallThroughVariable extends ExprCall { ... }
   
   class ErrorExitCall extends CallThroughVariable {
     override Field v;
   
     ErrorExitCall() { v.getName() = "error_exit" }
   
     override ControlFlowNode getASuccessor() { none() }
   }

``CustomOptions`` class
=======================

The Options library defines a ``CustomOptions`` class with various member predicates that can be overridden to customize aspects of the analysis.

In particular, it has an ``exprExits`` predicate that can be overridden to more easily perform the customization on the previous slide:

.. code-block:: ql

   import Options
   
   class MyOptions extends CustomOptions {
    override predicate exprExits(Expr e) {
      super.exprExits(e) or ...
    }
   }
