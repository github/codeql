================================
Introduction to global data flow
================================

QL for C/C++

.. container:: semmle-logo

   Semmle :sup:`TM`
   
.. rst-class:: setup

Setup
=====

For this example you should download:

- `QL for Eclipse <https://help.semmle.com/ql-for-eclipse/Content/WebHelp/install-plugin-free.html>`__
- `dotnet/coreclr snapshot <http://downloads.lgtm.com/snapshots/cpp/dotnet/coreclr/dotnet_coreclr_fbe0c77.zip>`__

.. note::

   For the examples in this presentation, we will be analyzing `dotnet/coreclr <https://github.com/dotnet/coreclr>`__.

   You can query the project in `the query console <https://lgtm.com/query/projects:1505958977333/lang:cpp/>`__ on LGTM.com.

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

- For global data flow (and taint tracking), we must therefore provide restrictions to ensure the problem is tractable.
- Typically, this involves specifying the *source* and *sink*.

.. note::

  As we mentioned in the previous slide deck, while local data flow is feasible to compute for all functions in a snapshot, global data flow is not. This is because the number of paths becomes exponentially larger for global data flow.

  The global data flow (and taint tracking) avoids this problem by requiring that the query author specifies which ``sources`` and ``sinks`` are applicable. This allows the implementation to compute paths between the restricted set of nodes, rather than the full graph.

Global taint tracking library
=============================

The ``semmle.code.cpp.dataflow.TaintTracking`` library provides a framework for implementing solvers for global taint tracking problems:

  #. Subclass ``TaintTracking::Configuration`` following this template:

     .. code-block:: ql
    
       class Config extends TaintTracking::Configuration {
         Config() { this = "<some unique identifier>" }
         override predicate isSource(DataFlow::Node nd) { ... }
         override predicate isSink(DataFlow::Node nd) { ... }
       }

  #. Use ``Config.hasFlow(source, sink)`` to find inter-procedural paths.

.. note::

  In addition to the taint tracking configuration described here, there is also an equivalent *data flow* configuration in ``semmle.code.cpp.dataflow.DataFlow``, ``DataFlow::Configuration``. Data flow configurations are used to track whether the exact value produced by a source is used by a sink, whereas taint tracking configurations are used to determine whether the source may influence the value used at the sink. Whether you use taint tracking or data flow depends on the analysis problem you are trying to solve.

Finding tainted format strings (outline)
========================================

.. literalinclude:: ../query-examples/cpp/global-data-flow-cpp-1.ql
  :language: ql

.. note::

  Here’s the outline for a inter-procedural (that is, “global”) version of the tainted formatting strings query we saw in the previous slide deck. The same template will be applicable for most taint tracking problems.

Defining sources
================

The library class ``SecurityOptions`` provides a (configurable) model of what counts as user-controlled data:

.. code-block:: ql

  import semmle.code.cpp.security.Security

  class TaintedFormatConfig extends TaintTracking::Configuration {
    override predicate isSource(DataFlow::Node source) {
      exists (SecurityOptions opts |
        opts.isUserInput(source.asExpr(), _)
      )
    }
    ...
  }

.. note::

  We first define what it means to be a *source* of tainted data for this particular problem. In this case, what we care about is whether the format string can be provided by an external user to our application or service. As there are many such ways external data could be introduced into the system, the standard QL libraries for C/C++ include an extensible API for modeling user input. In this case, we will simply use the predefined set of *user inputs*, which includes arguments provided to command line applications.


Defining sinks (exercise)
=========================

Use the ``FormattingFunction`` class to fill in the definition of ``isSink``.

.. code-block:: ql

  import semmle.code.cpp.security.Security

  class TaintedFormatConfig extends TaintTracking::Configuration {
    override predicate isSink(DataFlow::Node sink) {
      /* Fill me in */
    }
    ...
  }

.. note::

  The second part is to define what it means to be a sink for this particular problem. The queries from the previous slide deck will be useful for this exercise.

Defining sinks (answer)
=======================

Use the ``FormattingFunction`` class, we can write the sink as:

.. code-block:: ql

  import semmle.code.cpp.security.Security

  class TaintedFormatConfig extends TaintTracking::Configuration {
    override predicate isSink(DataFlow::Node sink) {
      exists (FormattingFunction ff, Call c |
        c.getTarget() = ff and
        c.getArgument(ff.getFormatParameterIndex()) = sink.asExpr()
      )
    }
    ...
  }

.. note::

  When we run this query, we should find a single result. However, it is tricky to determine whether this result is a true positive (a “real” result) because our query only reports the source and the sink, and not the path through the graph between the two.

Path queries
============

Path queries provide information about the identified paths from sources to sinks. Paths can be examined in Path Explorer view.

Use this template:

.. code-block:: ql

   /**
    * ... 
    * @kind path-problem
    */
   
   import semmle.code.cpp.dataflow.TaintTracking
   import DataFlow::PathGraph
   ...
   from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
   where cfg.hasFlowPath(source, sink)
   select sink, source, sink, "<message>"

.. note::

  To see the paths between the source and the sinks, we can convert the query to a path problem query. There are a few minor changes that need to be made for this to work–we need an additional import, to specify ``PathNode`` rather than ``Node``, and to add the source/sink to the query output (so that we can automatically determine the paths).

Defining additional taint steps
===============================

Add an additional taint step that (heuristically) taints a local variable if it is a pointer, and it is passed to a function in a parameter position that taints it.

.. code-block:: ql

  class TaintedFormatConfig extends TaintTracking::Configuration {
    override predicate isAdditionalTaintStep(DataFlow::Node pred,
                                             DataFlow::Node succ) {
      exists (Call c, Expr arg, LocalVariable lv |
        arg = c.getAnArgument() and
        arg = pred.asExpr() and
        arg.getFullyConverted().getUnderlyingType() instanceof PointerType and
        arg = lv.getAnAccess() and
        succ.asUninitialized() = lv
      )
    }
    ...
  }

Defining sanitizers
===================

Add a sanitizer, stopping propagation at parameters of formatting functions, to avoid double-reporting:

.. code-block:: ql

  class TaintedFormatConfig extends TaintTracking::Configuration {
    override predicate isSanitizer(DataFlow::Node nd) {
      exists (FormattingFunction ff, int idx |
        idx = ff.getFormatParameterIndex() and
        nd = DataFlow::parameterNode(ff.getParameter(idx))
      )
    }
    ...
  }

Data flow models
================

- To provide models of data/taint flow through library functions, you can implement subclasses of ``DataFlowFunction`` (from ``semmle.code.cpp.models.interfaces.DataFlow``) and ``TaintFunction`` (from ``semmle.code.cpp.models.interfaces.Taint``), respectively

- Example: model of taint flow from third to first parameter of ``memcpy``

   .. code-block:: ql
   
      class MemcpyFunction extends TaintFunction {
            MemcpyFunction() { this.hasName("memcpy") }
            override predicate hasTaintFlow(FunctionInput i, FunctionOutput o) 
                i.isInParameter(2) and o.isOutParameterPointer(0)
            }
      }
   
.. note::

  See the API documentation for more details about ``FunctionInput`` and ``FunctionOutput``.

.. rst-class:: end-slide

Extra slides
============

.. include:: ../slide-snippets/global-data-flow-extra-slides.rst
