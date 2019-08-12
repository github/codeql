=========================
Introduction to data flow
=========================

.. container:: semmle-logo

   Semmle :sup:`TM`

Finding SPARQL injection vulnerabilities in Java

.. rst-class:: setup

Setup
=====

For this example you should download:

- `QL for Eclipse <https://help.semmle.com/ql-for-eclipse/Content/WebHelp/install-plugin-free.html>`__
- `VIVO Vitro snapshot <http://downloads.lgtm.com/snapshots/java/vivo-project/Vitro/vivo-project_Vitro_java-srcVersion_47ae42c01954432c3c3b92d5d163551ce367f510-dist_odasa-lgtm-2019-04-23-7ceff95-linux64.zip>`__

.. note::

   For this example, we will be analyzing `VIVO Vitro <https://github.com/vivo-project/Vitro>`__.

   You can also query the project in `the query console <https://lgtm.com/query/project:14040005/lang:java/>`__ on LGTM.com.

   Note that results generated in the query console are likely to differ to those generated in the QL plugin as LGTM.com analyzes the most recent revisions of each project that has been added–the snapshot available to download above is based on an historical version of the code base.

.. rst-class:: agenda

Agenda
======

- SPARQL injection
- Data flow
- Modules and libraries
- Local data flow
- Local taint tracking

Motivation
==========

`SPARQL <https://en.wikipedia.org/wiki/SPARQL>`__ is a language for querying key-value databases in RDF format, which can suffer from SQL injection-like vulnerabilities:

.. code-block:: none

  sparqlAskQuery("ASK { <" + individualURI + "> ?p ?o }")

``individualURI`` is provided by a user, allowing an attacker to prematurely close the ``>``, and provide additional content.

**Goal**: Find query strings that are created by concatenation.

.. note::

  If you have completed the “Example: Query injection” slide deck which was part of the previous course, this example will look familiar to you.

  To understand the scope of this vulnerability, consider what would happen if a malicious user could provide the following as the content of the individualURI variable:

  ``“http://vivoweb.org/ontology/core#FacultyMember> ?p ?o . FILTER regex("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!", "(.*a){50}") } #``


Example: SPARQL injection
=========================

We can write a simple query that finds string concatenations that occur in calls SPARQL query APIs.

.. rst-class:: build

.. literalinclude:: ../query-examples/java/data-flow-java-1.ql
   :language: ql

.. note::

  This is similar, but not identical, to the formulation we had in the previous training deck. It has been rewritten to make it easier for the next step.

Success! But also missing results...
====================================

Query finds a CVE reported by Semmle (CVE-2019-6986), plus one other result, but misses other opportunities where:

  - String concatenation occurs on a different line in the same method.
  - String concatenation occurs in a different method.
  - String concatenation occurs through StringBuilders or similar.
  - Entirety of user input is provided as the query.

We want to improve our query to catch more of these cases.

.. note::

   For more details of the CVE, see: https://github.com/Semmle/SecurityExploits/tree/master/vivo-project/CVE-2019-6986

   As an example, consider this SPARQL query call:
   
   .. code-block:: none
   
      String queryString = "ASK { <" + individualURI + "> ?p ?o }";
       sparqlAskQuery(queryString);
   
   Here the concatenation occurs before the call, so the existing query would miss this - the string concatenation does not occur *directly* as the first argument of the call.

Data flow analysis
==================

- Models flow of data through the program.
- Implemented in the module ``semmle.code.java.dataflow.DataFlow``.
- Class ``DataFlow::Node`` represents program elements that have a value, such as expressions and function parameters.

  - Nodes of the data flow graph.

- Various predicated represent flow between these nodes.
  
  - Edges of the data flow graph.

.. note::

  The solution here is to use *data flow*. Data flow is, as the name suggests, about tracking the flow of data through the program. It helps answers questions like: *does this expression ever hold a value that originates from a particular other place in the program*?

  We can visualize the data flow problem as one of finding paths through a directed graph, where the nodes of the graph are elements in program, and the edges represent the flow of data between those elements. If a path exists, then the data flows between those two edges.

Local vs global data flow
=========================

