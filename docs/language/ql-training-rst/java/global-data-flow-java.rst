================================
Introduction to global data flow
================================

QL for Java

.. container:: semmle-logo

   Semmle :sup:`TM`

.. rst-class:: setup

Setup
=====

For this example you should download:

- `QL for Eclipse <https://help.semmle.com/ql-for-eclipse/Content/WebHelp/install-plugin-free.html>`__
- `Apache Struts snapshot <https://downloads.lgtm.com/snapshots/java/apache/struts/apache-struts-7fd1622-CVE-2018-11776.zip>`__

.. note::

   For this example, we will be analyzing `Apache Struts <https://github.com/apache/struts>`__.

   You can also query the project in `the query console <https://lgtm.com/query/project:1878521151/lang:java/>`__ on LGTM.com.

   Note that results generated in the query console are likely to differ to those generated in the QL plugin as LGTM.com analyzes the most recent revisions of each project that has been added–the snapshot available to download above is based on an historical version of the code base.

.. rst-class:: agenda

Agenda
======

- Global taint tracking
- Sanitizers
- Path queries
- Data flow models

Information flow
================

- Many security problems can be phrased as an information flow problem:

  Given a (problem-specific) set of sources and sinks, is there a path in the data flow graph from some source to some sink?

- Some examples:

  - SQL injection: sources are user-input, sinks are SQL queries
  - Reflected XSS: sources are HTTP requests, sinks are HTTP responses

- We can solve such problems using the data flow and taint tracking libraries.

Global data flow and taint tracking
===================================

- Recap:

  - Local (“intra-procedural”) data flow models flow within one function; feasible to compute for all functions in a snapshot
  - Global (“inter-procedural”) data flow models flow across function calls; not feasible to compute for all functions in a snapshot

- For global data flow (and taint tracking), we must therefore provided restrictions to ensure the problem is tractable.
- Typically, this involves specifying the *source* and *sink*.

.. note::

  As we mentioned in the previous slide deck, while local data flow is feasible to compute for all functions in a snapshot, global data flow is not. This is because the number of paths becomes exponentially larger for global data flow.

  The global data flow (and taint tracking) avoids this problem by requiring that the query author specifies which ``sources`` and ``sinks`` are applicable. This allows the implementation to compute paths between the restricted set of nodes, rather than the full graph.

Global taint-tracking library
=============================

The ``semmle.code.java.dataflow.TaintTracking`` library provides a framework for implementing solvers for global taint tracking problems:

  #. Subclass ``TaintTracking::Configuration`` following this template:

     .. code-block:: ql
    
       class Config extends TaintTracking::Configuration {
         Config() { this = "<some unique identifier>" }
         override predicate isSource(DataFlow::Node nd) { ... }
         override predicate isSink(DataFlow::Node nd) { ... }
       }

  #. Use ``Config.hasFlow(source, sink)`` to find inter-procedural paths.

.. note::

  In addition to the taint tracking configuration described here, there is also an equivalent *data flow* configuration in ``semmle.code.java.dataflow.DataFlow``, ``DataFlow::Configuration``. Data flow configurations are used to track whether the exact value produced by a source is used by a sink, whereas taint tracking configurations are used to determine whether the source may influence the value used at the sink. Whether you use taint tracking or data flow depends on the analysis problem you are trying to solve.

Code injection in Apache Struts
===============================

- In April 2018, Man Yue Mo, a security researcher at Semmle, reported 5 remote code execution (RCE) vulnerabilities (CVE-2018-11776) in Apache Struts.

- These vulnerabilities were caused by untrusted, unsanitized data being evaluated as an OGNL (Object Graph Navigation Library) expression, allowing malicious users to perform remote code execution.

- Conceptually, this is a global taint tracking problem - does untrusted remote input flow to a method call which evaluates OGNL?

.. note::

   More details on the CVE can be found here: https://lgtm.com/blog/apache_struts_CVE-2018-11776 and 
   https://github.com/Semmle/demos/tree/master/ql_demos/java/Apache_Struts_CVE-2018-11776

   More details on OGNL can be found here: https://commons.apache.org/proper/commons-ognl/

.. rst-class:: java-data-flow-code-example

Code example
============

Finding RCEs (outline)
======================

.. literalinclude:: ../query-examples/java/global-data-flow-java-1.ql
   :language: ql

Defining sources
================

We want to look for method calls where the method name is ``getNamespace()``, and the declaring type of the method is a class called ``ActionProxy``.

.. code-block:: ql

  import semmle.code.java.security.Security

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSource(DataFlow::Node source) {
      exists(Method m |
    	   m.getName() = "getNamespace" and
    	   m.getDeclaringType().getName() = "ActionProxy" and
    	   source.asExpr() = m.getAReference()
      )
    }
    ...
  }

.. note::

  We first define what it means to be a *source* of tainted data for this particular problem. In this case, we are interested in the value returned by calls to ``getNamespace()``.


Exercise: Defining sinks
========================

Fill in the definition of ``isSink``.

**Hint**: We want to find the first argument of calls to the method compileAndExecute.

.. code-block:: ql

  import semmle.code.java.security.Security

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSink(DataFlow::Node sink) {
      /* Fill me in */
    }
    ...
  }

.. note::

  The second part is to define what it means to be a sink for this particular problem. The queries from the previous slide deck will be useful for this exercise.

Solution: Defining sinks
========================

Find a method access to ``compileAndExecute``, and mark the first argument.

.. code-block:: ql

  import semmle.code.java.security.Security

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSink(DataFlow::Node sink) {
    	exists(MethodAccess ma |
        ma.getMethod().getName() = "compileAndExecute" and
        ma.getArgument(0) = sink.asExpr()
      )
    }
    ...
  }

Path queries
============

Path queries provide information about the identified paths from sources to sinks. Paths can be examined in Path Explorer view.

Use this template:

.. code-block:: ql

   /**
    * ... 
    * @kind path-problem
    */
   
   import semmle.code.java.dataflow.TaintTracking
   import DataFlow::PathGraph
   ...
   from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
   where cfg.hasFlowPath(source, sink)
   select sink, source, sink, "<message>"

.. note::

  To see the paths between the source and the sinks, we can convert the query to a path problem query. There are a few minor changes that need to be made for this to work - we need an additional import, to specify ``PathNode`` rather than ``Node``, and to add the source/sink to the query output (so that we can automatically determine the paths).

Defining sanitizers
===================

A sanitizer allows us to *prevent* flow through a particular node in the graph. For example, flows that go via ``ValueStackShadowMap`` are not particularly interesting, because it is a class that is rarely used in practice. We can exclude them like so:

.. code-block:: ql

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSanitizer(DataFlow::Node nd) {
      nd.getEnclosingCallable()
        .getDeclaringType()
        .getName() = "ValueStackShadowMap"
    }
    ...
  }

Defining additional taint steps
===============================

Add an additional taint step that (heuristically) taints a local variable if it is a pointer, and it is passed to a function in a parameter position that taints it.

.. code-block:: ql

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isAdditionalTaintStep(DataFlow::Node pred,
                                             DataFlow::Node succ) {
      exists(Field f, RefType t |
        node1.asExpr() = f.getAnAssignedValue() and
        node2.asExpr() = f.getAnAccess() and
        node1.asExpr().getEnclosingCallable().getDeclaringType() = t and
        node2.asExpr().getEnclosingCallable().getDeclaringType() = t
      )
    }
    ...
  }


.. rst-class:: end-slide

Extra slides
============

.. include:: ../slide-snippets/global-data-flow-extra-slides.rst
