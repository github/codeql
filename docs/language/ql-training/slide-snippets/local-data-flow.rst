Data flow analysis
==================

- Models flow of data through the program.
- Implemented in the module ``semmle.code.<lang>.dataflow.DataFlow``.
- Class ``DataFlow::Node`` represents program elements that have a value, such as expressions and function parameters.

  - Nodes of the data flow graph.

- Various predicates represent flow between these nodes.
  
  - Edges of the data flow graph.

.. note::

  The solution here is to use *data flow*. Data flow is, as the name suggests, about tracking the flow of data through the program. It helps answers questions like: *does this expression ever hold a value that originates from a particular other place in the program*?

  We can visualize the data flow problem as one of finding paths through a directed graph, where the nodes of the graph are elements in program, and the edges represent the flow of data between those elements. If a path exists, then the data flows between those two edges.

Data flow graphs
================

.. container:: column-left

   Example:

   .. code-block:: cpp

      int func(int tainted) {
         int x = tainted;
         if (someCondition) {
           int y = x;
           callFoo(y);
         } else {
           return x;
         }
         return -1;
      }
 
.. container:: column-right

  Data flow graph:
   
      .. graphviz::
         
            digraph {
            graph [ dpi = 1000 ]
            node [shape=polygon,sides=4,color=blue4,style="filled,rounded",   fontname=consolas,fontcolor=white]
            a [label=<tainted<BR /><FONT POINT-SIZE="10">ParameterNode</FONT>>]
            b [label=<tainted<BR /><FONT POINT-SIZE="10">ExprNode</FONT>>]
            c [label=<x<BR /><FONT POINT-SIZE="10">ExprNode</FONT>>]
            d [label=<x<BR /><FONT POINT-SIZE="10">ExprNode</FONT>>]
            e [label=<y<BR /><FONT POINT-SIZE="10">ExprNode</FONT>>]
   
            a -> b
            b -> {c, d}
            c -> e
   
         }

Local vs global data flow
=========================

- Local (“intra-procedural”) data flow models flow within one function; feasible to compute for all functions in a CodeQL database
- Global (“inter-procedural”) data flow models flow across function calls; not feasible to compute for all functions in a CodeQL database
- Different APIs, so discussed separately
- This slide deck focuses on the former

.. note::

  For further information, see:

  - `About data flow analysis <https://help.semmle.com/QL/learn-ql/ql/intro-to-data-flow.html>`__

.. rst-class:: background2

Local data flow
===============

Importing data flow
===================

To use the data flow library, add the following import:

.. code-block:: ql

   import semmle.code.<language>.dataflow.DataFlow

**Note**: this library contains an explicit “module” declaration:

.. code-block:: ql

   module DataFlow {
     class Node extends ... { ... }
     predicate localFlow(Node source, Node sink) {
               localFlowStep*(source, sink)
            }
     ... 
   }

So all references will need to be qualified (that is, ``DataFlow::Node``)

.. note::

  A **query library** is file with the extension ``.qll``. Query libraries do not contain a query clause, but may contain modules, classes, and predicates. 
  For further information on the data flow libraries, see the following links:

  - `Java data flow library <https://help.semmle.com/qldoc/java/semmle/code/java/dataflow/DataFlow.qll/module.DataFlow.html>`__
  - `C/C++ data flow library <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/dataflow/DataFlow.qll/module.DataFlow.html>`__
  - `C# data flow library <https://help.semmle.com/qldoc/csharp/semmle/code/csharp/dataflow/DataFlow.qll/module.DataFlow.html>`__

  A **module** is a way of organizing QL code by grouping together related predicates, classes, and (sub-)modules. They can be either explicitly declared or implicit. A query library implicitly declares a module with the same name as the QLL file.

  For further information on libraries and modules in QL, see the chapter on `Modules <https://help.semmle.com/QL/ql-handbook/modules.html>`__ in the QL language reference.
  For further information on importing QL libraries and modules, see the chapter on `Name resolution <https://help.semmle.com/QL/ql-handbook/name-resolution.html>`__ in the QL language reference.

Data flow graph
===============

- Class ``DataFlow::Node`` represents data flow graph nodes
- Predicate ``DataFlow::localFlowStep`` represents local data flow graph edges, ``DataFlow::localFlow`` is its transitive closure
- Data flow graph nodes are *not* AST nodes, but they correspond to AST nodes, and there are predicates for mapping between them:

  - ``Expr Node.asExpr()``
  - ``Parameter Node.asParameter()``
  - ``DataFlow::Node DataFlow::exprNode(Expr e)``
  - ``DataFlow::Node DataFlow::parameterNode(Parameter p)``
  - ``etc.``

.. note::

  The ``DataFlow::Node`` class is shared between both the local and global data flow graphs–the primary difference is the edges, which in the “global” case can link different functions.

  ``localFlowStep`` is the “single step” flow relation–that is, it describes single edges in the local data flow graph. ``localFlow`` represents the `transitive <https://help.semmle.com/QL/ql-handbook/recursion.html#transitive-closures>`__ closure of this relation–in other words, it contains every pair of nodes where the second node is reachable from the first in the data flow graph.

  The data flow graph is separate from the `AST <https://en.wikipedia.org/wiki/Abstract_syntax_tree>`__, to allow for flexibility in how data flow is modeled. There are a small number of data flow node types–expression nodes, parameter nodes, uninitialized variable nodes, and definition by reference nodes. Each node provides mapping functions to and from the relevant AST (for example ``Expr``, ``Parameter`` etc.) or symbol table (for example ``Variable``) classes.

Taint tracking
==============

- Usually, we want to generalise slightly by not only considering plain data flow, but also “taint” propagation, that is, whether a value is influenced by or derived from another.

- Examples:

  .. code-block:: java
  
    sink = source;        // source -> sink: data and taint
    strcat(sink, source); // source -> sink: taint, not data

- Library ``semmle.code.<language>.dataflow.TaintTracking`` provides predicates for tracking taint; ``TaintTracking::localTaintStep`` represents one (local) taint step, ``TaintTracking::localTaint`` is its transitive closure.

.. note::

  Taint tracking can be thought of as another type of data flow graph. It usually extends the standard data flow graph for a problem by adding edges between nodes where one one node influences or *taints* another.

  The taint-tracking API is almost identical to that of the local data flow. All we need to do to switch to taint tracking is ``import semmle.code.<language>.dataflow.TaintTracking`` instead of ``semmle.code.<language>.dataflow.DataFlow``, and instead of using ``localFlow``, we use ``localTaint``.
  
  - `Java taint-tracking library <https://help.semmle.com/qldoc/java/semmle/code/java/dataflow/TaintTracking.qll/module.TaintTracking.html>`__ 
  - `C/C++ taint-tracking library <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/dataflow/TaintTracking.qll/module.TaintTracking.html>`__ 
  - `C# taint-tracking library <https://help.semmle.com/qldoc/csharp/semmle/code/csharp/dataflow/TaintTracking.qll/module.TaintTracking.html>`__ 
