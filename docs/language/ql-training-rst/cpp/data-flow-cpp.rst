Introduction to data flow
=========================

.. container:: semmle-logo

   Semmle :sup:`TM`

Finding string formatting vulnerabilities in C/C++

Getting started and setting up
==============================

To try the examples in this presentation you should download:

- `QL for Eclipse <https://help.semmle.com/ql-for-eclipse/Content/WebHelp/install-plugin-free.html>`__
- Snapshot: `dotnet/coreclr <http://downloads.lgtm.com/snapshots/cpp/dotnet/coreclr/dotnet_coreclr_fbe0c77.zip>`__

More resources:

- To learn more about the main features of QL, try looking at the `QL language handbook <https://help.semmle.com/QL/ql-handbook/>`__.
- For further information about writing queries in QL, see `Writing QL queries <https://help.semmle.com/QL/learn-ql/ql/writing-queries/writing-queries.html>`__.

.. note::

  To run the queries featured in this training presentation, we recommend you download the free-to-use `QL for Eclipse plugin <https://help.semmle.com/ql-for-eclipse/Content/WebHelp/getting-started.html>`__.

  This plugin allows you to locally access the latest features of QL, including the standard QL libraries and queries. It also provides standard IDE features such as syntax highlighting, jump-to-definition, and tab completion.

  A good project to start analyzing is `ChakraCore <https://github.com/dotnet/coreclr>`__–a suitable snapshot to query is available by visiting the link on the slide.

  Alternatively, you can query any project (including ChakraCore) in the  `query console on LGTM.com <https://lgtm.com/query/projects:1505958977333/lang:cpp/>`__. 

  Note that results generated in the query console are likely to differ to those generated in the QL plugin as LGTM.com analyzes the most recent revisions of each project that has been added–the snapshot available to download above is based on an historical version of the code base.

Agenda
======

- Non-constant format string
- Data flow
- Modules and libraries
- Local data flow
- Local taint tracking

Motivation
==========

Let’s write a query to identify instances of `CWE-134 <https://cwe.mitre.org/data/definitions/134.html>`__ **Use of externally controlled format string**.

.. code-block:: cpp

  printf(userControlledString, arg1);

**Goal**: Find uses of ``printf`` (or similar) where the format string can be controlled by an attacker.

.. note::

  Formatting functions allow the programmer to construct a string output using a *format string* and an optional set of arguments. The *format string* is specified using a simple template language, where the output string is constructed by processing the format string to find *format specifiers*, and inserting values provided as arguments. For example:

  .. code-block:: cpp

    printf("Name: %s, Age: %d", "Freddie", 2);

  would produce the output ``"Name: Freddie, Age: 2”``. So far, so good. However, problems arise if there is a mismatch between the number of formatting specifiers, and the number of arguments. For example:

  .. code-block:: cpp

    printf("Name: %s, Age: %d", "Freddie");

  In this case, we have one more format specifier than we have arguments. In a managed language such as Java or C#, this simply leads to a runtime exception. However, in C/C++, the formatting functions are typically implemented by reading values from the stack without any validation of the number of arguments. This means a mismatch in the number of format specifiers and format arguments can lead to information disclosure.

  Of course, in practice this happens rarely with *constant* formatting strings. Instead, it’s most problematic when the formatting string can be specified by the user, allowing an attacker to provide a formatting string with the wrong number of format specifiers. Furthermore, if an attacker can control the format string, they may be able to provide the %n format specifier, which causes ``printf`` to write the number characters in the generated output string to a specified location.

  See https://en.wikipedia.org/wiki/Uncontrolled_format_string for more background.

Exercise: Non-constant format string
====================================

Write a query that flags ``printf`` calls where the format argument is not a ``StringLiteral``. 

**Hint**: Import ``semmle.code.cpp.commons.Printf`` and use class ``FormattingFunction`` and ``getFormatParameterIndex()``.

.. rst-class:: build

.. literalinclude:: ../query-examples/cpp/data-flow-cpp-1.ql
  :language: ql