- Local (“intra-procedural”) data flow models flow within one function; feasible to compute for all functions in a snapshot
- Global (“inter-procedural”) data flow models flow across function calls; not feasible to compute for all functions in a snapshot
- Different APIs, so discussed separately
- This slide deck focuses on the former.

.. note::

  For further information, see:

  - `Introduction to data flow analysis in QL <https://help.semmle.com/QL/learn-ql/ql/intro-to-data-flow.html>`__
  - `Analyzing data flow in Java <https://help.semmle.com/QL/learn-ql/ql/java/dataflow.html>`__

.. rst-class:: background2

Local data flow
===============

Importing data flow
===================

To use the data flow library, add the following import:

.. code-block:: ql

   import semmle.code.java.dataflow.DataFlow

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

  A **query library** is file with the extension ``.qll``. Query libraries do not contain a query clause, but may contain modules, classes, and predicates. For example, the `Java data flow library <https://help.semmle.com/qldoc/java/semmle/code/java/dataflow/DataFlow.qll/module.DataFlow.html>`__ is contained in the ``semmle/code/java/dataflow/DataFlow.qll`` QLL file, and can be imported as shown above.

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

  ``localFlowStep`` is the “single step” flow relation–that is, it describes single edges in the local data flow graph. ``localFlow`` represents the `transitive <https://help.semmle.com/QL/ql-handbook/recursion.html#transitive-closures>`__ closure of this relation–in other words, it contains every pair of nodes where the second node is reachable from the first in the data flow graph.

  The data flow graph is separate from the `AST <https://en.wikipedia.org/wiki/Abstract_syntax_tree>`__, to allow for flexibility in how data flow is modeled. There are a small number of data flow node types–expression nodes, parameter nodes, uninitialized variable nodes, and definition by reference nodes. Each node provides mapping functions to and from the relevant AST (for example ``Expr``, ``Parameter`` etc.) or symbol table (for example ``Variable``) classes.

Taint tracking
==============

- Usually, we want to generalise slightly by not only considering plain data flow, but also “taint” propagation, that is, whether a value is influenced by or derived from another.

- Examples:

  .. code-block:: java
  
    sink = source;        // source -> sink: data and taint
    strcat(sink, source); // source -> sink: taint, not data

- Library ``semmle.code.java.dataflow.TaintTracking`` provides predicates for tracking taint; ``TaintTracking::localTaintStep`` represents one (local) taint step, ``TaintTracking::localTaint`` is its transitive closure.

.. note::

  Taint tracking can be thought of as another type of data flow graph. It usually extends the standard data flow graph for a problem by adding edges between nodes where one one node influences or *taints* another.

  The `API <https://help.semmle.com/qldoc/java/semmle/code/java/dataflow/TaintTracking.qll/module.TaintTracking.html>`__ is almost identical to that of the local data flow. All we need to do to switch to taint tracking is ``import semmle.code.java.dataflow.TaintTracking`` instead of ``semmle.code.java.dataflow.DataFlow``, and instead of using ``localFlow``, we use ``localTaint``.

Exercise: revisiting SPARQL injection
=====================================

Refine the query to find string concatenation that occurs in the same method, but a different line.

**Hint**: Use ``DataFlow::localFlow`` to assert that the result flows to the SPARQL call argument, using ``DataFlow::exprNode`` to get the data flow nodes for the relevant expression nodes.

.. rst-class:: build

.. literalinclude:: ../query-examples/java/data-flow-java-2.ql
  :language: ql

Refinements (take home exercise)
================================

In Java, strings are often created using ``StringBuilder`` and ``StringBuffer`` classes. For example:

    .. code-block:: java
    
       StringBuilder queryBuilder = new StringBuilder();
       queryBuilder.add("ASK { <");
       queryBuilder.add(individualURI);
       queryBuilder.add("> ?p ?o }");
       sparqlAskQuery(queryBuilder);

**Exercise**: Refine the query to consider strings created from ``StringBuilder`` and ``StringBuffer`` classes as sources of concatenation.

Beyond local data flow
======================

- We are still missing possible results.

  - Concatenation that occurs outside the enclosing method.

- Instead, let’s turn the problem around and find user-controlled data that flows into a ``printf`` format argument, potentially through calls.
- This needs :doc:`global data flow <global-data-flow-java>`.