.. note::

  This first query is about finding places where the format specifier is not a constant string. In QL for C/C++, constant strings are modeled as ``StringLiteral`` nodes, so we are looking for calls to format functions where the format specifier argument is not a string literal.

  The `C/C++ standard libraries <https://help.semmle.com/qldoc/cpp/>`__ include many different formatting functions that may be vulnerable to this particular attack–including ``printf``, ``snprintf``, and others. Furthermore, each of these different formatting functions may include the format string in a different position in the argument list. Instead of laboriously listing all these different variants, we can make use of the QL for C/C++ standard library class ``FormattingFunction``, which provides an interface that models common formatting functions in C/C++.

Meh...
======

Results are unsatisfactory:

- Query flags cases where the format string is a symbolic constant.
- Query flags cases where the format string is itself a format argument.
- Query doesn't recognize wrapper functions around ``printf``-like functions.

We need something better.

.. note::

  For example, consider the results which appear in ``/src/ToolBox/SOS/Strike/util.h``, between lines 965 and 970:

  .. code-block:: cpp

    const char *format = align == AlignLeft ? "%-*.*s" : "%*.*s";

     if (IsDMLEnabled())
         DMLOut(format, width, precision, mValue);
     else
         ExtOut(format, width, precision, mValue);

  Here, ``DMLOut`` and ``ExtOut`` are macros that expand to formatting calls. The format specifier is not constant, in the sense that the format argument is not a string literal. However, it is clearly one of two possible constants, both with the same number of format specifiers.

  What we need is a way to determine whether the format argument is ever set to something that is not constant.

Data flow analysis
==================

- Models flow of data through the program.
- Implemented in the module ``semmle.code.cpp.dataflow.DataFlow``.
- Class ``DataFlow::Node`` represents program elements that have a value, such as expressions and function parameters.
  - Nodes of the data flow graph.
- Various predicated represent flow between these nodes.
  Edges of the data flow graph.

.. note::

  The solution here is to use *data flow*. Data flow is, as the name suggests, about tracking the flow of data through the program. It helps answers questions like: *does this expression ever hold a value that originates from a particular other place in the program*?

  We can visualize the data flow problem as one of finding paths through a directed graph, where the nodes of the graph are elements in program, and the edges represent the flow of data between those elements. If a path exists, then the data flows between those two edges.

Data flow graphs
================

.. container:: column-left

   Example:

   .. code-block:: cpp

      int func(int, tainted) {
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

   .. container:: image-box
   
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

- Local (“intra-procedural”) data flow models flow within one function; feasible to compute for all functions in a snapshot
- Global (“inter-procedural”) data flow models flow across function calls; not feasible to compute for all functions in a snapshot
- Different APIs, so discussed separately

This slide deck focuses on the former.

.. note::

  For further information, see:

  - `Introduction to data flow analysis in QL <https://help.semmle.com/QL/learn-ql/ql/intro-to-data-flow.html>`__
  - `Analyzing data flow in C/C++ <https://help.semmle.com/QL/learn-ql/ql/cpp/dataflow.html>`__

.. rst-class:: background2

Local data flow
===============

Importing data flow
===================

To use the data flow library, add the following import:

.. code-block:: ql

   import semmle.code.cpp.dataflow.DataFlow

**Note**: this library contains an explicit “module” declaration:

.. code-block:: ql

   module DataFlow {
     class Node extends … { … }
     predicate localFlow(Node source, Node sink) {
               localFlowStep*(source, sink)
            }
     … 
   }

So all references will need to be qualified (that is ``DataFlow::Node``)

.. note::

  A **query library** is file with the extension ``.qll``. Query libraries do not contain a query clause, but may contain modules, classes, and predicates. For example, the `C/C++ data flow library <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/dataflow/DataFlow.qll/module.DataFlow.html>`__ is contained in the ``semmle/code/cpp/dataflow/DataFlow.qll`` QLL file, and can be imported as shown above.

  A **module** is a way of organizing QL code by grouping together related predicates, classes, and (sub-)modules. They can be either explicitly declared or implicit. A query library implicitly declares a module with the same name as the QLL file.

  For further information on libraries and modules in QL, see the chapter on `Modules <https://help.semmle.com/QL/ql-handbook/modules.html>`__ in the QL language handbook.

  For further information on importing QL libraries and modules, see the chapter on `Name resolution <https://help.semmle.com/QL/ql-handbook/name-resolution.html>`__ in the QL language handbook.

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

  ``localFlowStep`` is the “single step” flow relation–that is it describes single edges in the local data flow graph. ``localFlow`` represents the `transitive <https://help.semmle.com/QL/ql-handbook/recursion.html#transitive-closures>`__ closure of this relation–in other words, it contains every pair of nodes where the second node is reachable from the first in the data flow graph.

  The data flow graph is separate from the `AST <https://en.wikipedia.org/wiki/Abstract_syntax_tree>`__, to allow for flexibility in how data flow is modeled. There are a small number of data flow node types–expression nodes, parameter nodes, uninitialized variable nodes, and definition by reference nodes. Each node provides mapping functions to and from the relevant AST (for example ``Expr``, ``Parameter`` etc.) or symbol table (for example ``Variable``) classes.

Taint-tracking
==============

- Usually, we want to generalise slightly by not only considering plain data flow, but also “taint” propagation, that is, whether a value is influenced by or derived from another.

- Examples:

.. code-block:: cpp

  sink = source;        // source -> sink: data and taint
  strcat(sink, source); // source -> sink: taint, not data

- Library ``semmle.code.cpp.dataflow.TaintTracking`` provides predicates for tracking taint; ``TaintTracking::localTaintStep`` represents one (local) taint step, ``TaintTracking::localTaint`` is its transitive closure.

.. note::

  Taint tracking can be thought of as another type of data flow graph. It usually extends the standard data flow graph for a problem by adding edges between nodes where one one node influences or *taints* another.

  The `API <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/dataflow/TaintTracking.qll/module.TaintTracking.html>`__ is almost identical to that of the local data flow. All we need to do to switch to taint tracking is ``import semmle.code.cpp.dataflow.TaintTracking`` instead of ``semmle.code.cpp.dataflow.DataFlow``, and instead of using ``localFlow``, we use ``localTaint``.

Exercise: source nodes
======================

Define a subclass of ``DataFlow::Node`` representing “source” nodes, that is, nodes without a (local) data flow predecessor.

**Hint**: use ``not exists()``.

.. rst-class:: build

.. code-block:: ql

  class SourceNode extends DataFlow::Node {
      SourceNode() {
        not DataFlow::localFlowStep(_, this)
      }
    }

.. note::

  Note the scoping of the `don’t-care variable <https://help.semmle.com/QL/ql-handbook/expressions.html#don-t-care-expressions>`__ “_” in this example: the body of the characteristic predicate is equivalent to:
  
  .. code-block:: ql

    not exists(DataFlow::Node pred | DataFlow::localFlowStep(pred, this))
    
  which is not the same as:

  .. code-block:: ql

    exists(DataFlow::Node pred | not DataFlow::localFlowStep(pred, this)).

Revisiting non-constant format strings
======================================

Refine the query to find calls to ``printf``-like functions where the format argument derives from a local source that is not a constant string.

.. rst-class:: build

.. literalinclude:: ../query-examples/cpp/data-flow-cpp-2.ql
  :language: ql

Refinements (take home exercise)
================================

Audit the results and apply any refinements you deem necessary.
Suggestions:

- Replace ``DataFlow::localFlowStep`` with a custom predicate that includes steps through global variable definitions.
  **Hint**: Use class ``GlobalVariable`` and its member predicates ``getAnAssignedValue()`` and ``getAnAccess()``.

- Exclude calls in wrapper functions that just forward their format argument to another ``printf``-like function; instead, flag calls to those functions.

Beyond local data flow
======================

- Results are still underwhelming.
- Dealing with parameter passing becomes cumbersome.
- Instead, let’s turn the problem around and find user-controlled data that flows into a ``printf`` format argument, potentially through calls.
- This needs **global data flow**.
